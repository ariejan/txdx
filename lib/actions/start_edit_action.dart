import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../config/shortcuts.dart';
import '../providers/items/selected_item_provider.dart';

class StartEditAction extends Action<EditIntent> {

  final WidgetRef ref;

  StartEditAction(this.ref);

  @override
  Object? invoke(EditIntent intent) {
    final current = ref.read(selectedItemIdStateProvider);
    if (current == null) return null;
    ref.read(editingItemIdStateProvider.state).state = current;
    return null;
  }

  @override
  bool get isActionEnabled {
    return ref.watch(editingItemIdStateProvider) == null;
  }
}