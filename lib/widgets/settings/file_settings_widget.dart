import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/settings.dart';
import '../../providers/settings/settings_provider.dart';
import '../../utils/file_picker_helper.dart';
import '../navigation/menu_header_widget.dart';

class FileSettingsWidget extends ConsumerWidget {
  const FileSettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const MenuHeaderWidget(
          'File settings',
          margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
        ),
        Table(children: [
          TableRow(children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('TxDx Directory'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Consumer(builder: (context, ref, _) {
                    final txdxDir = ref
                        .watch(fileSettingsProvider)
                        .getString(settingsTxDxDirectory);
                    final txdxDirSet = txdxDir?.isNotEmpty ?? false;
                    return Text(
                        txdxDirSet ? txdxDir! : 'No directory selected');
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (ref
                              .watch(fileSettingsProvider)
                              .getString(settingsTxDxDirectory)
                              ?.isNotEmpty ??
                          false)
                        TextButton(
                          child: Row(children: const [
                            Icon(Icons.clear),
                            SizedBox(width: 12),
                            Text('Clear'),
                          ]),
                          onPressed: () {
                            ref
                                .read(fileSettingsProvider)
                                .setString(settingsTxDxDirectory, '');
                            ref.read(fileSettingsProvider).setString(
                                settingsTxDxDirectoryMacosSecureBookmark, '');
                          },
                        ),
                      TextButton(
                        style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
                        child: Row(children: const [
                          Icon(Icons.folder_sharp),
                          SizedBox(width: 12),
                          Text('Select folder'),
                          ]),
                        onPressed: () => pickTxDxDirectory(ref),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ]),
          TableRow(children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Auto-reload Todo.txt changes from disk'),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Switch(
                          value: ref
                              .watch(fileSettingsProvider)
                              .getBool(settingsFileAutoReload),
                          onChanged: (value) {
                            ref
                                .watch(fileSettingsProvider)
                                .setBool(settingsFileAutoReload, value);
                          }),
                    ]))
          ]),
          TableRow(children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Save Todo.txt sorted alphabetically'),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Switch(
                          value: ref
                              .watch(fileSettingsProvider)
                              .getBool(settingsFileSaveOrdered),
                          onChanged: (value) {
                            ref
                                .watch(fileSettingsProvider)
                                .setBool(settingsFileSaveOrdered, value);
                          }),
                    ]))
          ]),
        ]),
      ],
    );
  }
}
