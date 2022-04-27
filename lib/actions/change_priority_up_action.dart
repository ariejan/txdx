import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../config/shortcuts.dart';
import '../providers/items/item_notifier_provider.dart';
import '../providers/items/selected_item_provider.dart';

class ChangePriorityUpAction extends Action<ChangePriorityUpIntent> {

  final WidgetRef ref;

  ChangePriorityUpAction(this.ref);

  @override
  Object? invoke(ChangePriorityUpIntent intent) {
    final current = ref.read(selectedItemIdStateProvider);
    if (current != null) {
      ref.read(todoItemsProvider.notifier).prioUp(current);
    }

    return null;
  }

  @override
  bool get isActionEnabled {
    return ref.watch(editingItemIdStateProvider) == null;
  }
}