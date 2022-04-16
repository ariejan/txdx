import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';
import 'package:path_provider/path_provider.dart';

import '../config/settings.dart';
import '../providers/settings/settings_provider.dart';

void pickTxDxDirectory(WidgetRef ref) {
  pickDir().then((dirname) async {
    if (Platform.isMacOS && dirname != null) {
      final _secureBookmarks = SecureBookmarks();
      final bookmark = await _secureBookmarks.bookmark(File(dirname));
      ref.read(settingsProvider).setString(settingsTxDxDirectoryMacosSecureBookmark, bookmark);
    }
    ref.read(settingsProvider).setString(settingsTxDxDirectory, dirname ?? '');
  });
}

Future<String?> pickDir() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String? result = await FilePicker.platform.getDirectoryPath(
    dialogTitle: 'Select your TxDx folder',
    initialDirectory: appDocDir.path,
  );

  return result;
}