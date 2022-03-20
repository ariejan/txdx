import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final namespaceProvider = Provider<String>((ref) {
  return kReleaseMode ? 'release' : 'debug';
});

final sharedPreferencesProvider = FutureProvider(
      (ref) async => SharedPreferences.getInstance(),
);