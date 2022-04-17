import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/files/file_notifier_provider.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';
import 'package:txdx/providers/settings/settings_provider.dart';
import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as p;

import '../../config/settings.dart';
import '../../txdx/txdx_file.dart';

class FileChangeEvent {
  final WatchEvent watchEvent;
  final String filename;
  
  FileChangeEvent(this.watchEvent, this.filename);
}

final fileWatcherProvider = StreamProvider.autoDispose<FileChangeEvent>((ref) async* {
  final file = await ref.watch(todoFileProvider.future);

  if (file != null) {
    final filename = file.path;
    var watcher = FileWatcher(p.absolute(filename));
    await for (final event in watcher.events) {
      yield FileChangeEvent(event, filename);
    }
  }
});

final fileHasChangedProvider = FutureProvider.autoDispose<bool>((ref) async {
  final event = await ref.watch(fileWatcherProvider.future);

  final items = ref.read(itemsNotifierProvider);
  final areEqual = await TxDxFile.compareFileToDataEquality(
      File(event.filename), items);

  return !areEqual;
});

final fileWasChanged = StateProvider.autoDispose<bool>((ref) {
  final asyncHasChanged = ref.watch(fileHasChangedProvider);
  final autoReload = ref.watch(settingsProvider).getBool(settingsFileAutoReload);

  return asyncHasChanged.when(
      data: (hasChanged) {
        if (hasChanged && autoReload) {
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