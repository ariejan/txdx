import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/items/scoped_item_notifier.dart';
import 'package:txdx/widgets/mobile/items/item_widget.dart';
import 'package:txdx/widgets/mobile/navigation/txdx_drawer.dart';

import '../../config/colors.dart';
import '../../providers/settings/settings_provider.dart';
import '../../utils/helpers.dart';
import '../../widgets/common/no_txdx_directory_widget.dart';

class MobileHomeScreen extends ConsumerStatefulWidget {
  const MobileHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends ConsumerState<MobileHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isSetupReady = ref.watch(isSetupReadyProvider);
    if (!isSetupReady) {
      return const NoTxDxDirectoryWidget();
    }

    final items = ref.watch(filteredItems);

    return Scaffold(
      appBar: AppBar(
        title: Text(Helpers.getViewTitle(ref)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: TxDxColors.txdxGradient(),
          ),
        ),
      ),
      drawer: const TxDxDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.separated(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ItemWidget(items[index]);
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        onPressed: () => Navigator.pushNamed(context, '/addItem'),
        backgroundColor: TxDxColors.txdxPurple,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.car_rental,
          Icons.blender,
        ],
        activeIndex: 1,
        onTap: (index) {  },
        backgroundColor: TxDxColors.txdxPink,
        inactiveColor: Theme.of(context).appBarTheme.foregroundColor,
        activeColor: Theme.of(context).appBarTheme.foregroundColor,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
      ),
    );
  }

}