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

int descriptionSort(TxDxItem a, TxDxItem b) => a.description.compareTo(b.description);

int completedSort(TxDxItem a, TxDxItem b) {
  if (a.completed && !b.completed) {
    return -1;
  } else if (b.completed && !a.completed) {
    return 1;
  }
  return 0;
}

int prioritySort(TxDxItem a, TxDxItem b) {
  String priorityA = a.priority?.toUpperCase() ?? 'zz';
  String priorityB = b.priority?.toUpperCase() ?? 'zz';

  return priorityA.compareTo(priorityB);
}

final scopedItems = Provider<AsyncValue<List<TxDxItem>>>((ref) {
  final asyncItems = ref.watch(itemsNotifierProvider);

  return asyncItems.whenData((items) {
    var sortedList = items.toList();
    sortedList.sort(prioritySort);
    return sortedList;
  });
});

