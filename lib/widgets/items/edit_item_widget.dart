import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/actions/end_edit_action.dart';
import 'package:txdx/config/shortcuts.dart';
import 'package:txdx/txdx/txdx_item.dart';

import '../../config/colors.dart';
import '../../providers/items/item_notifier_provider.dart';
import 'deletable_tag.dart';
import 'due_on_picker.dart';
import 'priority_picker.dart';

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
  final _priorityController = TextEditingController();
  final _tagsController = TextEditingController();

  final _deletedTags = <String>[];
  String? _editedDescription;

  void _setTagsControllerTextFromItem(TxDxItem item) {
    final tags = <String>[];

    tags.addAll(item.projects);
    tags.addAll(item.contexts);
    item.tagsWithoutDue.forEach((k,v) => tags.add('$k:$v}'));

    tags.removeWhere((e) => _deletedTags.contains(e));

    _tagsController.text = tags.join(" ");
  }

  void _removeTagFromTagsControllerText(String tag) {
    var tags = _tagsController.text.split(" ");
    tags.remove(tag);
    _tagsController.text = tags.join(" ");

    setState(() => _deletedTags.add(tag));
    _descriptionFocusNode.requestFocus();
  }

  void _restoreTagToTagsControllerText(String tag) {
    var tags = _tagsController.text.split(" ");
    tags.add(tag);
    _tagsController.text = tags.join(" ");

    setState(() => _deletedTags.remove(tag));
    _descriptionFocusNode.requestFocus();
  }

  void _setDescription(String value) {
    _editedDescription = value;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    final endEditIntent = EndEditIntent(ItemControllers(
      descriptionController: _descriptionController,
      notesController: _notesController,
      dueOnController: _dueOnController,
      priorityController: _priorityController,
      tagsController: _tagsController,
    ));

    _descriptionFocusNode.requestFocus();

    _editedDescription ??= item.description;

    _descriptionController.value = TextEditingValue(
      text: _editedDescription!,
      selection: TextSelection.collapsed(offset: _editedDescription!.length),
    );

    _setTagsControllerTextFromItem(item);

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
        enterShortcut: endEditIntent,
        escapeShortcut: endEditIntent,
      },
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
            padding: const EdgeInsets.fromLTRB(12, 8, 6, 16),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
                    child: Transform.scale(
                      scale: 0.76,
                      child: Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          tristate: false,
                          splashRadius: 0,
                          value: item.completed,
                          onChanged: (bool? value) {
                            Actions.invoke(context, endEditIntent);
                            ref.read(todoItemsProvider.notifier).toggleComplete(item.id);
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
                                  child: TextField(
                                    focusNode: _descriptionFocusNode,
                                    controller: _descriptionController,
                                    onChanged: (value) => _setDescription(value),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 11),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: (item.projects.isEmpty && item.tagsWithoutDue.isEmpty && item.contexts.isEmpty)
                            ? Text('You can add metadata to the description directly', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor))
                            : Wrap(
                            children: [
                              ...item.projects.map((project) =>
                                  DeletableTag(
                                    item: item,
                                    tag: project,
                                    iconColor: TxDxColors.projects,
                                    onDelete: (value) => _removeTagFromTagsControllerText(value),
                                    onUndelete: (value) => _restoreTagToTagsControllerText(value),
                                    deletedTags: _deletedTags,
                                  )
                              ).toList(),
                              ...item.contexts.map((context) =>
                                  DeletableTag(
                                    item: item,
                                    tag: context,
                                    iconColor: TxDxColors.contexts,
                                    onDelete: (value) => _removeTagFromTagsControllerText(value),
                                    onUndelete: (value) => _restoreTagToTagsControllerText(value),
                                    deletedTags: _deletedTags,
                                  )
                              ).toList(),
                              if (!item.completed)
                              ...item.tagsWithoutDue.keys.map((key) =>
                                  DeletableTag(
                                    item: item,
                                    tag: '$key:${item.tags[key]}',
                                    iconColor: TxDxColors.tags,
                                    onDelete: (value) => _removeTagFromTagsControllerText(value),
                                    onUndelete: (value) => _restoreTagToTagsControllerText(value),
                                    deletedTags: _deletedTags,
                                  )
                              ).toList(),
                              if (item.completed)
                                ...item.tags.keys.map((key) =>
                                    DeletableTag(
                                      item: item,
                                      tag: '$key:${item.tags[key]}',
                                      iconColor: TxDxColors.tags,
                                      onDelete: (value) => _removeTagFromTagsControllerText(value),
                                      onUndelete: (value) => _restoreTagToTagsControllerText(value),
                                      deletedTags: _deletedTags,
                                    )
                                ).toList(),
                            ],
                          ),
                        )
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

                      ],
                    ),
                  ),
                  if (!item.completed) Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: DueOnPicker(item, _dueOnController, _descriptionFocusNode),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: PriorityPicker(item, _priorityController, _descriptionFocusNode),
                        ),
                      ],
                    ),
                  ),
                ],
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
