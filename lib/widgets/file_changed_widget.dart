import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:txdx/providers/item_notifier_provider.dart';
import 'package:txdx/theme/colors.dart';

import '../providers/file_change_provider.dart';

class FileChangedWidget extends ConsumerWidget {
  const FileChangedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialBanner(
      content: const Text('Your todo.txt file has changed on disk.'),
      padding: const EdgeInsets.all(16),
      backgroundColor: TxDxColors.banner,
      leading: const FaIcon(FontAwesomeIcons.circleExclamation),
      actions: [
        TextButton(
          child: const Text('RELOAD'),
          onPressed: () {
            ref.read(itemsNotifierProvider.notifier).loadItemsFromDisk();
            ref.read(fileWasChanged.state).state = false;
          }
        ),
      ],
    );
  }
}
