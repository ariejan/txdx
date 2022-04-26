import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/settings/platform_info_provider.dart';
import '../../providers/settings/settings_provider.dart';
import '../navigation/menu_header_widget.dart';

class VersionInfoWidget extends ConsumerWidget {
  const VersionInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namespace = ref.watch(namespaceProvider);
    final appVersion = ref.watch(appVersionProvider);

    final versionInfo = '''TxDx $appVersion ($namespace)
    
Copyright © 2022 Ariejan de Vroom
    
[https://www.txdx.eu/support](https://www.txdx.eu/support)
  ''';

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const MenuHeaderWidget(
          'About',
          margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
        ),

        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: double.infinity,
            child: MarkdownBody(
              data: versionInfo,
              onTapLink: (text, href, title) {
                if (href!.isNotEmpty) {
                  launch(href);
                }
              },
            ),
          ),
        ),
      ]
    );
  }

}