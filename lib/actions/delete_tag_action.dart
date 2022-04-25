import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../config/shortcuts.dart';
import '../providers/items/item_notifier_provider.dart';
import '../providers/items/selected_item_provider.dart';

class DeleteTagAction extends Action<DeleteTagIntent> {

  final WidgetRef ref;

  DeleteTagAction(this.ref);

  @override
  Object? invoke(DeleteTagIntent intent) {
    // Remove a context
    if (intent.tag.substring(0, 1) == '@') {
      ref.read(itemsNotifierProvider.notifier).removeContext(intent.itemId, intent.tag);
    }

    // Remove a project
    if (intent.tag.substring(0, 1) == '+') {
      ref.read(itemsNotifierProvider.notifier).removeProject(intent.itemId, intent.tag);
    }

    return null;
  }
}