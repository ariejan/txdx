import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/colors.dart';
import '../../../txdx/txdx_item.dart';

class PriorityDot extends ConsumerStatefulWidget {
  const PriorityDot(this.item, {Key? key}) : super(key: key);

  final TxDxItem item;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PriorityDotState();
}

class _PriorityDotState extends ConsumerState<PriorityDot> {
  @override
  Widget build(BuildContext context) {
    var statusColor = TxDxColors.forPriority(widget.item.priority);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Icon(
        Icons.circle,
        size: 9,
        color:
        widget.item.hasSetPriority() ? statusColor : Colors.transparent,
      ),
    );
  }
}