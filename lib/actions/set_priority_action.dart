import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../config/shortcuts.dart';
import '../providers/items/item_notifier_provider.dart';
import '../providers/items/selected_item_provider.dart';

class SetPriorityAction extends Action<SetPriorityIntent> {

  final WidgetRef ref;

  SetPriorityAction(this.ref);

  @override
  Object? invoke(SetPriorityIntent intent) {
    final current = ref.read(selectedItemIdStateProvider);

    if (current != null) {
      ref.read(todoItemsProvider.notifier).setPriority(current, intent.priority);
    }

    return null;
  }
}