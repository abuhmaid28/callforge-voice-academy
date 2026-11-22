import 'package:flutter/material.dart';

import '../../core/audio/speech_service.dart';
import '../../core/constants/app_colors.dart';
import '../../core/di/service_locator.dart';
import '../../data/datasources/custom_offers_local_datasource.dart';
import '../../domain/entities/sales_scenario.dart';
import '../controllers/sales_lab_controller.dart';
import 'discovery_drill_screen.dart';
import 'objection_drill_screen.dart';
import 'product_fit_screen.dart';
import 'sales_simulator_screen.dart';

class SalesLabScreen extends StatefulWidget {
  const SalesLabScreen({super.key});

  @override
  State<SalesLabScreen> createState() => _SalesLabScreenState();
}

class _SalesLabScreenState extends State<SalesLabScreen>
    with SingleTickerProviderStateMixin {
  late SalesLabController _controller;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final customOffersDS =
        ServiceLocator.isRegistered<CustomOffersLocalDataSource>()
        ? ServiceLocator.get<CustomOffersLocalDataSource>()
        : null;

    _controller = SalesLabController(customOffersDataSource: customOffersDS);
    _controller.addListener(_onUpdate);
    _controller.init();

    _tabController = TabController(length: 4, vsync: this);
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onUpdate);
    _controller.dispose();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Mastery Lab'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Scenarios (48)'),
            Tab(text: 'Objection Drills (8)'),
            Tab(text: 'Discovery Drills (12)'),
            Tab(text: 'Product-Fit Tool'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildScenariosTab(),
          _buildObjectionDrillsTab(),
          _buildDiscoveryDrillsTab(),
          ProductFitScreen(
            customOffersDataSource: _controller.customOffersDataSource,
          ),
        ],
      ),
    );
  }

  Widget _buildScenariosTab() {
    final scenarios = _controller.filteredScenarios;

    return Column(
      children: [
        _buildSearchBar(),
        _buildCategoryPills(),
        Expanded(
          child: scenarios.isEmpty
              ? const Center(child: Text('No matching sales scenarios found.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: scenarios.length,
                  itemBuilder: (context, index) {
                    final scenario = scenarios[index];
                    return _buildScenarioCard(scenario);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search 48 sales scenarios...',
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _controller.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    _controller.setSearchQuery('');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (val) => _controller.setSearchQuery(val),
      ),
    );
  }

  Widget _buildCategoryPills() {
    final categories = [
      {'key': 'all', 'label': 'All (48)'},
      {'key': 'wireless_upgrade', 'label': 'Wireless (8)'},
      {'key': 'fiber_discovery', 'label': 'Fiber (8)'},
      {'key': 'add_a_line', 'label': 'Add-a-Line (8)'},
      {'key': 'landline_to_wireless', 'label': 'Landline (8)'},
      {'key': 'trade_in_eip', 'label': 'Trade-In (8)'},
      {'key': 'retention_care_to_sales', 'label': 'Retention (8)'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: categories.map((cat) {
          final isSelected = _controller.selectedCategory == cat['key'];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(cat['label']!),
              selected: isSelected,
              onSelected: (_) => _controller.setCategory(cat['key']!),
              selectedColor: AppColors.primary.withValues(alpha: 0.3),
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.primaryLight
                    : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildScenarioCard(SalesScenario scenario) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SalesSimulatorScreen(scenario: scenario),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      scenario.category.replaceAll('_', ' ').toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      scenario.difficulty.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                scenario.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Customer: ${scenario.profile.name} (${scenario.profile.tone})',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                scenario.profile.householdNeeds,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 4,
                    children: scenario.skillTags.take(2).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const Text(
                    'Start Call →',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildObjectionDrillsTab() {
    final drills = _controller.objectionDrills;
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: drills.length,
      itemBuilder: (context, index) {
        final drill = drills[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DRILL ${index + 1}: ${drill.skillTag.toUpperCase()}',
                      style: const TextStyle(
                        color: AppColors.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                      ),
                      onPressed: () {
                        final speechService =
                            ServiceLocator.get<ISpeechService>();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ObjectionDrillScreen(
                              speechService: speechService,
                              initialDrillId: drill.id,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Practice',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  drill.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '"${drill.customerObjection}"',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiscoveryDrillsTab() {
    final drills = _controller.discoveryDrills;
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: drills.length,
      itemBuilder: (context, index) {
        final drill = drills[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DISCOVERY DRILL ${index + 1}',
                      style: const TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                      ),
                      onPressed: () {
                        final speechService =
                            ServiceLocator.get<ISpeechService>();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DiscoveryDrillScreen(
                              speechService: speechService,
                              initialDrillId: drill.id,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Practice',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  drill.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  drill.customerContextHint,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
