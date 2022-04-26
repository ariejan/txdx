import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/actions/action_mixins.dart';
import 'package:flutter/material.dart';

import '../config/shortcuts.dart';
import '../providers/items/scoped_item_notifier.dart';
import '../providers/items/selected_item_provider.dart';

class JumpToTopAction extends Action<JumpToTopIntent> with ItemListManager {

  final WidgetRef ref;

  JumpToTopAction(this.ref);

  @override
  Object? invoke(JumpToTopIntent intent) {
    final items = ref.read(filteredItems);

    if (items.isNotEmpty) {
      ref.read(selectedItemIdStateProvider.state).state = items.first.id;
      jumpToIndex(0);
    }

    return null;
  }

  @override
  bool get isActionEnabled {
    return ref.watch(editingItemIdStateProvider) == null;
  }
}