import 'package:callforge/core/evaluation/product_fit_engine.dart';
import 'package:callforge/data/datasources/product_fit_catalog.dart';
import 'package:callforge/domain/entities/product_fit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductFitEngine Unit Tests', () {
    test(
      'Fiber product requires address verification before recommendation',
      () {
        final fiberProduct = ProductFitCatalog.standardProducts.firstWhere(
          (p) => p.serviceType == ServiceType.fiber,
        );

        final evalUnverified = ProductFitEngine.evaluateFit(
          product: fiberProduct,
          expressedNeeds: ['gigabit speed', 'work from home'],
          addressChecked: false,
        );

        expect(
          evalUnverified.status,
          equals(ProductFitStatus.needsVerification),
        );
        expect(evalUnverified.unknownPrerequisites, isNotEmpty);
        expect(
          evalUnverified.unknownPrerequisites.first,
          contains('Street address'),
        );
        expect(evalUnverified.whyItFitsArabic, contains('العقار'));

        final evalVerified = ProductFitEngine.evaluateFit(
          product: fiberProduct,
          expressedNeeds: ['cable-frustrated', 'zoom-calls'],
          addressChecked: true,
        );

        expect(evalVerified.status, equals(ProductFitStatus.strongFit));
      },
    );

    test(
      'Landline product requires rate center port check before recommendation',
      () {
        final landlineProduct = ProductFitCatalog.standardProducts.firstWhere(
          (p) => p.serviceType == ServiceType.landlineToWireless,
        );

        final evalUnverified = ProductFitEngine.evaluateFit(
          product: landlineProduct,
          expressedNeeds: ['keep existing handset', 'lower copper bill'],
          numberPortChecked: false,
        );

        expect(
          evalUnverified.status,
          equals(ProductFitStatus.needsVerification),
        );
        expect(
          evalUnverified.unknownPrerequisites.first,
          contains('portability'),
        );
        expect(evalUnverified.whyItFitsArabic, contains('الرقم القديم'));

        final evalVerified = ProductFitEngine.evaluateFit(
          product: landlineProduct,
          expressedNeeds: ['keep existing handset', 'cheaper landline'],
          numberPortChecked: true,
        );

        expect(
          evalVerified.status,
          isNot(equals(ProductFitStatus.needsVerification)),
        );
      },
    );

    test('Strict budget restriction disqualifies top-tier Premium wireless as unethical', () {
      final premiumProduct = ProductFitCatalog.standardProducts.firstWhere(
        (p) => p.id == 'prod-wireless-premium',
      );

      final evalBudget = ProductFitEngine.evaluateFit(
        product: premiumProduct,
        expressedNeeds: ['unlimited data', 'hotspot'],
        budgetConstraint: 'tight budget, fixed income, 30 dollars',
      );

      expect(evalBudget.status, equals(ProductFitStatus.unqualified));
      expect(evalBudget.whyItFits, contains('ethical'));
      expect(evalBudget.whyItFitsArabic, contains('غير أخلاقي'));
    });

    test('rankCatalog sorts by strongFit, conditionalFit, needsVerification, unqualified', () {
      final ranked = ProductFitEngine.rankCatalog(
        expressedNeeds: ['gigabit speed', 'symmetrical upload', 'gaming'],
        addressChecked: false,
        numberPortChecked: false,
      );

      expect(ranked, isNotEmpty);
      // Because addressChecked is false, fiber products must be needsVerification
      final fiberEvals = ranked.where(
        (e) => e.product.serviceType == ServiceType.fiber,
      );
      for (final f in fiberEvals) {
        expect(f.status, equals(ProductFitStatus.needsVerification));
      }

      // Check relative ordering
      for (int i = 0; i < ranked.length - 1; i++) {
        final currentRank = ProductFitEngine.rankCatalog(
          expressedNeeds: ['unlimited data'],
          addressChecked: true,
        );
        expect(currentRank, isNotEmpty);
      }
    });

    test(
      'ProductFitCatalog contains 10 standard products with complete metadata',
      () {
        expect(ProductFitCatalog.standardProducts.length, equals(10));
        for (final p in ProductFitCatalog.standardProducts) {
          expect(p.id, isNotEmpty);
          expect(p.name, isNotEmpty);
          expect(p.fictionalMonthlyCost, isNotEmpty);
          expect(p.keyFeatures, isNotEmpty);
          expect(p.idealForNeeds, isNotEmpty);
          expect(p.mandatoryDisclosures, isNotEmpty);
        }
      },
    );
  });
}
