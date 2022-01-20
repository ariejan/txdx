import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'txdx/txdx.dart';
import 'txdx_item_widget.dart';

final txdxFilename = Provider<String?>((ref) => null);

final txdxProvider = StateNotifierProvider<TxDxList, List<TxDxItem>>((ref) {
  return TxDxList([]);
});

final uncompletedTodosCount = Provider<int>((ref) {
  return ref.watch(txdxProvider).where((item) => !item.completed).length;
});

class TxDxListViewWidget extends ConsumerWidget {
  const TxDxListViewWidget({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(txdxProvider);
    final filename = ref.watch(txdxFilename);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  for (var item in items) ...[
                    TxDxItemWidget(
                      item,
                      onCompletedToggle: (bool completed) {
                        ref.read(txdxProvider.notifier).toggle(item.id);
                      },
                    ),
                  ],
                ],
              ),
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
      )
    );
  }
}
