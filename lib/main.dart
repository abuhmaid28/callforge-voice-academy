import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/audio/speech_service.dart';
import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/attempt_local_datasource.dart';
import 'data/datasources/custom_offers_local_datasource.dart';
import 'data/datasources/disclosure_local_datasource.dart';
import 'data/datasources/progress_local_datasource.dart';
import 'data/repositories/attempt_repository_impl.dart';
import 'data/repositories/disclosure_repository_impl.dart';
import 'data/repositories/progress_repository_impl.dart';
import 'domain/repositories/attempt_repository.dart';
import 'domain/repositories/disclosure_repository.dart';
import 'domain/repositories/progress_repository.dart';
import 'presentation/controllers/simulator_controller.dart';
import 'presentation/navigation/main_scaffold.dart';
import 'presentation/screens/simulator_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize offline local storage
  final prefs = await SharedPreferences.getInstance();

  // Register core dependencies in ServiceLocator
  final speechService = NativeSpeechService();
  ServiceLocator.registerSingleton<ISpeechService>(speechService);

  final attemptDataSource = AttemptLocalDataSource(prefs);
  final attemptRepo = AttemptRepositoryImpl(attemptDataSource);
  ServiceLocator.registerSingleton<IAttemptRepository>(attemptRepo);
  ServiceLocator.registerSingleton<AttemptRepositoryImpl>(attemptRepo);

  final disclosureDataSource = DisclosureLocalDataSource(prefs);
  final disclosureRepo = DisclosureRepositoryImpl(disclosureDataSource);
  ServiceLocator.registerSingleton<IDisclosureRepository>(disclosureRepo);

  final progressDataSource = ProgressLocalDataSource(prefs);
  final progressRepo = ProgressRepositoryImpl(progressDataSource);
  ServiceLocator.registerSingleton<IProgressRepository>(progressRepo);

  final customOffersDataSource = CustomOffersLocalDataSource(prefs);
  ServiceLocator.registerSingleton<CustomOffersLocalDataSource>(
    customOffersDataSource,
  );

  runApp(const CallForgeApp(home: MainScaffold()));
}

class CallForgeApp extends StatelessWidget {
  final SimulatorController? controller;
  final AttemptRepositoryImpl? repository;
  final Widget? home;

  const CallForgeApp({super.key, this.controller, this.repository, this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CALLFORGE — Voice Academy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home:
          home ??
          (controller != null && repository != null
              ? SimulatorScreen(
                  controller: controller!,
                  repository: repository!,
                )
              : const MainScaffold()),
    );
  }
}
