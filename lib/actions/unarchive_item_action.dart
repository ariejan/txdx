import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/config/shortcuts.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';

import '../utils/focus.dart';

class UnarchiveItemAction extends Action<UnarchiveItemIntent> {

  final WidgetRef ref;

  UnarchiveItemAction(this.ref);

  @override
  Object? invoke(UnarchiveItemIntent intent) {
    ref.read(archiveItemsProvider.notifier).unarchive(intent.itemId);
    appFocusNode.requestFocus();
    return null;
  }
}