import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/items/selected_item_provider.dart';
import 'package:txdx/widgets/items/edit_item_widget.dart';
import 'package:txdx/widgets/items/show_item_widget.dart';

import '../../txdx/txdx_item.dart';

class ItemWidget extends ConsumerWidget {
  const ItemWidget(
      this.item, {
        this.archiveView = false,
        Key? key
      }) : super(key: key);

  final TxDxItem item;
  final bool archiveView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!archiveView) {
      final editingItemId = ref.watch(editingItemIdStateProvider);
      final isEditing = editingItemId != null && editingItemId == item.id;

      return isEditing ? EditItemWidget(item) : ShowItemWidget(item);
    } else {
      return ShowItemWidget(item, archiveView: true);
    }
  }
}
