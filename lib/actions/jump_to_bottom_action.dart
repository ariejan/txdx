import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/actions/action_mixins.dart';
import 'package:flutter/material.dart';

import '../config/shortcuts.dart';
import '../providers/items/scoped_item_notifier.dart';
import '../providers/items/selected_item_provider.dart';

class JumpToBottomAction extends Action<JumpToBottomIntent> with ItemListManager {

  final WidgetRef ref;

  JumpToBottomAction(this.ref);

  @override
  Object? invoke(JumpToBottomIntent intent) {
    final items = ref.read(filteredItems);

    if (items.isNotEmpty) {
      ref.read(selectedItemIdStateProvider.state).state = items.last.id;
      jumpToIndex(items.length - 1);
    }

    return null;
  }

  @override
  bool get isActionEnabled {
    return ref.watch(editingItemIdStateProvider) == null;
  }
}