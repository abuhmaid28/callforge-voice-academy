import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/evaluation/product_fit_engine.dart';
import '../../data/datasources/custom_offers_local_datasource.dart';
import '../../domain/entities/product_fit.dart';

class ProductFitScreen extends StatefulWidget {
  final CustomOffersLocalDataSource? customOffersDataSource;

  const ProductFitScreen({super.key, this.customOffersDataSource});

  @override
  State<ProductFitScreen> createState() => _ProductFitScreenState();
}

class _ProductFitScreenState extends State<ProductFitScreen> {
  ServiceType _serviceType = ServiceType.wireless;
  bool _isFiberAvailable = true;
  double _budget = 75.0;
  final List<String> _selectedNeeds = ['hotspot', 'unlimited data'];

  List<ProductFitEvaluation> _evaluations = [];
  List<UserPracticeOffer> _customOffers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomOffers();
    _recalculateFit();
  }

  void _loadCustomOffers() {
    if (widget.customOffersDataSource != null) {
      _customOffers = widget.customOffersDataSource!.getCustomOffers();
    }
  }

  void _recalculateFit() {
    setState(() {
      _evaluations = ProductFitEngine.rankCatalog(
        expressedNeeds: _selectedNeeds,
        budgetConstraint: _budget.toStringAsFixed(0),
        addressChecked: _isFiberAvailable,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Needs → Fit → Value Tool')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCustomerSignalsCard(),
            const SizedBox(height: 16),
            const Text(
              'Matched Product Recommendations',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ..._evaluations.map((e) => _buildEvaluationCard(e)),
            const SizedBox(height: 24),
            _buildCustomOffersSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSignalsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceElevated),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Simulated Customer Profile',
            style: TextStyle(
              color: AppColors.primaryLight,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // Service Type
          const Text(
            'Target Category',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: ServiceType.values.map((type) {
              final selected = _serviceType == type;
              return ChoiceChip(
                label: Text(type.name.toUpperCase()),
                selected: selected,
                onSelected: (val) {
                  if (val) {
                    setState(() => _serviceType = type);
                    _recalculateFit();
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Fiber address switch
          Material(
            type: MaterialType.transparency,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Address Qualified for Fiber',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
              ),
              subtitle: const Text(
                'Turn OFF to simulate unverified address guardrail',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
              value: _isFiberAvailable,
              onChanged: (val) {
                setState(() => _isFiberAvailable = val);
                _recalculateFit();
              },
            ),
          ),
          const Divider(color: AppColors.surfaceElevated),
          // Budget slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Customer Max Budget',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              Text(
                '\$${_budget.round()}/mo',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: _budget,
            min: 30,
            max: 200,
            divisions: 17,
            onChanged: (val) {
              setState(() => _budget = val);
              _recalculateFit();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationCard(ProductFitEvaluation eval) {
    Color statusColor;
    String statusLabel;

    switch (eval.status) {
      case ProductFitStatus.strongFit:
        statusColor = AppColors.success;
        statusLabel = 'OPTIMAL FIT';
        break;
      case ProductFitStatus.conditionalFit:
        statusColor = AppColors.primary;
        statusLabel = 'COMPATIBLE';
        break;
      case ProductFitStatus.needsVerification:
        statusColor = const Color(0xFFF59E0B);
        statusLabel = 'REQUIRES VERIFICATION';
        break;
      case ProductFitStatus.unqualified:
        statusColor = AppColors.error;
        statusLabel = 'NOT RECOMMENDED';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  eval.product.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            eval.whyItFits,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          if (eval.whyItFitsArabic.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                eval.whyItFitsArabic,
                textDirection: TextDirection.rtl,
                style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 12),
              ),
            ),
          ],
          if (eval.recommendedTransitionPhrase.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.arrow_forward,
                  color: AppColors.primaryLight,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Spoken Transition: "${eval.recommendedTransitionPhrase}"',
                    style: const TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomOffersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Custom Practice Offers (On-Device)',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.primary),
              onPressed: _showCreateOfferDialog,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_customOffers.isEmpty)
          const Text(
            'No custom offers created yet. Tap + to author a fictional scenario offer.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          )
        else
          ..._customOffers.map(
            (o) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                o.title,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              subtitle: Text(
                o.details,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () async {
                  if (widget.customOffersDataSource != null) {
                    await widget.customOffersDataSource!.deleteOffer(o.id);
                    _loadCustomOffers();
                    setState(() {});
                  }
                },
              ),
            ),
          ),
      ],
    );
  }

  void _showCreateOfferDialog() {
    final titleController = TextEditingController();
    final priceController = TextEditingController(text: '50');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Add Custom Practice Offer',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Offer Title (e.g. Fiber 300 Practice)',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monthly Price (\$)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final price =
                  double.tryParse(priceController.text.trim()) ?? 50.0;
              if (title.isNotEmpty && widget.customOffersDataSource != null) {
                final offer = UserPracticeOffer(
                  id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
                  title: title,
                  details:
                      '\$${price.toStringAsFixed(0)}/mo fictional practice offer',
                  effectiveDate: DateTime.now(),
                  sourceNote: 'Self-created local practice offer',
                );
                await widget.customOffersDataSource!.saveOffer(offer);
                _loadCustomOffers();
                setState(() {});
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
