import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/actions/action_mixins.dart';
import 'package:flutter/material.dart';

import '../config/shortcuts.dart';
import '../providers/items/scoped_item_notifier.dart';
import '../providers/items/selected_item_provider.dart';

class SelectPreviousItemAction
    extends Action<SelectPreviousItemIntent>
    with ItemListManager {

  final WidgetRef ref;

  SelectPreviousItemAction(this.ref);

  @override
  Object? invoke(SelectPreviousItemIntent intent) {
    final items = ref.read(filteredItems);
    final current = ref.read(selectedItemIdStateProvider);
    if (current == null) {
      ref.read(selectedItemIdStateProvider.state).state = items.last.id;
      jumpToIndex(items.length - 1);
    } else {
      final idx = (items.indexWhere((item) => item.id == current) - 1) % items.length;
      ref.read(selectedItemIdStateProvider.state).state = items[idx].id;
      jumpToIndex(idx);
    }
    return null;
  }

  @override
  bool get isActionEnabled {
    return ref.watch(editingItemIdStateProvider) == null;
  }
}