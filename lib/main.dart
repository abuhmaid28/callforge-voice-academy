import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/audio/speech_service.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/attempt_local_datasource.dart';
import 'data/repositories/attempt_repository_impl.dart';
import 'presentation/controllers/simulator_controller.dart';
import 'presentation/screens/simulator_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize offline local storage
  final prefs = await SharedPreferences.getInstance();
  final localDataSource = AttemptLocalDataSource(prefs);
  final repository = AttemptRepositoryImpl(localDataSource);

  // Initialize Speech Subsystem
  final speechService = NativeSpeechService();

  // Initialize Controller
  final simulatorController = SimulatorController(
    speechService: speechService,
    repository: repository,
  );

  runApp(CallForgeApp(controller: simulatorController, repository: repository));
}

class CallForgeApp extends StatelessWidget {
  final SimulatorController controller;
  final AttemptRepositoryImpl repository;

  const CallForgeApp({
    super.key,
    required this.controller,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CALLFORGE — Voice Academy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: SimulatorScreen(controller: controller, repository: repository),
    );
  }
}
