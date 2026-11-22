import '../../domain/entities/scenario.dart';
import 'speech_evaluator.dart';

/// Structured evaluation result for a multi-turn call simulation turn.
class MultiTurnEvaluationResult {
  final double score; // 0.0 to 100.0
  final bool isTargetMet;
  final List<String> matchedKeywords;
  final List<String> missingKeywords;
  final Map<String, bool> aerdBreakdown; // 'A', 'E', 'R', 'D'
  final List<String> pbConfusions;
  final String trainerFeedbackArabic;
  final String trainerFeedbackEnglish;
  final String? nextTurnId;

  const MultiTurnEvaluationResult({
    required this.score,
    required this.isTargetMet,
    required this.matchedKeywords,
    required this.missingKeywords,
    required this.aerdBreakdown,
    required this.pbConfusions,
    required this.trainerFeedbackArabic,
    required this.trainerFeedbackEnglish,
    this.nextTurnId,
  });

  /// Check whether all AERD components were demonstrated
  bool get isAerdComplete =>
      (aerdBreakdown['A'] ?? false) &&
      (aerdBreakdown['E'] ?? false) &&
      (aerdBreakdown['R'] ?? false) &&
      (aerdBreakdown['D'] ?? false);
}

/// Evaluates representative spoken turns during multi-turn call simulations.
/// Enforces token-aware keyword matching, AERD framework markers, and Egyptian Arabic coaching.
class MultiTurnEvaluator {
  // AERD Marker Lexicon for customer service and de-escalation
  static const List<String> _acknowledgeMarkers = [
    'hear',
    'see',
    'understand',
    'right',
    'got it',
    'certainly',
    'absolutely',
    'definitely',
    'of course',
  ];

  static const List<String> _empathyMarkers = [
    'understand',
    'sorry',
    'apologize',
    'frustrat',
    'hear you',
    'completely',
    'concern',
    'stress',
    'appreciate',
  ];

  static const List<String> _reassureMarkers = [
    'help',
    'resolve',
    'care',
    'fix',
    'assist',
    'protect',
    'hands',
    'promise',
    'ownership',
    'safe',
    'rest assured',
    'with you',
  ];

  static const List<String> _defuseDiscoverMarkers = [
    'look into',
    'look',
    'check',
    'review',
    'audit',
    'let us',
    'verify',
    'test',
    'explain',
    'break down',
    'breakdown',
    'together',
    'find out',
    'investigate',
    'examine',
  ];

  /// Evaluates an agent's spoken response on a given turn.
  static MultiTurnEvaluationResult evaluateTurn({
    required ScenarioTurn turn,
    required String agentTranscript,
  }) {
    final normalized = SpeechEvaluator.normalize(agentTranscript);
    final reference = SpeechEvaluator.normalize(turn.spokenText);

    // 1. Keyword Anchor Matching
    final matchedKeywords = <String>[];
    final missingKeywords = <String>[];

    for (final kw in turn.requiredKeywords) {
      final normKw = SpeechEvaluator.normalize(kw);
      if (_matchesKeyword(normalized, normKw)) {
        matchedKeywords.add(kw);
      } else {
        missingKeywords.add(kw);
      }
    }

    final double keywordRatio = turn.requiredKeywords.isEmpty
        ? 1.0
        : matchedKeywords.length / turn.requiredKeywords.length;

    // 2. AERD Scoring
    final bool hasA = _containsAnyMarker(normalized, _acknowledgeMarkers);
    final bool hasE = _containsAnyMarker(normalized, _empathyMarkers);
    final bool hasR = _containsAnyMarker(normalized, _reassureMarkers);
    final bool hasD = _containsAnyMarker(normalized, _defuseDiscoverMarkers);

    final aerdBreakdown = {'A': hasA, 'E': hasE, 'R': hasR, 'D': hasD};

    final int aerdCount = [hasA, hasE, hasR, hasD].where((b) => b).length;
    final double aerdRatio = aerdCount / 4.0;

    // 3. Text Similarity & Phonetic Analysis
    final double similarity = SpeechEvaluator.computeSimilarity(
      reference,
      normalized,
    );
    final List<String> pbConfusions = SpeechEvaluator.detectPbErrors(
      normalized,
    );

    // Composite Score: For greeting turns, 50% anchors + 50% alignment.
    // For conversational objection/resolution turns: 40% Keyword Anchors + 35% AERD + 25% Script Alignment
    final bool isGreetingTurn =
        turn.turnNumber == 1 && turn.speaker == TurnSpeaker.agent;
    final bool hasSpokenAudio = normalized.trim().isNotEmpty;

    final double rawScore = !hasSpokenAudio
        ? 0.0
        : isGreetingTurn
        ? (keywordRatio * 50.0) + (similarity * 50.0)
        : (keywordRatio * 40.0) + (aerdRatio * 35.0) + (similarity * 25.0);
    final double finalScore = (rawScore * 10).round() / 10;

    final bool isTargetMet = !hasSpokenAudio
        ? false
        : isGreetingTurn
        ? (missingKeywords.isEmpty && similarity >= 0.70)
        : (keywordRatio >= 0.6 && finalScore >= 55.0);

    // 4. Branch Resolution
    String? nextTurnId;
    if (turn.branches.isNotEmpty && hasSpokenAudio) {
      if (isGreetingTurn) {
        // MANDATORY GREETING PROGRESSION GATE (B1):
        // Only advance to customer response if Turn 1 greeting successfully met all anchors!
        if (isTargetMet) {
          nextTurnId = turn.branches.first.nextTurnId;
        } else {
          nextTurnId = null; // Stays on Turn 1; must retry
        }
      } else if (isTargetMet) {
        // Look for success/high branch or default
        final highBranch = turn.branches.firstWhere(
          (b) => b.conditionKey == 'success' || b.conditionKey == 'high_aerd',
          orElse: () => turn.branches.first,
        );
        nextTurnId = highBranch.nextTurnId;
      } else {
        // Look for retry/low branch
        final lowBranch = turn.branches.where(
          (b) =>
              b.conditionKey == 'retry' ||
              b.conditionKey == 'low_aerd' ||
              b.conditionKey == 'objection' ||
              b.conditionKey == 'refusal',
        );
        if (lowBranch.isNotEmpty) {
          nextTurnId = lowBranch.first.nextTurnId;
        } else {
          nextTurnId = null;
        }
      }
    }

    // 5. Egyptian Arabic Coaching
    final arabicFeedback = _generateArabicFeedback(
      turn: turn,
      isTargetMet: isTargetMet,
      aerdBreakdown: aerdBreakdown,
      missingKeywords: missingKeywords,
      pbConfusions: pbConfusions,
    );

    // 6. English Trainer Feedback
    final englishFeedback = _generateEnglishFeedback(
      isTargetMet: isTargetMet,
      aerdCount: aerdCount,
      missingKeywords: missingKeywords,
      pbConfusions: pbConfusions,
    );

    return MultiTurnEvaluationResult(
      score: finalScore.clamp(0.0, 100.0),
      isTargetMet: isTargetMet,
      matchedKeywords: matchedKeywords,
      missingKeywords: missingKeywords,
      aerdBreakdown: aerdBreakdown,
      pbConfusions: pbConfusions,
      trainerFeedbackArabic: arabicFeedback,
      trainerFeedbackEnglish: englishFeedback,
      nextTurnId: nextTurnId,
    );
  }

  static bool _matchesKeyword(String transcript, String keyword) {
    final lowerTranscript = transcript.toLowerCase();
    final lowerKeyword = keyword.trim().toLowerCase();
    if (lowerKeyword.isEmpty) return false;

    // Check AT&T spoken transcription variants with strict word boundaries
    if (lowerKeyword == 'att' ||
        lowerKeyword == 'at&t' ||
        lowerKeyword == 'at and t') {
      final attPattern = RegExp(
        r'\b(att|at and t|at t)\b',
        caseSensitive: false,
      );
      if (attPattern.hasMatch(lowerTranscript)) return true;
      if (lowerKeyword == 'att') return false; // Prevent fallback to substring
    }

    // Word boundary check to prevent substring false positives (e.g. 'att' in 'matter')
    final pattern = RegExp(
      r'\b' + RegExp.escape(lowerKeyword) + r'\b',
      caseSensitive: false,
    );
    if (pattern.hasMatch(lowerTranscript)) return true;

    // Multi-token phrase matching: check if tokens appear in contiguous sequence
    final kwTokens = lowerKeyword
        .split(' ')
        .where((t) => t.isNotEmpty)
        .toList();
    if (kwTokens.length > 1) {
      final transTokens = lowerTranscript
          .split(' ')
          .where((t) => t.isNotEmpty)
          .toList();
      for (int i = 0; i <= transTokens.length - kwTokens.length; i++) {
        bool matches = true;
        for (int j = 0; j < kwTokens.length; j++) {
          if (transTokens[i + j] != kwTokens[j]) {
            matches = false;
            break;
          }
        }
        if (matches) return true;
      }
    }

    return false;
  }

  static bool _containsAnyMarker(String transcript, List<String> markers) {
    final lowerTranscript = transcript.toLowerCase();
    for (final marker in markers) {
      final lowerMarker = marker.trim().toLowerCase();
      if (lowerMarker.isEmpty) continue;
      // Word-boundary prefix match (e.g. 'frustrat' matches 'frustrated' or 'frustrating')
      final pattern = RegExp(
        r'\b' + RegExp.escape(lowerMarker),
        caseSensitive: false,
      );
      if (pattern.hasMatch(lowerTranscript)) return true;
    }
    return false;
  }

  static String _generateArabicFeedback({
    required ScenarioTurn turn,
    required bool isTargetMet,
    required Map<String, bool> aerdBreakdown,
    required List<String> missingKeywords,
    required List<String> pbConfusions,
  }) {
    final buffer = StringBuffer();

    if (turn.trainerGuidanceArabic.isNotEmpty) {
      buffer.writeln(turn.trainerGuidanceArabic);
    }

    if (isTargetMet) {
      buffer.write(
        'أداء ممتاز! استجابتك احترافية وغطت النقاط الأساسية المطلوبة.',
      );
    } else {
      buffer.write('محاولة جيدة، لكن محتاج تركز على النقاط الناقصة:');
      if (missingKeywords.isNotEmpty) {
        buffer.write(
          ' اذكر الكلمات المفتاحية (${missingKeywords.join('، ')}).',
        );
      }
    }

    // AERD guidance
    final missingAerd = <String>[];
    if (aerdBreakdown['A'] == false) {
      missingAerd.add('الاعتراف بمشكلة العميل (Acknowledge)');
    }
    if (aerdBreakdown['E'] == false) {
      missingAerd.add('التعاطف الصادق (Empathy)');
    }
    if (aerdBreakdown['R'] == false) {
      missingAerd.add('التطمين وتحمل المسؤولية (Reassure)');
    }
    if (aerdBreakdown['D'] == false) {
      missingAerd.add('البحث والاستكشاف (Discover/Defuse)');
    }

    if (missingAerd.isNotEmpty) {
      buffer.write('\n💡 نصيحة الـ AERD: ركز على: ${missingAerd.join(' و ')}.');
    }

    // P/B alerts
    if (pbConfusions.isNotEmpty) {
      buffer.write(
        '\n⚠️ انتبه لنطق P و B: لا تبدل صوت P بصوت B في (${pbConfusions.join('، ')}).',
      );
    }

    return buffer.toString().trim();
  }

  static String _generateEnglishFeedback({
    required bool isTargetMet,
    required int aerdCount,
    required List<String> missingKeywords,
    required List<String> pbConfusions,
  }) {
    final buffer = StringBuffer();
    if (isTargetMet) {
      buffer.write(
        'Target response delivered successfully ($aerdCount/4 AERD markers).',
      );
    } else {
      buffer.write('Response needs strengthening.');
      if (missingKeywords.isNotEmpty) {
        buffer.write(' Missing anchors: ${missingKeywords.join(', ')}.');
      }
      buffer.write(' Demonstrated $aerdCount of 4 AERD pillars.');
    }

    if (pbConfusions.isNotEmpty) {
      buffer.write(' Flagged phonetic transfer: ${pbConfusions.join(', ')}.');
    }

    return buffer.toString();
  }
}
