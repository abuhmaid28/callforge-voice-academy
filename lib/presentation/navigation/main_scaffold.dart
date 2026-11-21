import 'package:flutter/material.dart';

import '../../core/audio/speech_service.dart';
import '../../core/di/service_locator.dart';
import '../../domain/repositories/progress_repository.dart';
import '../controllers/progress_controller.dart';
import '../screens/disclosure_studio_screen.dart';
import '../screens/floor_skills_screen.dart';
import '../screens/home_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/voice_arena_screen.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;

  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;
  late ProgressController _progressController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    final progressRepo = ServiceLocator.get<IProgressRepository>();
    _progressController = ProgressController(progressRepository: progressRepo);
    _progressController.loadProgress();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(progressController: _progressController),
      const VoiceArenaScreen(),
      const DisclosureStudioScreen(),
      const FloorSkillsScreen(),
      ProgressScreen(progressController: _progressController),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index != _currentIndex) {
            try {
              if (ServiceLocator.isRegistered<ISpeechService>()) {
                final speech = ServiceLocator.get<ISpeechService>();
                speech.cancelListening();
                speech.stopSpeaking();
              }
            } catch (_) {}
          }
          setState(() {
            _currentIndex = index;
          });
          if (index == 0 || index == 4) {
            _progressController.loadProgress();
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.record_voice_over_outlined),
            selectedIcon: Icon(Icons.record_voice_over_rounded),
            label: 'Arena',
          ),
          NavigationDestination(
            icon: Icon(Icons.gavel_outlined),
            selectedIcon: Icon(Icons.gavel_rounded),
            label: 'Disclosures',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune_rounded),
            label: 'Floor Skills',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}
