/// Lightweight dependency injection service locator for CALLFORGE.
class ServiceLocator {
  static final Map<Type, dynamic> _instances = {};

  /// Registers a singleton instance of type [T].
  static void registerSingleton<T>(T instance) {
    _instances[T] = instance;
  }

  /// Retrieves the registered instance of type [T].
  static T get<T>() {
    final instance = _instances[T];
    if (instance == null) {
      throw StateError('ServiceLocator: No instance registered for type $T.');
    }
    return instance as T;
  }

  /// Checks whether an instance of type [T] is registered.
  static bool isRegistered<T>() {
    return _instances.containsKey(T);
  }

  /// Clears all registered instances (primarily for testing).
  static void reset() {
    _instances.clear();
  }
}
