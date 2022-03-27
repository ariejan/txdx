import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:txdx/providers/shared_preferences_provider.dart';
import 'package:txdx/settings.dart';

final namespaceProvider = Provider<String>((ref) {
  return kReleaseMode ? 'release' : 'debug';
});

final settingsFutureProvider = FutureProvider<Settings>((ref) async {
  final namespace = ref.watch(namespaceProvider);
  final sharedPrefs = await ref.read(sharedPreferencesProvider.future);

  return Settings(namespace, sharedPrefs);
});

final settingsProvider = ChangeNotifierProvider<Settings>((ref) {
  return ref.watch(settingsFutureProvider).maybeWhen(
    data: (settings) {
      return settings;
    },
    orElse: () => throw Exception('Settings uninitialized.')
  );
});

class Settings extends ChangeNotifier {
  Settings(this.namespace, this.sharedPreferences);


  final String namespace;

  final SharedPreferences sharedPreferences;

  void setString(String key, String value) {
    sharedPreferences.setString(_key(key), value);
    notifyListeners();
  }

  String? getString(String key) {
    final theKey = _key(key);
    return sharedPreferences.getString(theKey) ?? defaultSettings[key] as String?;
  }

  void setBool(String key, bool value) {
    sharedPreferences.setBool(_key(key), value).then((_) => notifyListeners());
  }

  bool getBool(String key) {
    final theKey = _key(key);
    return sharedPreferences.getBool(theKey) ?? defaultSettings[key] as bool;
  }

  String _key(String key) {
    return "${namespace}_$key";
  }
}