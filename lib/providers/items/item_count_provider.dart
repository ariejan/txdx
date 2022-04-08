
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/filters.dart';
import '../settings/settings_provider.dart';
import 'scoped_item_notifier.dart';

final itemsCountAll = StateProvider<int>((ref) {
  final items = ref.watch(scopedItems);
  final settings = ref.watch(settingsProvider);

  return filterItems(items, filterAll, true, settings).length;
});

final itemsCountDueToday = StateProvider<int>((ref) {
  final items = ref.watch(scopedItems);
  final settings = ref.watch(settingsProvider);

  return filterItems(items, filterToday, true, settings).length;
});

final itemsCountUpcoming = StateProvider<int>((ref) {
  final items = ref.watch(scopedItems);
  final settings = ref.watch(settingsProvider);

  return filterItems(items, filterUpcoming, true, settings).length;
});

final itemsCountOverdue = StateProvider<int>((ref) {
  final items = ref.watch(scopedItems);
  final settings = ref.watch(settingsProvider);

  return filterItems(items, filterOverdue, true, settings).length;
});