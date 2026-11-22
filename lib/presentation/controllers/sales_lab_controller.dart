import 'package:flutter/foundation.dart';

import '../../core/evaluation/product_fit_engine.dart';
import '../../data/datasources/custom_offers_local_datasource.dart';
import '../../data/datasources/sales_scenario_catalog.dart';
import '../../data/datasources/sales_scenarios/discovery_drills.dart';
import '../../data/datasources/sales_scenarios/objection_drills.dart';
import '../../domain/entities/product_fit.dart';
import '../../domain/entities/sales_scenario.dart';

class SalesLabController extends ChangeNotifier {
  final CustomOffersLocalDataSource? customOffersDataSource;

  String _selectedCategory = 'all';
  String get selectedCategory => _selectedCategory;

  String _selectedDifficulty = 'all';
  String get selectedDifficulty => _selectedDifficulty;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  int _selectedTabIndex = 0; // 0: Scenarios, 1: Objection Drills, 2: Discovery Drills, 3: Product-Fit
  int get selectedTabIndex => _selectedTabIndex;

  List<UserPracticeOffer> _customOffers = [];
  List<UserPracticeOffer> get customOffers => List.unmodifiable(_customOffers);

  // Product Fit tool state
  ServiceType _fitSelectedService = ServiceType.wireless;
  ServiceType get fitSelectedService => _fitSelectedService;

  bool _fitIsFiberAvailable = true;
  bool get fitIsFiberAvailable => _fitIsFiberAvailable;

  int _fitLineCount = 1;
  int get fitLineCount => _fitLineCount;

  double _fitMaxBudget = 80.0;
  double get fitMaxBudget => _fitMaxBudget;

  final List<String> _fitPriorities = [];
  List<String> get fitPriorities => List.unmodifiable(_fitPriorities);

  List<ProductFitEvaluation> _latestFitEvaluations = [];
  List<ProductFitEvaluation> get latestFitEvaluations =>
      List.unmodifiable(_latestFitEvaluations);

  bool _isDisposed = false;

  SalesLabController({this.customOffersDataSource});

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  Future<void> init() async {
    loadCustomOffers();
    runProductFitEvaluation();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDifficulty(String difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  List<SalesScenario> get filteredScenarios {
    var list = SalesScenarioCatalog.allScenarios;

    if (_selectedCategory != 'all') {
      list = list
          .where(
            (s) => s.category.toLowerCase() == _selectedCategory.toLowerCase(),
          )
          .toList();
    }

    if (_selectedDifficulty != 'all') {
      list = list
          .where(
            (s) =>
                s.difficulty.toLowerCase() == _selectedDifficulty.toLowerCase(),
          )
          .toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((s) {
        return s.title.toLowerCase().contains(q) ||
            s.profile.name.toLowerCase().contains(q) ||
            s.profile.householdNeeds.toLowerCase().contains(q) ||
            s.skillTags.any((t) => t.toLowerCase().contains(q));
      }).toList();
    }

    return list;
  }

  List<ObjectionDrillItem> get objectionDrills =>
      SalesScenarioCatalog.allObjectionDrills;

  List<DiscoveryDrillItem> get discoveryDrills =>
      SalesScenarioCatalog.allDiscoveryDrills;

  void loadCustomOffers() {
    if (customOffersDataSource != null) {
      try {
        _customOffers = customOffersDataSource!.getCustomOffers();
        notifyListeners();
      } catch (_) {}
    }
  }

  Future<void> saveCustomOffer(UserPracticeOffer offer) async {
    if (customOffersDataSource != null) {
      await customOffersDataSource!.saveOffer(offer);
      loadCustomOffers();
    }
  }

  Future<void> deleteCustomOffer(String offerId) async {
    if (customOffersDataSource != null) {
      await customOffersDataSource!.deleteOffer(offerId);
      loadCustomOffers();
    }
  }

  // Product Fit parameters
  void setFitServiceType(ServiceType type) {
    _fitSelectedService = type;
    runProductFitEvaluation();
  }

  void setFitFiberAvailable(bool available) {
    _fitIsFiberAvailable = available;
    runProductFitEvaluation();
  }

  void setFitLineCount(int count) {
    _fitLineCount = count.clamp(1, 10);
    runProductFitEvaluation();
  }

  void setFitMaxBudget(double budget) {
    _fitMaxBudget = budget;
    runProductFitEvaluation();
  }

  void toggleFitPriority(String priority) {
    if (_fitPriorities.contains(priority)) {
      _fitPriorities.remove(priority);
    } else {
      _fitPriorities.add(priority);
    }
    runProductFitEvaluation();
  }

  void runProductFitEvaluation() {
    _latestFitEvaluations = ProductFitEngine.rankCatalog(
      expressedNeeds: _fitPriorities,
      budgetConstraint: _fitMaxBudget.toStringAsFixed(0),
      addressChecked: _fitIsFiberAvailable,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
