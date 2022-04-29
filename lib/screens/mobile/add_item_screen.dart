import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';
import 'package:txdx/txdx/txdx_item.dart';

import '../../config/colors.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {

  final _descriptionController = TextEditingController();
  bool isCompleted = false;

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

  TxDxItem _itemFromInput() {
    final item = TxDxItem.fromText(_descriptionController.text);

    if (isCompleted) {
      return item.toggleComplete();
    } else {
      return item;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: TxDxColors.txdxGradient(),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.clear_sharp),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // TODO: Add button to save the item and clear the form for the next item.
          // IconButton(onPressed: () {}, icon: Icon(Icons.flash_on_sharp)),
          IconButton(
            icon: const Icon(Icons.check_sharp),
            onPressed: () {
              ref.read(todoItemsProvider.notifier).addItem(_itemFromInput());
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Checkbox(
                    onChanged: (value) { setState(() => isCompleted = value!); },
                    value: isCompleted,
                  ),
                ),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    minLines: 1,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'New task',
                    ),
                  ),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}