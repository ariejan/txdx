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

final todoFileWatcherProvider = StreamProvider<FileChangeEvent>((ref) async* {
  final file = await ref.watch(todoFileProvider.future);

  if (file != null) {
    final filename = file.path;
    var watcher = FileWatcher(p.absolute(filename));
    await for (final event in watcher.events) {
      yield FileChangeEvent(event, filename);
    }
  }
});

final todoFileHasChangedProvider = FutureProvider<bool>((ref) async {
  final event = await ref.watch(todoFileWatcherProvider.future);

  final items = ref.read(todoItemsProvider);
  final areEqual = await TxDxFile.compareFileToDataEquality(
      File(event.filename), items);

  return !areEqual;
});

final todoFileWasChanged = StateProvider<bool>((ref) {
  final asyncHasChanged = ref.watch(todoFileHasChangedProvider);
  final autoReload = ref.watch(fileSettingsProvider).getBool(settingsFileAutoReload);

  return asyncHasChanged.when(
      data: (hasChanged) {
        if (hasChanged && autoReload) {
          ref.read(todoItemsProvider.notifier).loadItemsFromDisk();
          return false;
        } else {
          return hasChanged;
        }
      },
      error: (_, __) => false,
      loading: () => false,
  );
});

final archiveFileWatcherProvider = StreamProvider<FileChangeEvent>((ref) async* {
  final file = await ref.watch(archiveFileProvider.future);

  if (file != null) {
    final filename = file.path;
    var watcher = FileWatcher(p.absolute(filename));
    await for (final event in watcher.events) {
      yield FileChangeEvent(event, filename);
    }
  }
});

final archiveFileHasChangedProvider = FutureProvider<bool>((ref) async {
  final event = await ref.watch(archiveFileWatcherProvider.future);

  final items = ref.read(archiveItemsProvider);
  final areEqual = await TxDxFile.compareFileToDataEquality(
      File(event.filename), items);

  return !areEqual;
});

final archiveFileWasChanged = StateProvider<bool>((ref) {
  final asyncHasChanged = ref.watch(archiveFileHasChangedProvider);

  return asyncHasChanged.when(
    data: (hasChanged) {
      if (hasChanged) {
        ref.read(archiveItemsProvider.notifier).loadItemsFromDisk();
      }
      return false;
    },
    error: (_, __) => false,
    loading: () => false,
  );
});