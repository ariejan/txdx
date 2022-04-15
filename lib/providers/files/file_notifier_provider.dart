import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';
import 'package:txdx/providers/settings/settings_provider.dart';

import 'package:path/path.dart' as path;

import '../../config/settings.dart';

final txdxDirProvider = FutureProvider<String?>((ref) async {
  if (Platform.isMacOS) {
    final bookmark = ref.watch(settingsProvider).getString(settingsTxDxDirectoryMacosSecureBookmark);
    if (bookmark != null) {
      final _secureBookmarks = SecureBookmarks();
      final dir = await _secureBookmarks.resolveBookmark(bookmark);
      await _secureBookmarks.startAccessingSecurityScopedResource(dir);
      return dir.path;
    } else {
      return null;
    }
  } else {
    return ref.watch(settingsProvider).getString(settingsTxDxDirectory);
  }
});

final todoFileProvider = FutureProvider<File?>((ref) async {
  final todoFilename = ref.watch(settingsProvider).getString(settingsFileTodoTxt);
  final txdxDir = await ref.watch(txdxDirProvider.future);

  if (txdxDir == null || todoFilename == null) {
    return null;
  } else {
    final file = File(path.join(txdxDir, todoFilename));

    if (!file.existsSync()) {
      file.createSync();
    }

    return file;
  }
});

final archiveFileProvider = FutureProvider<File?>((ref) async {
  final archiveFilename = ref.watch(settingsProvider).getString(settingsFileArchiveTxt);
  final txdxDir = await ref.watch(txdxDirProvider.future);

  if (txdxDir == null || archiveFilename == null) {
    return null;
  } else {
    final file = File(path.join(txdxDir, archiveFilename));

    if (!file.existsSync()) {
      file.createSync();
    }

    return file;
  }
});

final archivingAvailableProvider = Provider<bool>((ref) {
  return ref.watch(archiveFileProvider).maybeWhen(
      data: (file) => file != null,
      orElse: () => false,
  );
});
