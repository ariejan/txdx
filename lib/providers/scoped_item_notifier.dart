import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/txdx/txdx_item.dart';

import 'item_notifier_provider.dart';

enum ItemStateSorter {
  priority,
  completion,
  dueOn,
}

final itemStateSorter = Provider<List<ItemStateSorter>>((ref) {
  return [ItemStateSorter.completion, ItemStateSorter.priority];
});

int descriptionSort(a, b) => a.description.compareTo(b.description);

int prioritySort(TxDxItem a, TxDxItem b) {
  String aPrio = a.priority?.toUpperCase() ?? 'zz';
  String bPrio = b.priority?.toUpperCase() ?? 'zz';

  return aPrio.compareTo(bPrio);
}

final scopedItems = Provider<AsyncValue<List<TxDxItem>>>((ref) {
  final asyncItems = ref.watch(itemsNotifierProvider);

  return asyncItems.whenData((items) {
    var sortedList = items.toList();
    sortedList.sort(prioritySort);
    return sortedList;
  });
});

