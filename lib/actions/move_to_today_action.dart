import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../config/shortcuts.dart';
import '../providers/items/item_notifier_provider.dart';
import '../providers/items/selected_item_provider.dart';

class MoveToTodayAction extends Action<MoveToTodayIntent> {

  final WidgetRef ref;

  MoveToTodayAction(this.ref);

  @override
  Object? invoke(MoveToTodayIntent intent) {
    final current = ref.read(selectedItemIdStateProvider);
    if (current != null) {
      ref.read(todoItemsProvider.notifier).moveToToday(current);
    }

    return null;
  }
}