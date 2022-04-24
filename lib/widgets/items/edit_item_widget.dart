import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:txdx/txdx/txdx_item.dart';

import '../../config/colors.dart';
import '../../providers/items/selected_item_provider.dart';

class EditItemWidget extends ConsumerWidget {

  final TxDxItem item;

  final _descriptionFocusNode = FocusNode();
  final _descriptionController = TextEditingController();

  final _notesFocusNode = FocusNode();
  final _notesController = TextEditingController();

  EditItemWidget(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(itemProvider(item.id));

    _descriptionFocusNode.requestFocus();

    _descriptionController.text = item.description;

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

    return Focus(
      autofocus: true,
      child: Padding(
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
                    child: Transform.scale(
                      scale: 0.76,
                      child: Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          tristate: false,
                          splashRadius: 0,
                          value: item.completed,
                          onChanged: (bool? value) {

                          }),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                  child: Focus(
                                    onKey: (FocusNode node, RawKeyEvent event) {
                                      if (event.isKeyPressed(LogicalKeyboardKey.enter)) {

                                        return KeyEventResult.handled;
                                      }
                                      return KeyEventResult.ignored;
                                    },
                                    child: TextField(
                                      focusNode: _descriptionFocusNode,
                                      controller: _descriptionController,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 11),
                                      ),
                                      style: const TextStyle(
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
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 2),
                                    child: Focus(
                                      onFocusChange: (focussed) {
                                        if (focussed) {
                                          _notesFocusNode.requestFocus();
                                        }
                                      },
                                      onKey: (FocusNode node, RawKeyEvent event) {
                                        return KeyEventResult.ignored;
                                      },
                                      child: TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        focusNode: _notesFocusNode,
                                        controller: _notesController,
                                        minLines: 1,
                                        maxLines: 8,
                                        decoration: const InputDecoration(
                                          hintText: "Notes...",
                                          contentPadding: EdgeInsets.symmetric(vertical: 11),
                                          filled: true,
                                        ),
                                        // focusNode: _focusNode,
                                        // controller: _textController,
                                        style: const TextStyle(
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
                                      if (pickedDate != null) {

                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.flag_sharp, size: 12),
                                      const SizedBox(width: 4),
                                      Text(
                                          item.hasDueOn
                                            ? Jiffy(item.dueOn).format('yyyy-MM-dd')
                                            : 'No due date set'
                                      ),
                                      if (item.hasDueOn) IconButton(
                                        splashRadius: 1,
                                        icon: const Icon(Icons.close_sharp, size: 12),
                                        onPressed: () {

                                        },
                                      )
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
      ),
    );
  }

}