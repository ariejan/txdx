import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/config/shortcuts.dart';

import '../../txdx/txdx_item.dart';

class DeletableTag extends ConsumerStatefulWidget {
  const DeletableTag({
    Key? key,
    required this.item,
    required this.tag,
    this.iconColor,
  }) : super(key: key);

  final TxDxItem item;
  final String tag;
  final Color? iconColor;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeletableTagStage();
}

class _DeletableTagStage extends ConsumerState<DeletableTag> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
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
                Icons.label_sharp,
                size: 14,
                color: widget.iconColor ?? Theme.of(context).hintColor
              ),
            ),
            if (isHovering) GestureDetector(
              onTap: () {
                Actions.invoke(context, DeleteTagIntent(widget.item.id, widget.tag));
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 2, 4, 0),
                child: Icon(
                    Icons.clear_sharp,
                    size: 14,
                ),
              ),
            ),
            Text(
              widget.tag,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}