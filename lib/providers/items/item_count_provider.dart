
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings_provider.dart';
import 'scoped_item_notifier.dart';

final itemsCount = StateProvider.family<int, String>((ref, filter) {
  final items = ref.watch(scopedItems);
  final settings = ref.watch(settingsProvider);

  return filterItems(items, filter, true, settings).length;
});