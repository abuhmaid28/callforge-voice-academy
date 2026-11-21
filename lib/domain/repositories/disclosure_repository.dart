import '../../data/models/disclosure_script.dart';

abstract class IDisclosureRepository {
  /// Retrieves all disclosure scripts (standard built-in plus user local drafts).
  Future<List<DisclosureScript>> getAllScripts();

  /// Retrieves a specific script by ID.
  Future<DisclosureScript?> getScriptById(String id);

  /// Saves a custom local user draft disclosure.
  Future<void> saveUserDraft(DisclosureScript script);

  /// Deletes a custom local user draft disclosure.
  Future<void> deleteUserDraft(String id);

  /// Resets to default built-in scripts.
  Future<void> resetToDefaults();
}
