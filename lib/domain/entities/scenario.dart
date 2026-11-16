import '../../core/constants/training_constants.dart';

/// Represents a training scenario or drill.
class Scenario {
  final String id;
  final String title;
  final int moduleIndex;
  final String customerPersona;
  final String customerPrompt;
  final String expectedResponse;
  final List<String> requiredAnchors;
  final String contextNotes;

  const Scenario({
    required this.id,
    required this.title,
    required this.moduleIndex,
    required this.customerPersona,
    required this.customerPrompt,
    required this.expectedResponse,
    required this.requiredAnchors,
    required this.contextNotes,
  });

  /// Factory for M1 Inbound Greeting Scenario
  static Scenario m1GreetingScenario() {
    return const Scenario(
      id: 'm1_inbound_greeting_01',
      title: 'Inbound Standard Greeting & Discovery Initiation',
      moduleIndex: 1,
      customerPersona: TrainingConstants.m1CustomerPersona,
      customerPrompt: TrainingConstants.m1CustomerPrompt,
      expectedResponse: TrainingConstants.standardGreeting,
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Fictional first-bill confusion call. The representative must execute the verified AT&T standard greeting verbatim.',
    );
  }
}
