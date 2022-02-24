
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:txdx/widgets/add_item_widget.dart';
import 'package:txdx/widgets/items_list_view.dart';
import 'package:txdx/widgets/sidebar_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: MultiSplitViewTheme(
        child: MultiSplitView(
          initialWeights: const [0.2, 0.8],
          minimalWeight: 0.2,
          children: [
            const SidebarWidget(),
            Column(
              children: const [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: ItemsListView(),
                  ),
                ),
                SizedBox(
                  child: AddItemWidget(),
                ),
              ],
            )
          ],
        ),
        data: MultiSplitViewThemeData(
          dividerPainter: DividerPainters.grooved1(),
        ),
      )
    );
  }
}