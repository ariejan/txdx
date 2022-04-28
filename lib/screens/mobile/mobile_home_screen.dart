import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text('TxDx'),
      ),
      body: const Center(child: Text('Hello mobile world')),
    );
  }

}