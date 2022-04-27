import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../config/shortcuts.dart';
import '../providers/items/item_notifier_provider.dart';
import '../providers/items/selected_item_provider.dart';

class ClearDueOnAction extends Action<ClearDueOnIntent> {

  final WidgetRef ref;

  ClearDueOnAction(this.ref);

  @override
  Object? invoke(ClearDueOnIntent intent) {
    final current = ref.read(selectedItemIdStateProvider);
    if (current != null) {
      ref.read(todoItemsProvider.notifier).setDueOn(current, null);
    }

    return null;
  }
}