import '../../domain/repositories/disclosure_repository.dart';
import '../datasources/disclosure_catalog.dart';
import '../datasources/disclosure_local_datasource.dart';
import '../models/disclosure_script.dart';

class DisclosureRepositoryImpl implements IDisclosureRepository {
  final DisclosureLocalDataSource localDataSource;

  DisclosureRepositoryImpl(this.localDataSource);

  @override
  Future<List<DisclosureScript>> getAllScripts() async {
    final customDrafts = await localDataSource.getUserDrafts();
    return [...customDrafts, ...DisclosureCatalog.standardDisclosures];
  }

  @override
  Future<DisclosureScript?> getScriptById(String id) async {
    final all = await getAllScripts();
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveUserDraft(DisclosureScript script) async {
    await localDataSource.saveUserDraft(script);
  }

  @override
  Future<void> deleteUserDraft(String id) async {
    await localDataSource.deleteUserDraft(id);
  }

  @override
  Future<void> resetToDefaults() async {
    await localDataSource.clearUserDrafts();
  }
}
