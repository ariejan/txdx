import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:quiver/core.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';
import 'package:txdx/providers/items/scoped_item_notifier.dart';
import 'package:txdx/utils/focus.dart';

import '../config/shortcuts.dart';
import '../providers/items/selected_item_provider.dart';
import '../txdx/txdx_item.dart';

class ItemControllers {

  ItemControllers({
    required this.descriptionController,
    required this.notesController,
    required this.dueOnController,
    required this.priorityController,
    required this.tagsController,
  });

  final TextEditingController descriptionController;
  final TextEditingController notesController;
  final TextEditingController dueOnController;
  final TextEditingController priorityController;
  final TextEditingController tagsController;
}

class EndEditAction extends Action<EndEditIntent> {

  final WidgetRef ref;

  EndEditAction(this.ref);

  @override
  Object? invoke(EndEditIntent intent) {
    final editedItemId = ref.read(editingItemIdStateProvider);
    if (editedItemId == null) {
      return null;
    }

    final items = ref.read(filteredItems);
    final theItem = items.firstWhere((item) => item.id == editedItemId);

    final dueOnStr = intent.itemControllers.dueOnController.text;
    final descriptionStr = intent.itemControllers.descriptionController.text;
    final priorityStr = intent.itemControllers.priorityController.text;
    final priority = priorityStr.isNotEmpty ? priorityStr : null;

    final tagStr = intent.itemControllers.tagsController.text;
    final allTags = tagStr.split(" ");
    allTags.removeWhere((e) => e.trim().isEmpty);

    final projects = allTags.where((e) => e.substring(0, 1) == '+');
    final contexts = allTags.where((e) => e.substring(0, 1) == '@');
    final tags = <String, String>{};
    allTags.where((e) => !projects.contains(e) && !contexts.contains(e)).forEach((e) {
      final kv = e.split(":");
      tags[kv[0]] = kv[1];
    });

    // Do not save new empty description items
    if (theItem.isNew && descriptionStr.isEmpty) {
      ref.read(todoItemsProvider.notifier).deleteItem(theItem.id);
      ref.read(editingItemIdStateProvider.state).state = null;
      return null;
    }

    final parsedItem = TxDxItem.fromText(descriptionStr);

    final newItem = theItem.copyWith(
        description: parsedItem.description,
        priority: (parsedItem.priority?.isNotEmpty ?? false) ? Optional.of(parsedItem.priority!) : null,
        projects: projects,
        contexts: contexts,
        tags: tags,
      )
      .setDueOn(dueOnStr.isEmpty ? null : DateTime.tryParse(dueOnStr))
      .setPriority(priority)
      .addContexts(parsedItem.contexts)
      .addProjects(parsedItem.projects)
      .addTags(parsedItem.tags);

    ref.read(todoItemsProvider.notifier).updateItem(editedItemId, newItem.toString());
    ref.read(editingItemIdStateProvider.state).state = null;

    appFocusNode.requestFocus();

    return null;
  }
}