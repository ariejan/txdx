import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';
import 'package:txdx/providers/settings/settings_provider.dart';

import '../../config/settings.dart';

final todoFileProvider = FutureProvider<File?>((ref) async {
  if (Platform.isMacOS) {
    final _secureBookmarks = SecureBookmarks();
    final bookmark = ref.watch(settingsProvider).getString(settingsTodoTxtMacosSecureBookmark);
    if (bookmark != null) {
      final file = await _secureBookmarks.resolveBookmark(bookmark);
      await _secureBookmarks.startAccessingSecurityScopedResource(file);
      return file;
    }
  } else {
    final filename = ref.watch(settingsProvider).getString(settingsFileTodoTxt);
    if (filename != null && filename.isNotEmpty) {
      return File(filename);
    }
  }

  return null;
});


final archiveFileProvider = FutureProvider<File?>((ref) async {
  if (Platform.isMacOS) {
    final _secureBookmarks = SecureBookmarks();
    final bookmark = ref.watch(settingsProvider).getString(settingsArchiveTxtMacosSecureBookmark);
    if (bookmark != null) {
      final file = await _secureBookmarks.resolveBookmark(bookmark);
      await _secureBookmarks.startAccessingSecurityScopedResource(file);
      return file;
    }
  } else {
    final filename = ref.watch(settingsProvider).getString(settingsFileArchiveTxt);
    if (filename != null && filename.isNotEmpty) {
      return File(filename);
    }
  }

  return null;
});

final archivingAvailableProvider = Provider<bool>((ref) {
  return ref.watch(archiveFileProvider).maybeWhen(
      data: (file) => file != null,
      orElse: () => false,
  );
});
