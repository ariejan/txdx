import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/settings/platform_info_provider.dart';
import '../../providers/settings/settings_provider.dart';
import '../../utils/browser.dart';
import '../navigation/menu_header_widget.dart';

class VersionInfoWidget extends ConsumerWidget {
  const VersionInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namespace = ref.watch(namespaceProvider);
    final appVersion = ref.watch(appVersionProvider);

    return Column(
      children: [
        const MenuHeaderWidget(
          'About',
          margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
        ),

        Text('TxDx $appVersion ($namespace)', style: const TextStyle(fontWeight: FontWeight.bold)),
        const Text('Copyright © 2022 Ariejan de Vroom'),
        Linkify(
          text: "https://www.txdx.eu",
          onOpen: (LinkableElement link) {
            launchInBrowser(link.url);
          },
        ),
      ]
    );
  }

}