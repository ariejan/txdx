import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../config/shortcuts.dart';
import '../providers/items/item_notifier_provider.dart';

class DeleteTagAction extends Action<DeleteTagIntent> {

  final WidgetRef ref;

  DeleteTagAction(this.ref);

  @override
  Object? invoke(DeleteTagIntent intent) {
    // Remove a context
    if (intent.tag.substring(0, 1) == '@') {
      ref.read(todoItemsProvider.notifier).removeContext(intent.itemId, intent.tag);
      return null;
    }

    // Remove a project
    if (intent.tag.substring(0, 1) == '+') {
      ref.read(todoItemsProvider.notifier).removeProject(intent.itemId, intent.tag);
      return null;
    }

    // Remove an actual tag...
    final tagName = intent.tag.split(':').first;
    ref.read(todoItemsProvider.notifier).removeTagName(intent.itemId, tagName);

    return null;
  }
}