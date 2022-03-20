import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_provider.dart';

final todoTxtFilenameProvider = StateNotifierProvider<FilenameNotifier, AsyncValue<String?>>((ref) {
  final namespace = ref.watch(namespaceProvider);
  return FilenameNotifier('${namespace}_todotxt_filename', ref.read);
});

final archiveTxtFilenameProvider = StateNotifierProvider<FilenameNotifier, AsyncValue<String?>>((ref) {
  final namespace = ref.watch(namespaceProvider);
  return FilenameNotifier('${namespace}_archivetxt_filename', ref.read);
});

final archivingAvailableProvider = Provider<bool>((ref) {
  final asyncFilename = ref.watch(archiveTxtFilenameProvider);

  return asyncFilename.when(
      data: (filename) => filename != null && File(filename).existsSync(),
      error: (_, __) => false,
      loading: () => false,
  );
});

class FilenameNotifier extends StateNotifier<AsyncValue<String?>> {
  FilenameNotifier(
      this.settingsKey,
      this.read
    ) : super(const AsyncValue<String?>.loading()) {
    // Can't await _initialize method.
    _initialize();
  }

  final Reader read;
  final String settingsKey;

  Future<void> _initialize() async {
    final prefs = await read(sharedPreferencesProvider.future);
    state = AsyncValue.data(prefs.getString(settingsKey));
  }

  Future<void> setFilename(String filename) async {
    state = AsyncValue.data(filename);
    final prefs = await read(sharedPreferencesProvider.future);
    await prefs.setString(settingsKey, filename);
  }
}