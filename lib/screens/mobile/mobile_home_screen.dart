import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/items/scoped_item_notifier.dart';
import 'package:txdx/widgets/mobile/items/item_widget.dart';
import 'package:txdx/widgets/mobile/navigation/txdx_drawer.dart';

import '../../config/colors.dart';
import '../../providers/settings/settings_provider.dart';
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
        title: const Text('TxDx'),
      ),
      drawer: const TxDxDrawer(),
      body: Container(
        color: Theme.of(context).brightness == Brightness.light
          ? TxDxColors.lightSelection
          : TxDxColors.darkSelection,
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ItemWidget(items[index]);
          },
        ),
      ),
      bottomNavigationBar: SizedBox(height: 64, child: Container(color: Colors.pink)),
    );
  }

}