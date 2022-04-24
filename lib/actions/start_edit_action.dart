import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:txdx/providers/items/scoped_item_notifier.dart';

import '../config/shortcuts.dart';
import '../providers/items/selected_item_provider.dart';

class StartEditAction extends Action<StartEditIntent> {

  final WidgetRef ref;

  StartEditAction(this.ref);

  @override
  Object? invoke(StartEditIntent intent) {
    final current = ref.read(selectedItemIdStateProvider);
    if (current != null) {
      ref.read(editingItemIdStateProvider.state).state = current;
    }

    return null;
  }

  @override
  bool get isActionEnabled {
    return ref.watch(editingItemIdStateProvider) == null;
  }
}