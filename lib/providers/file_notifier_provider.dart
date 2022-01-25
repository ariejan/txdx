import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_provider.dart';

final filenameNotifierProvider = StateNotifierProvider<FilenameNotifier, AsyncValue<String?>>(
      (ref) => FilenameNotifier(ref.read),
);

class FilenameNotifier extends StateNotifier<AsyncValue<String?>> {
  FilenameNotifier(this.read) : super(const AsyncValue<String?>.loading()) {
    // Can't await _initialize method.
    _initialize();
  }

  final Reader read;

  Future<void> _initialize() async {
    final prefs = await read(sharedPreferencesProvider.future);
    state = AsyncValue.data(prefs.getString('filename'));
  }

  Future<void> setFilename(String filename) async {
    state = AsyncValue.data(filename);
    final prefs = await read(sharedPreferencesProvider.future);
    await prefs.setString('filename', filename);
  }
}