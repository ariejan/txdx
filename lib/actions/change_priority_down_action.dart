import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../config/shortcuts.dart';
import '../providers/items/item_notifier_provider.dart';
import '../providers/items/selected_item_provider.dart';

class ChangePriorityDownAction extends Action<ChangePriorityDownIntent> {

  final WidgetRef ref;

  ChangePriorityDownAction(this.ref);

  @override
  Object? invoke(ChangePriorityDownIntent intent) {
    final current = ref.read(selectedItemIdStateProvider);
    if (current != null) {
      ref.read(todoItemsProvider.notifier).prioDown(current);
    }

    return null;
  }

  @override
  bool get isActionEnabled {
    return ref.watch(editingItemIdStateProvider) == null;
  }
}