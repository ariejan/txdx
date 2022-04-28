
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:txdx/txdx/txdx_item.dart';

class DueOnPicker extends ConsumerStatefulWidget {

  final TxDxItem item;
  final TextEditingController controller;
  final FocusNode parentFocusNode;

  const DueOnPicker(this.item, this.controller, this.parentFocusNode, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DueOnPickerState();
}

class _DueOnPickerState extends ConsumerState<DueOnPicker> {
  bool isHovering = false;

  final dueOnTextDefault = "No due date set";
  String dueOnText = '';

  void _setDueOn(DateTime? dueOn) {
    if (dueOn != null) {
      final strDueOn = Jiffy(dueOn).format('yyyy-MM-dd');

      widget.controller.text = strDueOn;
      setState(() => dueOnText = strDueOn);
    } else {
      widget.controller.text = '';
      setState(() => dueOnText = dueOnTextDefault);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (dueOnText.isEmpty) {
      _setDueOn(widget.item.dueOn);
    }

    return InkWell(
      mouseCursor: MouseCursor.defer,
      onTap: () {},
      onHover: (hovering) {
        setState(() => isHovering = hovering);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
        child: Row(
          children: [
            if (!isHovering) Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 4, 0),
              child: Icon(
                  Icons.flag_sharp,
                  size: 14,
                  color: Theme.of(context).hintColor
              ),
            ),
            if (isHovering) GestureDetector(
              onTap: () {
                _setDueOn(null);
                widget.parentFocusNode.requestFocus();
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 2, 4, 0),
                child: Icon(
                  Icons.clear_sharp,
                  size: 14,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                showDatePicker(
                  context: context,
                  initialDate: widget.item.dueOn ?? DateTime.now(),
                  firstDate: DateTime(1970, 1, 1),
                  lastDate: DateTime(2099, 12, 31),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  helpText: 'Due on',
                ).then((pickedDate) {
                  if (pickedDate != null) {
                    _setDueOn(pickedDate);
                  }
                  widget.parentFocusNode.requestFocus();
                });
              },
              child: Text(
                dueOnText,
                style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

}