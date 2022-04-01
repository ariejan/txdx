import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';
import 'package:txdx/providers/items/selected_item_provider.dart';
import 'package:txdx/widgets/items/edit_item_widget.dart';
import 'package:txdx/widgets/items/show_item_widget.dart';

import '../../config/colors.dart';
import '../../txdx/txdx_item.dart';

class ItemWidget extends ConsumerWidget {
  const ItemWidget(this.item, {Key? key})
      : super(key: key);

  final TxDxItem item;

  static const opacity = 0.5;

  Color _getRowColor(bool isSelected, bool isEditing) {
    if (isEditing) {
      return Colors.transparent;
    } else {
      return TxDxColors.forPriority(item.priority);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editingItemId = ref.watch(editingItemIdStateProvider);
    final isEditing = editingItemId != null && editingItemId == item.id;

    final selectedItemId = ref.watch(selectedItemIdStateProvider);
    final isSelected = selectedItemId != null && selectedItemId == item.id;

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return TxDxColors.checkboxHover;
      }
      return TxDxColors.checkbox;
    }

    var statusColor = _getRowColor(isSelected, isEditing);
    var bgColor = Colors.transparent;

    if (isSelected) {
      bgColor = Theme.of(context).hoverColor;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            left: BorderSide(width: 5, color: statusColor),
          ),
        ),
        child: Row(
          crossAxisAlignment: isEditing ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Checkbox(
                  shape: const CircleBorder(),
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  tristate: false,
                  splashRadius: 0,
                  value: item.completed,
                  onChanged: (bool? value) {
                    ref.read(editingItemIdStateProvider.state).state = null;
                    ref.read(itemsNotifierProvider.notifier).toggleComplete(item.id);
                  }),
            ),
            Expanded(
              child: isEditing ? EditItemWidget(item) : ShowItemWidget(item),
            )
          ]
        ),
      ),
    );
  }
}
