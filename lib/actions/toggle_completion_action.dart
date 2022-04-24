import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../config/shortcuts.dart';
import '../providers/items/item_notifier_provider.dart';
import '../providers/items/scoped_item_notifier.dart';
import '../providers/items/selected_item_provider.dart';

class ToggleCompletionAction extends Action<ToggleCompletionIntent> {

  final WidgetRef ref;

  ToggleCompletionAction(this.ref);

  @override
  Object? invoke(ToggleCompletionIntent intent) {
    final current = ref.read(selectedItemIdStateProvider);
    if (current != null) {
      final items = ref.read(filteredItems);
      var idx = items.indexWhere((item) => item.id == current);
      final item = items[idx];

      if (!item.completed) {
        idx = (idx + 1 >= items.length) ? items.length - 2 : idx + 1;
        ref.read(selectedItemIdStateProvider.state).state = items[idx].id;
      }

      ref.read(itemsNotifierProvider.notifier).toggleComplete(current);
    }

    return null;
  }
}