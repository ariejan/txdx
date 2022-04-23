import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:txdx/txdx/txdx_item.dart';

import '../../config/colors.dart';
import '../../providers/items/item_notifier_provider.dart';
import '../../providers/items/selected_item_provider.dart';

class EditItemWidget extends ConsumerWidget {

  final TxDxItem item;

  final _focusNode = FocusNode();
  final _textController = TextEditingController();

  EditItemWidget(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _focusNode.requestFocus();

    _textController.text = item.description;

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Theme.of(context).brightness == Brightness.light
            ? TxDxColors.lightCheckboxHover
            : TxDxColors.darkCheckboxHover;
      }
      return Theme.of(context).brightness == Brightness.light
          ? TxDxColors.lightCheckbox
          : TxDxColors.darkCheckbox;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).hintColor.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 0.5),
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 6, 0, 2),
                                child: Focus(
                                  onKey: (FocusNode node, RawKeyEvent event) {
                                    if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                                      ref.read(itemsNotifierProvider.notifier).updateItem(item.id, _textController.text);
                                      ref.read(editingItemIdStateProvider.state).state = null;
                                      return KeyEventResult.handled;
                                    }
                                    return KeyEventResult.ignored;
                                  },
                                  child: TextFormField(
                                    focusNode: _focusNode,
                                    controller: _textController,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 2),
                                  child: Focus(
                                    onKey: (FocusNode node, RawKeyEvent event) {
                                      return KeyEventResult.ignored;
                                    },
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: "Notes...",
                                      ),
                                      // focusNode: _focusNode,
                                      // controller: _textController,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                                style: ButtonStyle(
                                  splashFactory: NoSplash.splashFactory,
                                  overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                    return Colors.transparent;
                                  }),
                                ),
                                onPressed: () async {
                                  showDatePicker(
                                    context: context,
                                    initialDate: item.dueOn ?? DateTime.now(),
                                    firstDate: DateTime(1970, 1, 1),
                                    lastDate: DateTime(2099, 12, 31),
                                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                                    helpText: 'Due on',
                                  ).then((pickedDate) {
                                    ref.read(itemsNotifierProvider.notifier).setDueOn(item.id, pickedDate);
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.flag_sharp, size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                        item.dueOn == null ? 'No due date set' : Jiffy(item.dueOn).format('yyyy-MM-dd')),
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }

}