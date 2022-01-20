import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'txdx/txdx.dart';
import 'txdx_item_widget.dart';

final txdxProvider = StateNotifierProvider<TxDxList, List<TxDxItem>>((ref) {
  return TxDxList([
    TxDxItem.fromText('(A) 2022-01-12 Do something with priority +project @context'),
    TxDxItem.fromText('(C) 2022-01-12 Do something later +project @context due:2022-12-31'),
    TxDxItem.fromText('x 2022-01-13 2022-01-10 Did something +project @context pri:B'),
  ]);
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

    return Scaffold(
      body: ListView(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/settings'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
