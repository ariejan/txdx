
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/config/colors.dart';
import 'package:txdx/txdx/txdx_item.dart';

class PriorityPicker extends ConsumerStatefulWidget {
  const PriorityPicker(this.item, this.controller, this.parentFocusNode, {Key? key}) : super(key: key);

  final TxDxItem item;
  final TextEditingController controller;
  final FocusNode parentFocusNode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PriorityPickerState();
}

class _PriorityPickerState extends ConsumerState<PriorityPicker> {

  String? selectedPriority = 'x';

  void _setPriority(String? priority) {
    widget.controller.text = priority ?? '';
    setState(() => selectedPriority = priority);
    widget.parentFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedPriority == 'x') {
      _setPriority(widget.item.priority ?? '');
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: Row(
        children: [
          buildButton(context, 'A', Icons.circle, TxDxColors.prioA),
          buildButton(context, 'B', Icons.circle, TxDxColors.prioB),
          buildButton(context, 'C', Icons.circle, TxDxColors.prioC),
          buildButton(context, 'D', Icons.circle, TxDxColors.prioD),
          buildButton(context, '', Icons.clear, null),
        ],
      ),
    );
  }


  Widget buildButton(BuildContext context, String priority, IconData iconData, Color? color) {
    return GestureDetector(
      onTap: () {
        _setPriority(priority);
      },
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selectedPriority == priority ? Theme.of(context).highlightColor : Colors.transparent,
        ),
        child: Icon(
          iconData,
          size: 9,
          color: color
        ),
      ),
    );
  }
}