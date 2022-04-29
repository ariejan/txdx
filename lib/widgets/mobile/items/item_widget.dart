import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';

import '../../../config/colors.dart';
import '../../../txdx/txdx_item.dart';
import '../../common/items/due_on_widget.dart';
import '../../common/items/label_widget.dart';
import '../../common/items/priority_dot.dart';

class ItemWidget extends ConsumerStatefulWidget {
  const ItemWidget(this.item, {Key? key}) : super(key: key);

  final TxDxItem item;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends ConsumerState<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          PriorityDot(widget.item),
          Checkbox(
            onChanged: (value) {
              ref.read(todoItemsProvider.notifier).toggleComplete(widget.item.id);
            },
            value: widget.item.completed,
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.item.description,
                    style: TextStyle(
                      decoration: widget.item.completed ? TextDecoration.lineThrough : null,
                      color: widget.item.completed ? Theme.of(context).disabledColor : null,
                    )
                  ),
                  if (!widget.item.completed) Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (var project in widget.item.projects) ...[
                          LabelWidget(project,
                              color: TxDxColors.projects,
                              iconData: Icons.label_sharp),
                        ],
                        for (var context in widget.item.contexts) ...[
                          LabelWidget(context,
                              color: TxDxColors.contexts,
                              iconData: Icons.label_sharp),
                        ],
                        for (var key in widget.item.tagsWithoutDue.keys) ...[
                          LabelWidget('$key:${widget.item.tags[key]}',
                              color: TxDxColors.tags,
                              iconData: Icons.label_sharp),
                        ],
                      ],
                  ),
                ],
              ),
            ),
          ),
          if (!widget.item.completed && widget.item.hasDueOn)
            DueOnWidget(widget.item.dueOn!),
        ]
      ),
    );
  }
}