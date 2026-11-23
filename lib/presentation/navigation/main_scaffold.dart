import 'package:flutter/material.dart';

import '../../core/audio/speech_service.dart';
import '../../core/di/service_locator.dart';
import '../../domain/repositories/progress_repository.dart';
import '../controllers/progress_controller.dart';
import '../screens/disclosure_studio_screen.dart';
import '../screens/floor_skills_screen.dart';
import '../screens/home_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/sales_lab_screen.dart';
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
  final GlobalKey<DisclosureStudioScreenState> _disclosureKey =
      GlobalKey<DisclosureStudioScreenState>();
  final GlobalKey<FloorSkillsScreenState> _floorSkillsKey =
      GlobalKey<FloorSkillsScreenState>();

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

  Future<void> _handleDestinationSelected(int index) async {
    if (index != _currentIndex) {
      if (_currentIndex == 2) {
        _disclosureKey.currentState?.resetAudioSession();
      } else if (_currentIndex == 3) {
        _floorSkillsKey.currentState?.resetAudioSession();
      }

      if (ServiceLocator.isRegistered<ISpeechService>()) {
        try {
          final speech = ServiceLocator.get<ISpeechService>();
          await speech.cancelListening();
          await speech.stopSpeaking();
        } catch (_) {}
      }
    }
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
      if (index == 0 || index == 5) {
        _progressController.loadProgress();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(progressController: _progressController),
      const VoiceArenaScreen(),
      DisclosureStudioScreen(key: _disclosureKey),
      FloorSkillsScreen(key: _floorSkillsKey),
      const SalesLabScreen(),
      ProgressScreen(progressController: _progressController),
    ];

    final isWide = MediaQuery.of(context).size.width >= 640;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: _handleDestinationSelected,
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: Text('Today'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.record_voice_over_outlined),
                  selectedIcon: Icon(Icons.record_voice_over_rounded),
                  label: Text('Arena'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.gavel_outlined),
                  selectedIcon: Icon(Icons.gavel_rounded),
                  label: Text('Disclosures'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.tune_outlined),
                  selectedIcon: Icon(Icons.tune_rounded),
                  label: Text('Floor Skills'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.storefront_outlined),
                  selectedIcon: Icon(Icons.storefront_rounded),
                  label: Text('Sales Lab'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart_rounded),
                  label: Text('Progress'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: IndexedStack(index: _currentIndex, children: screens),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _handleDestinationSelected,
        destinations: const [
          NavigationDestination(
            key: Key('nav_today'),
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Today',
          ),
          NavigationDestination(
            key: Key('nav_arena'),
            icon: Icon(Icons.record_voice_over_outlined),
            selectedIcon: Icon(Icons.record_voice_over_rounded),
            label: 'Arena',
          ),
          NavigationDestination(
            key: Key('nav_disclosures'),
            icon: Icon(Icons.gavel_outlined),
            selectedIcon: Icon(Icons.gavel_rounded),
            label: 'Disclosures',
          ),
          NavigationDestination(
            key: Key('nav_floor_skills'),
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune_rounded),
            label: 'Floor Skills',
          ),
          NavigationDestination(
            key: Key('nav_sales_lab'),
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded),
            label: 'Sales Lab',
          ),
          NavigationDestination(
            key: Key('nav_progress'),
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}
