import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/txdx/txdx_item.dart';

import 'item_notifier_provider.dart';

enum ItemStateSorter {
  priority,
  completion,
  dueOn,
  description,
}

final itemStateSorter = Provider<List<ItemStateSorter>>((ref) {
  return [ItemStateSorter.completion, ItemStateSorter.priority, ItemStateSorter.dueOn, ItemStateSorter.description];
});

int descriptionSort(TxDxItem a, TxDxItem b) => a.description.compareTo(b.description);

int dueOnSort(TxDxItem a, TxDxItem b) {
  final dueOnA = a.dueOn;
  final dueOnB = b.dueOn;

  if (dueOnA == null && dueOnB == null) return 0;
  if (dueOnA != null && dueOnB == null) return 1;
  if (dueOnA == null && dueOnB != null) return -1;

  return dueOnA!.compareTo(dueOnB!);
}

int completedSort(TxDxItem a, TxDxItem b) {
  if (a.completed && !b.completed) {
    return 1;
  } else if (b.completed && !a.completed) {
    return -1;
  }
  return 0;
}

int prioritySort(TxDxItem a, TxDxItem b) {
  final priorityA = a.priority?.toUpperCase() ?? 'zz';
  final priorityB = b.priority?.toUpperCase() ?? 'zz';

  return priorityA.compareTo(priorityB);
}

final scopedItems = Provider<AsyncValue<List<TxDxItem>>>((ref) {
  final asyncItems = ref.watch(itemsNotifierProvider);
  final sorters = ref.watch(itemStateSorter);

  int sortAll(TxDxItem a, TxDxItem b) {
    var result = 0;
    
    for (var sorter in sorters) {
      switch (sorter) {
        case ItemStateSorter.completion:
          result = completedSort(a, b);
          break;

        case ItemStateSorter.priority:
          result = prioritySort(a, b);
          break;

        case ItemStateSorter.description:
          result = descriptionSort(a, b);
          break;

        case ItemStateSorter.dueOn:
          result = completedSort(a, b);
          break;
      }

      if (result != 0) {
        break;
      }
    }
    
    return result;
  }

  return asyncItems.whenData((items) {
    var sortedList = items.toList();
    sortedList.sort(sortAll);
    return sortedList;
  });
});

