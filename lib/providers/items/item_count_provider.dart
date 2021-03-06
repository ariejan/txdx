
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings_provider.dart';
import 'filter_provider.dart';
import 'scoped_item_notifier.dart';

final badgeCount = Provider<int>((ref) {
  final badgeFilter = ref.watch(badgeCountFilterProvider);
  return ref.watch(itemsCount(badgeFilter));
});

final itemsCount = StateProvider.family<int, String>((ref, filter) {
  var items = ref.watch(scopedItems);
  items = items.where((item) => !item.isNew).toList();

  final settings = ref.watch(interfaceSettingsProvider);

  return filterItems(items, filter, true, settings).length;
});