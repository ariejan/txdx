
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/filters.dart';
import '../settings/settings_provider.dart';
import 'scoped_item_notifier.dart';

final itemsCountDueToday = StateProvider<int>((ref) {
  final items = ref.watch(scopedItems);
  final settings = ref.watch(settingsProvider);

  return filterItems(items, filterToday, true, settings).length;
});