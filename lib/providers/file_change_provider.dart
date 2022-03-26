import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/item_notifier_provider.dart';
import 'package:txdx/providers/settings_provider.dart';
import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as p;

import '../settings.dart';
import '../txdx/txdx_file.dart';

class FileChangeEvent {
  final WatchEvent watchEvent;
  final String filename;
  
  FileChangeEvent(this.watchEvent, this.filename);
}

final fileWatcherProvider = StreamProvider.autoDispose<FileChangeEvent>((ref) async* {
  final filename = ref.watch(settingsProvider).getString(settingsFileTodoTxt);

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