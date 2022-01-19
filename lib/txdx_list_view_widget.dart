import 'package:flutter/material.dart';

import 'txdx/txdx.dart';
import 'txdx_item_widget.dart';

class TxDxListViewWidget extends StatefulWidget {
  const TxDxListViewWidget({Key? key, required this.filename})
      : super(key: key);

  final String filename;

  @override
  State<TxDxListViewWidget> createState() => _TxDxListViewWidgetState();
}

class _TxDxListViewWidgetState extends State<TxDxListViewWidget> {
  void _newTodoDialog() {
    Navigator.pushNamed(context, '/settings');
  }

  late TxDxList txDxContext;

  List<Widget> _getTxDxItemContainers() {
    return txDxContext.items
        .map((item) => TxDxItemWidget(
              item,
              onCompletedToggle: (bool completed) {
                setState(() {
                  item.setCompleted(completed);
                });
              },
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    txDxContext = TxDxList(widget.filename);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: _getTxDxItemContainers(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
