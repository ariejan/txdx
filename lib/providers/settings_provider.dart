import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:txdx/providers/shared_preferences_provider.dart';

final namespaceProvider = Provider<String>((ref) {
  return kReleaseMode ? 'release' : 'debug';
});

final settingsFutureProvider = FutureProvider<Settings>((ref) async {
  final namespace = ref.watch(namespaceProvider);
  final sharedPrefs = await ref.read(sharedPreferencesProvider.future);

  return Settings(namespace, ref.read, sharedPrefs);
});

final settingsProvider = Provider<Settings>((ref) {
  return ref.watch(settingsFutureProvider).maybeWhen(
    data: (s) => s,
    orElse: () => throw Exception('Settings uninitialized.')
  );
});

class Settings {
  Settings(this.namespace, this.read, this.sharedPreferences);

  final String namespace;
  final Reader read;

  final SharedPreferences sharedPreferences;

  void setString(String key, String value) {
    sharedPreferences.setString(key, value);
  }

  String? getString(String key) {
    return sharedPreferences.getString(_key(key));
  }

  String getStringOrDefault(String key, String defaultValue) {
    return getString(key) ?? defaultValue;
  }

  void setBool(String key, bool value) {
    sharedPreferences.setBool(key, value);
  }

  bool? getBool(String key) {
    return sharedPreferences.getBool(_key(key));
  }

  bool getBoolOrDefault(String key, bool defaultValue) {
    return getBool(key) ?? defaultValue;
  }

  String _key(String key) {
    return "${namespace}_$key";
  }
}