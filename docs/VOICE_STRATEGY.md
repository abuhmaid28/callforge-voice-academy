# VOICE_STRATEGY.md — Speech Pipeline, Phonetic Strategy, & Evaluation Logic

This document specifies the end-to-end voice architecture, speech recognition and synthesis integration, phonetic evaluation algorithms, and linguistic coaching methodologies for CALLFORGE.

---

## 1. Principles of Voice in CALLFORGE

1. **Local-First & Zero Required Subscription**: The core voice loop must operate using the Android platform's native speech recognition and synthesis subsystems without requiring paid API tokens (OpenAI, ElevenLabs, Azure, Google Cloud Speech API).
2. **Deterministic, Evidence-Based Evaluation**: We reject ungrounded "black box AI scores" (such as claiming a 93% native accent score without phonetic evidence). Feedback must be rooted in actual transcribed tokens, omissions, insertions, phonetic confusion pairs, and words-per-minute (WPM) cadence.
3. **Targeted Phonetic Intervention for Egyptian Speakers**: Specifically designed to address the Arabic-to-English phonological interference patterns (most notably the bilabial voiceless stop `/p/` vs voiced stop `/b/`).

---

## 2. Text-to-Speech (TTS) Strategy — The American Caller

### Engine & Configuration
- **Package**: `flutter_tts` communicating with native Android `android.speech.tts.TextToSpeech`.
- **Locale**: `en-US`.
- **Voice Pitch & Speech Rate**:
  - Calm inquiry: Rate `0.48`, Pitch `1.0`.
  - Hurried / Impatient customer: Rate `0.54`, Pitch `1.05`.
  - Frustrated / Angry customer: Rate `0.52`, Pitch `0.92`.
- **Interruption Handling**:
  - When a scenario is paused, reset, or Alex interrupts, the TTS engine must execute `tts.stop()` immediately to prevent audio overlap.

---

## 3. Speech-to-Text (STT) Strategy — Representative Alex

### Engine & Configuration
- **Package**: `speech_to_text` communicating with native Android `android.speech.SpeechRecognizer`.
- **Locale**: `en_US`.
- **Listening Modes**:
  - `listenMode: ListenMode.confirmation` or `ListenMode.dictation`.
  - Pause duration: 2.5 seconds of silence automatically triggers analysis.
- **Microphone Permissions & Audio Focus**:
  - Runtime request of `android.permission.RECORD_AUDIO`.
  - Proper audio focus acquisition to mute background system media while Alex is speaking.

---

## 4. Evidence-Based Evaluation Engine

### 4.1. Verbatim & Similarity Matching
For mandatory scripts (such as the standard greeting and legal disclosures), precision is paramount.

- **Normalization**:
  - Lowercase all tokens.
  - Strip punctuation (`.`, `,`, `?`, `!`, `-`, `'`).
  - Normalize whitespace.
- **Levenshtein Distance**:
  - Computes the minimum number of single-character edits (insertions, deletions, substitutions) required to transform candidate string $S_{\text{cand}}$ into reference string $S_{\text{ref}}$.
- **Word Error Rate (WER)**:
  $$\text{WER} = \frac{S + D + I}{N}$$
  Where:
  - $S$ = Word substitutions
  - $D$ = Word deletions (omitted required words)
  - $I$ = Word insertions (extra unscripted words)
  - $N$ = Total words in reference script

### 4.2. Mandatory Keyword Compliance Check
For the inbound greeting:
- Target: *"Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?"*
- Required Semantic Anchors:
  - `at&t` or `att`
  - `alex`
  - `first`
  - `last`
  - `name`
- Pass threshold: All required anchors present + similarity $\ge 80\%$.

### 4.3. Phonetic Contrast Detector (P vs. B)
Arabic phonology possesses the voiced bilabial stop `/b/` (ب) but lacks the voiceless bilabial stop `/p/`. Arabic speakers frequently produce `/b/` in place of `/p/`.

In call center operations, confusing P and B can cause serious customer confusion:
- *"Bayment"* instead of *"Payment"*
- *"Blan"* instead of *"Plan"*
- *"Broblem"* instead of *"Problem"*
- *"Brice"* instead of *"Price"*
- *"Baperless"* instead of *"Paperless"*

When the STT engine transcribes a word with a B substitution where a P word is expected, the evaluation engine flags this as a **Phonemic Bilabial Transfer Error** and renders targeted coaching:
- **Egyptian Arabic Coaching Prompt**:
  > *"خد بالك! نطقت كلمة 'Plan' كأنها 'Blan'. في الإنجليزي الأمريكي حرف الـ P مهم جداً ومختلف عن الـ B. عشان تنطق P صح، اضغط شفايفك وطلع دفعة هوا واضحة (Aspiration) كأنك بتطفي شمعة، ومتهزش أحبالك الصوتية."*

---

## 5. Offline Resilience & Graceful Degradation

1. **Offline Android Recognizer**: If the Android device has the offline English (US) voice package installed in Google Speech Services, STT functions completely without internet connection.
2. **Simulated Fallback Mode**: In automated headless test environments where microphone hardware or Google Play Services is absent, the STT and TTS services provide mockable interfaces (`FakeSpeechService`, `MockAudioRecorder`) to allow 100% test coverage without hardware dependency.
