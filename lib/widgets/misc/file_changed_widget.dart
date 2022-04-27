import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';
import 'package:txdx/config/colors.dart';

import '../../providers/files/file_change_provider.dart';

class FileChangedWidget extends ConsumerWidget {
  const FileChangedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialBanner(
      content: const Text('Your todo.txt file has changed on disk.'),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      backgroundColor: TxDxColors.banner,
      leading: const Icon(Icons.announcement_sharp),
      actions: [
        TextButton(
          child: const Text('RELOAD'),
          onPressed: () {
            ref.read(todoItemsProvider.notifier).loadItemsFromDisk();
            ref.read(todoFileWasChanged.state).state = false;
          }
        ),
      ],
    );
  }
}
