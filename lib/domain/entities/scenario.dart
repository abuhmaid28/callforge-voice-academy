import '../../core/constants/training_constants.dart';

/// Represents a training scenario or drill.
class Scenario {
  final String id;
  final String title;
  final int moduleIndex;
  final String customerPersona;
  final String
  expectedResponse; // Representative's required opening greeting (Turn 1)
  final String customerResponse; // Customer's spoken audio response upon receiving greeting (Turn 2)
  final List<String> requiredAnchors;
  final String contextNotes;

  const Scenario({
    required this.id,
    required this.title,
    required this.moduleIndex,
    required this.customerPersona,
    required this.expectedResponse,
    required this.customerResponse,
    required this.requiredAnchors,
    required this.contextNotes,
  });

  /// Backward-compatible alias for customer prompt
  String get customerPrompt => customerResponse;

  /// Factory for M1 Inbound Greeting Scenario (Representative Speaks First)
  static Scenario m1GreetingScenario() {
    return const Scenario(
      id: 'm1_inbound_greeting_01',
      title: 'Inbound Standard Greeting & Discovery Initiation',
      moduleIndex: 1,
      customerPersona: TrainingConstants.m1CustomerPersona,
      expectedResponse: TrainingConstants.standardGreeting,
      customerResponse: TrainingConstants.m1CustomerResponse,
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Inbound call arrives. Representative Alex must deliver the standard AT&T greeting first. Once verified, customer David Miller responds with a first-bill inquiry.',
    );
  }
}
