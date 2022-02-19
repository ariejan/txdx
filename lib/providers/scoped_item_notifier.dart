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

final groupedItems = Provider<AsyncValue<Map<String, List<TxDxItem>>>>((ref) {
  final asyncItems = ref.watch(scopedItems);
  final sorters = ref.watch(itemStateSorter);

  return asyncItems.whenData((items) {
    if (sorters.isEmpty) {
      return {'all': items};
    }

    final groupBy = sorters[1];
    final result = <String, List<TxDxItem>>{};

    switch(groupBy) {
      case ItemStateSorter.dueOn: {
        for (var item in items) {
          final key = item.dueOn?.microsecondsSinceEpoch ?? 0;
          result[key]?.add(item);
        }
      }
      break;

      case ItemStateSorter.completion: {
        for (var item in items) {
          final key = item.completed;
          result[key]?.add(item);
        }
      }
      break;

      case ItemStateSorter.description: {
        result["everything"] = items;
      }
      break;

      case ItemStateSorter.priority: {
        for (var item in items) {
          final key = item.priority ?? 'X';

          if (!result.containsKey(key)) {
            result[key] = [];
          }
          result[key]?.add(item);
        }
      }
      break;
    }

    return result;
  });
});