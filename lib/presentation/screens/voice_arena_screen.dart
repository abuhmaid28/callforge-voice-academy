import 'package:flutter/material.dart';

import '../../data/datasources/scenario_catalog.dart';
import '../../domain/entities/scenario.dart';
import 'multi_turn_simulator_screen.dart';

class VoiceArenaScreen extends StatefulWidget {
  const VoiceArenaScreen({super.key});

  @override
  State<VoiceArenaScreen> createState() => _VoiceArenaScreenState();
}

class _VoiceArenaScreenState extends State<VoiceArenaScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Billing & Payments',
    'Technical Care',
    'De-escalation & Retention',
    'Sales & Discovery',
    'Account Floor Care',
  ];

  @override
  Widget build(BuildContext context) {
    final allScenarios = ScenarioCatalog.allScenarios;

    final filtered = allScenarios.where((s) {
      final matchesCat =
          _selectedCategory == 'All' || s.category == _selectedCategory;
      final matchesSearch =
          _searchQuery.isEmpty ||
          s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.customerPersona.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          s.skillTags.any(
            (t) => t.toLowerCase().contains(_searchQuery.toLowerCase()),
          );
      return matchesCat && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('30-Scenario Voice Arena')),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search scenarios by topic, customer, or skill...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),

          // Category Chips
          SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 6),

          // Scenarios List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final scenario = filtered[index];
                return _buildScenarioCard(context, scenario);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(BuildContext context, Scenario scenario) {
    final theme = Theme.of(context);

    Color diffColor;
    switch (scenario.difficulty.toLowerCase()) {
      case 'beginner':
        diffColor = Colors.green;
        break;
      case 'advanced':
        diffColor = Colors.red.shade400;
        break;
      case 'intermediate':
      default:
        diffColor = Colors.amber;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.15)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiTurnSimulatorScreen(scenario: scenario),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A3E0).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        scenario.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00A3E0),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: diffColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      scenario.difficulty.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: diffColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                scenario.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      scenario.customerPersona,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6.0,
                runSpacing: 4.0,
                children: scenario.skillTags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
