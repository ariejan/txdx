import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:txdx/providers/settings/shared_preferences_provider.dart';
import 'package:txdx/config/settings.dart';

import '../items/scoped_item_notifier.dart';

final namespaceProvider = Provider<String>((ref) {
  return kReleaseMode ? 'release' : 'debug';
});

final fileSettingsFutureProvider = FutureProvider<Settings>((ref) async {
  final namespace = ref.watch(namespaceProvider);
  final sharedPrefs = await ref.read(sharedPreferencesProvider.future);

  return Settings(namespace, sharedPrefs);
});

final interfaceSettingsFutureProvider = FutureProvider<Settings>((ref) async {
  final namespace = ref.watch(namespaceProvider);
  final sharedPrefs = await ref.read(sharedPreferencesProvider.future);

  return Settings(namespace, sharedPrefs);
});

final fileSettingsProvider = ChangeNotifierProvider<Settings>((ref) {
  return ref.watch(fileSettingsFutureProvider).maybeWhen(
    data: (settings) {
      return settings;
    },
    orElse: () => throw Exception('Settings uninitialized.')
  );
});

final interfaceSettingsProvider = ChangeNotifierProvider<Settings>((ref) {
  return ref.watch(interfaceSettingsFutureProvider).maybeWhen(
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

  void setStringSilently(String key, String value) {
    sharedPreferences.setString(_key(key), value);
  }

  void setString(String key, String value) {
    setStringSilently(key, value);
    notifyListeners();
  }

  String? getString(String key) {
    final theKey = _key(key);
    return sharedPreferences.getString(theKey) ?? defaultSettings[key] as String?;
  }

  void setItemStateSorter(String key, ItemStateSorter value) {
    setStringSilently(key, value.toString());
    notifyListeners();
  }

  ItemStateSorter? getItemStateSorter(String key) {
    final theKey = _key(key);

    final preferenceSort = sharedPreferences.getString(theKey);

    if (preferenceSort == null) {
      return defaultSettings[key] as ItemStateSorter;
    } else {
      return ItemStateSorter.values.firstWhere((e) => e.toString() == preferenceSort);
    }
  }

  void setBool(String key, bool value) {
    sharedPreferences.setBool(_key(key), value).then((_) => notifyListeners());
  }

  bool getBool(String key) {
    final theKey = _key(key);
    return sharedPreferences.getBool(theKey) ?? defaultSettings[key] as bool;
  }

  void setInt(String key, int value) {
    sharedPreferences.setInt(_key(key), value);
    notifyListeners();
  }

  int getInt(String key) {
    final theKey = _key(key);
    return sharedPreferences.getInt(theKey) ?? defaultSettings[key] as int;
  }

  String _key(String key) {
    return "${namespace}_$key";
  }
}

final isSetupReadyProvider = Provider<bool>((ref) {
  final txdxDir = ref.watch(fileSettingsProvider).getString(settingsTxDxDirectory);
  return txdxDir?.isNotEmpty ?? false;
});