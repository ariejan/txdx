import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/settings_provider.dart';

import '../settings.dart';

final archivingAvailableProvider = Provider<bool>((ref) {
  final filename = ref.watch(settingsProvider).getString(settingsFileArchiveTxt);
  return filename != null && File(filename).existsSync();
});
