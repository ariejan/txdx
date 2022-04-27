import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../txdx/txdx_item.dart';

class DeletableTag extends ConsumerStatefulWidget {
  const DeletableTag({
    Key? key,
    required this.item,
    required this.tag,
    this.iconColor,
    this.onDelete,
    this.onUndelete,
    this.deletedTags,
  }) : super(key: key);

  final TxDxItem item;
  final String tag;
  final Color? iconColor;
  final Function(String)? onDelete;
  final Function(String)? onUndelete;
  final List<String>? deletedTags;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeletableTagStage();
}

class _DeletableTagStage extends ConsumerState<DeletableTag> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final isDeleted = (widget.deletedTags?.contains(widget.tag) ?? false);

    return InkWell(
      mouseCursor: MouseCursor.defer,
      onTap: () {},
      onHover: (hovering) {
        setState(() => isHovering = hovering);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
        child: Wrap(
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
                if (isDeleted) {
                  widget.onUndelete?.call(widget.tag);
                } else {
                  widget.onDelete?.call(widget.tag);
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 4, 0),
                child: Icon(
                    isDeleted ? Icons.settings_backup_restore_sharp : Icons.clear_sharp,
                    size: 14,
                ),
              ),
            ),
            Text(
              widget.tag,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).hintColor,
                decoration: isDeleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}