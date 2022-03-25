import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/file_notifier_provider.dart';
import 'package:txdx/providers/item_notifier_provider.dart';
import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as p;

import '../txdx/txdx_file.dart';
import 'shared_preferences_provider.dart';

class FileChangeEvent {
  final WatchEvent watchEvent;
  final String filename;
  
  FileChangeEvent(this.watchEvent, this.filename);
}

final fileWatcherProvider = StreamProvider.autoDispose<FileChangeEvent>((ref) async* {
  final filename = await ref.watch(todoTxtFilenameProvider.future);

  if (filename != null) {
    var watcher = FileWatcher(p.absolute(filename));

    await for (final event in watcher.events) {
      yield FileChangeEvent(event, filename);
    }
  }
});

final fileHasChangedProvider = FutureProvider.autoDispose<bool>((ref) async {
  final event = await ref.watch(fileWatcherProvider.future);

  final items = ref.read(itemsNotifierProvider);
  final areEqual = await TxDxFile.compareFileToDataEquality(event.filename, items);

  return !areEqual;
});

final fileWasChanged = StateProvider.autoDispose<bool>((ref) {
  final asyncHasChanged = ref.watch(fileHasChangedProvider);
  final autoReload = ref.watch(fileAutoReloadNotifierProvider);

  return asyncHasChanged.when(
      data: (hasChanged) {
        if (autoReload) {
          // Auto reload
          ref.read(itemsNotifierProvider.notifier).loadItemsFromDisk();
          return false;
        } else {
          return hasChanged;
        }
      },
      error: (_, __) => false,
      loading: () => false,
  );
});

final fileAutoReloadNotifierProvider = StateNotifierProvider<FileAutoReloadNotifier, bool>((ref) {
  final namespace = ref.watch(namespaceProvider);
  return FileAutoReloadNotifier('${namespace}_file_autoreload', ref.read);
});

class FileAutoReloadNotifier extends StateNotifier<bool> {
  FileAutoReloadNotifier(
      this.settingsKey,
      this.read
      ) : super(false) {
    // Can't await _initialize method.
    _initialize();
  }

  final Reader read;
  final String settingsKey;

  Future<void> _initialize() async {
    final prefs = await read(sharedPreferencesProvider.future);
    state = prefs.getBool(settingsKey) ?? false;
  }

  Future<void> setAutoReload(bool autoReload) async {
    state = autoReload;
    final prefs = await read(sharedPreferencesProvider.future);
    await prefs.setBool(settingsKey, autoReload);
  }
}