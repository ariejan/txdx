import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:txdx/actions/end_edit_action.dart';
import 'package:txdx/config/shortcuts.dart';
import 'package:txdx/txdx/txdx_item.dart';

import '../../config/colors.dart';

class EditItemWidget extends ConsumerStatefulWidget {

  final TxDxItem item;

  const EditItemWidget(this.item, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditItemWidgetState();
}

class _EditItemWidgetState extends ConsumerState<EditItemWidget> {
  final _descriptionFocusNode = FocusNode();
  final _descriptionController = TextEditingController();

  // final _notesFocusNode = FocusNode();
  final _notesController = TextEditingController();

  final _dueOnController = TextEditingController();

  final dueOnTextDefault = "No due date set";
  String dueOnText = '';


  void _setDueOn(DateTime? dueOn) {
    if (dueOn != null) {
      final strDueOn = Jiffy(dueOn).format('yyyy-MM-dd');

      _dueOnController.text = strDueOn;
      setState(() => dueOnText = strDueOn);
    } else {
      _dueOnController.text = '';
      setState(() => dueOnText = dueOnTextDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    final endEditAction = EndEditAction(ref, ItemControllers(
      descriptionController: _descriptionController,
      notesController: _notesController,
      dueOnController: _dueOnController,
    ));

    _descriptionFocusNode.requestFocus();
    _descriptionController.text = item.description;

    if (dueOnText.isEmpty) {
      _setDueOn(item.dueOn);
    }

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

    return Shortcuts(
      shortcuts: {
        escapeShortcut: EndEditIntent(),
      },
      child: Actions(
        actions: {
          EndEditIntent: endEditAction,
        },
        child: Focus(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).brightness == Brightness.light
                    ? TxDxColors.lightEditBorder
                    : TxDxColors.darkEditBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.light
                          ? TxDxColors.lightEditShadow
                          : TxDxColors.darkEditShadow,
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset.zero,
                    ),
                  ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TheCheckBox(item: item, fillColor: MaterialStateProperty.resolveWith(getColor)),
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
                                      child: Shortcuts(
                                        shortcuts: {
                                          enterShortcut: EndEditIntent(),
                                        },
                                        child: Actions(
                                          actions: {
                                            EndEditIntent: endEditAction,
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
                                  ),

                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                            //   child: Row(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Expanded(
                            //           child: Padding(
                            //             padding: const EdgeInsets.fromLTRB(0, 6, 0, 2),
                            //             child: NotesField(notesFocusNode: _notesFocusNode, notesController: _notesController),
                            //           ),
                            //         ),
                            //       ]
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: false,
                                    child: TextField(controller: _dueOnController),
                                  ),
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
                                            _setDueOn(pickedDate);
                                          }
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.flag_sharp, size: 12),
                                          const SizedBox(width: 4),
                                          Text(dueOnText),
                                          if (item.hasDueOn) IconButton(
                                            splashRadius: 1,
                                            icon: const Icon(Icons.close_sharp, size: 12),
                                            onPressed: () {
                                              _setDueOn(null);
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
        ),
      ),
    );
  }

}

class NotesField extends StatelessWidget {
  const NotesField({
    Key? key,
    required FocusNode notesFocusNode,
    required TextEditingController notesController,
  }) : _notesFocusNode = notesFocusNode, _notesController = notesController, super(key: key);

  final FocusNode _notesFocusNode;
  final TextEditingController _notesController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}


class TheCheckBox extends StatelessWidget {
  const TheCheckBox({
    Key? key,
    required this.item,
    this.fillColor,
  }) : super(key: key);

  final TxDxItem item;
  final MaterialStateProperty<Color?>? fillColor;

  @override
  Widget build(BuildContext context, ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: Transform.scale(
        scale: 0.76,
        child: Checkbox(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            fillColor: fillColor,
            tristate: false,
            splashRadius: 0,
            value: item.completed,
            onChanged: (bool? value) {
              // TODO
            }),
      ),
    );
  }
}