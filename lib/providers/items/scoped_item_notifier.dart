import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/settings/settings_provider.dart';
import 'package:txdx/config/settings.dart';
import 'package:txdx/txdx/txdx_item.dart';

import '../../config/filters.dart';
import 'item_notifier_provider.dart';

enum ItemStateSorter {
  priority,
  completion,
  dueOn,
  description,
}

final itemStateSorter = StateProvider<List<ItemStateSorter>>((ref) {
  return [ItemStateSorter.completion, ItemStateSorter.priority, ItemStateSorter.dueOn, ItemStateSorter.description];
});

final itemStateGrouper = StateProvider<ItemStateSorter>((ref) => ItemStateSorter.priority);

final itemFilter = StateProvider<String?>((ref) {
  return ref.read(settingsProvider).getString(settingsDefaultFilter);
});

final isSearchingProvider = StateProvider<bool>((_) => false);
final searchTextProvider = StateProvider<String?>((_) => null);

int descriptionSort(TxDxItem a, TxDxItem b) => a.description.compareTo(b.description);

int dueOnSort(TxDxItem a, TxDxItem b) {
  final dueOnA = a.dueOn;
  final dueOnB = b.dueOn;

  if (dueOnA == null && dueOnB == null) return 0;
  if (dueOnA != null && dueOnB == null) return -1;
  if (dueOnA == null && dueOnB != null) return 1;

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

final scopedItems = Provider<List<TxDxItem>>((ref) {
  final items = ref.watch(itemsNotifierProvider);
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
          result = dueOnSort(a, b);
          break;
      }

      if (result != 0) {
        break;
      }
    }
    
    return result;
  }

  var sortedList = items.toList();
  sortedList.sort(sortAll);
  return sortedList;
});

final filteredItems = Provider<List<TxDxItem>>((ref) {
  final items = ref.watch(scopedItems);
  final filter = ref.watch(itemFilter);

  final isSearching = ref.watch(isSearchingProvider);
  final searchText = ref.watch(searchTextProvider);

  final settings = ref.watch(settingsProvider);

  var result = items.toList();

  result = filterItems(result, filter, false, settings);

  if (isSearching && searchText != null && searchText.isNotEmpty) {
    result = result.where((item) => item.description.contains(searchText)).toList();
  }

  return result;

});

List<TxDxItem> filterItems(List<TxDxItem> items, String? filter, bool filterCompleted, Settings settings) {
  if (filterCompleted) {
    items = items.where((item) => !item.completed).toList();
  }

  if (filter == null || filter == filterAll) {
    // Noop
  } else if (filter == filterToday) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    items = items.where((item) =>
      item.hasDueOn && item.dueOn == today
    ).toList();
  } else if (filter == filterUpcoming) {
    final nextUpDays = settings.getInt(settingsUpcomingDays);
    final now = DateTime.now();
    final today = settings.getBool(settingsTodayInUpcoming)
      ? DateTime(now.year, now.month, now.day - 1)
      : DateTime(now.year, now.month, now.day);
    final futureDay = DateTime(now.year, now.month, now.day + nextUpDays + 1);
    items = items.where((item) =>
      item.hasDueOn && item.dueOn!.isAfter(today) && item.dueOn!.isBefore(futureDay)
    ).toList();
  } else if (filter == filterSomeday) {
    final nextUpDays = settings.getInt(settingsUpcomingDays);
    final now = DateTime.now();
    final futureDay = DateTime(now.year, now.month, now.day + nextUpDays);
    items = items.where((item) =>
      !item.hasDueOn
        || (item.hasDueOn && item.dueOn!.isAfter(futureDay))
    ).toList();
  } else if (filter == filterOverdue) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    items.removeWhere((item) => (item.hasDueOn && item.dueOn!.isAfter(yesterday)) || !item.hasDueOn);
  } else {
    items.removeWhere((item) => !item.hasContextOrProject(filter));
  }

  return items;
}
