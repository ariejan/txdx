import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/actions/action_mixins.dart';
import 'package:flutter/material.dart';
import 'package:txdx/txdx/txdx_item.dart';

import '../config/filters.dart';
import '../config/shortcuts.dart';
import '../providers/items/item_notifier_provider.dart';
import '../providers/items/scoped_item_notifier.dart';
import '../providers/items/selected_item_provider.dart';

class AddItemAction extends Action<AddIntent> with ItemListManager {

  final WidgetRef ref;

  AddItemAction(this.ref);

  @override
  Object? invoke(AddIntent intent) {
    // Set defaults
    final filter = ref.read(itemFilter);
    var defaultText = '';

    if (filter != null && filter.isNotEmpty) {
      if (filter == filterToday) {
        defaultText += ' due:today';
      }
      if (RegExp(r'^[@\+]').hasMatch(filter)) {
        defaultText += ' $filter';
      }
    }

    final newItem = TxDxItem.newFromText(defaultText);
    final newItemId = ref.read(todoItemsProvider.notifier).addItem(newItem);

    final items = ref.read(filteredItems);

    if (items.length > 1) {
      final index = items.indexWhere((item) => item.id == newItemId);
      jumpToIndex(index);
    }

    ref.read(editingItemIdStateProvider.state).state = newItem.id;
    ref.read(selectedItemIdStateProvider.state).state = newItem.id;

    return null;
  }
}