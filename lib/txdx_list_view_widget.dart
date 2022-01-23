import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/main.dart';

import 'txdx/txdx.dart';
import 'txdx_item_widget.dart';

class TxDxListViewWidget extends ConsumerWidget {
  const TxDxListViewWidget({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filename = ref.watch(filenameNotifierProvider).value;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Consumer(builder: (context, ref, _) {
                final items = ref.watch(itemsNotifierProvider);
                return items.map(
                  data: (data) {
                    final theItems = data.value;
                    return ListView.builder(
                      itemCount: theItems.length,
                      itemBuilder: (_, i) {
                        final item = theItems[i];
                        return TxDxItemWidget(
                          item,
                          onCompletedToggle: (bool value) {
                            ref.read(itemsNotifierProvider.notifier).toggleComplete(item.id);
                          },
                        );
                      },
                    );
                  },
                  loading: (_) => const Center(child: CircularProgressIndicator()),
                  error: (_) => const Text('Error...'),
                );
              }),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
            color: Colors.brown.shade800,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Text(
                      '>> ' + (filename ?? 'no file selected'),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.white,
                      )
                  ),
                ),

                SizedBox(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/settings'),
                    child: const Text(
                        'select file',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                )
              ],
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final items = ref.read(itemsNotifierProvider.notifier);
          print('creating new item via button');
          items.createNewItem();
        },
      ),
    );
  }
}
