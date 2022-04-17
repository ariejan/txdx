import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../config/settings.dart';
import '../utils/browser.dart';
import '../providers/settings/platform_info_provider.dart';
import '../providers/settings/settings_provider.dart';
import '../widgets/navigation/menu_header_widget.dart';
import '../utils/file_picker_helper.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namespace = ref.watch(namespaceProvider);
    final appVersion = ref.watch(appVersionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 64),
            child: Column(
              children: [
                SizedBox(
                    width: 700,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MenuHeaderWidget(
                            'Interface settings',
                            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          ),

                          Table(
                              children: [
                                TableRow(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Theme'),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    value: ref.watch(settingsProvider).getString(settingsThemeBrightness),
                                                    buttonHeight: 28,
                                                    buttonPadding: const EdgeInsets.all(0),
                                                    buttonWidth: 180,
                                                    itemHeight: 28,
                                                    onChanged: (value) {
                                                      ref.read(settingsProvider).setString(settingsThemeBrightness, value as String);
                                                    },
                                                    hint: Text(
                                                      'Select Item',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme
                                                            .of(context)
                                                            .hintColor,
                                                      ),
                                                    ),
                                                    items: settingsThemeBrightnessOptions.keys
                                                        .map((key) =>
                                                        DropdownMenuItem<String>(
                                                          value: key,
                                                          child: Text(
                                                            settingsThemeBrightnessOptions[key]!,
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        )).toList(),
                                                  ),
                                                ),
                                              ]
                                          )
                                      )
                                    ]
                                ),


                                TableRow(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Start-up default filter'),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    value: ref.watch(settingsProvider).getString(settingsDefaultFilter),
                                                    buttonHeight: 28,
                                                    buttonPadding: const EdgeInsets.all(0),
                                                    buttonWidth: 180,
                                                    itemHeight: 28,
                                                    onChanged: (value) {
                                                      ref.read(settingsProvider).setString(settingsDefaultFilter, value as String);
                                                    },
                                                    hint: Text(
                                                      'Select Item',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme
                                                            .of(context)
                                                            .hintColor,
                                                      ),
                                                    ),
                                                    items: settingsDefaultFilterItems.keys
                                                        .map((key) =>
                                                        DropdownMenuItem<String>(
                                                          value: key,
                                                          child: Text(
                                                            settingsDefaultFilterItems[key]!,
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        )).toList(),
                                                  ),
                                                ),
                                              ]
                                          )
                                      )
                                    ]
                                ),

                                TableRow(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Show items due today in Upcoming'),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Switch(
                                                  value: ref.watch(settingsProvider).getBool(settingsTodayInUpcoming),
                                                  onChanged: (value) {
                                                    ref.read(settingsProvider).setBool(settingsTodayInUpcoming, value);
                                                  },
                                                ),
                                              ]
                                          )
                                      )
                                    ]
                                ),

                                TableRow(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Number of days for Upcoming items'),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const FaIcon(FontAwesomeIcons.minus, size: 10),
                                                  onPressed: () {
                                                    _updateSettingsNextUpDays(-1, ref);
                                                  },
                                                ),
                                                Text(ref.watch(settingsProvider).getInt(settingsUpcomingDays).toString(),
                                                ),
                                                IconButton(
                                                  icon: const FaIcon(FontAwesomeIcons.plus, size: 10),
                                                  onPressed: () {
                                                    _updateSettingsNextUpDays(1, ref);
                                                  },
                                                ),
                                              ]
                                          )
                                      )
                                    ]
                                ),

                                TableRow(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Automatically add current project or context filter to new items.'),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Switch(
                                                  value: ref.watch(settingsProvider).getBool(settingsAutoAddFilter),
                                                  onChanged: (value) {
                                                    ref.read(settingsProvider).setBool(settingsAutoAddFilter, value);
                                                  },
                                                ),
                                              ]
                                          )
                                      )
                                    ]
                                ),
                              ]
                          ),

                          const MenuHeaderWidget(
                            'File settings',
                            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          ),

                          Table(
                              children: [
                                TableRow(
                                    children: [
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
                                              final txdxDir = ref.watch(settingsProvider).getString(settingsTxDxDirectory);
                                              final txdxDirSet = txdxDir?.isNotEmpty ?? false;
                                              return Text(
                                                  txdxDirSet ? txdxDir! : 'No directory selected'
                                              );
                                            }),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                if (ref.watch(settingsProvider).getString(settingsTxDxDirectory)?.isNotEmpty ?? false) TextButton(
                                                  child: Row(
                                                      children: const [
                                                        FaIcon(FontAwesomeIcons.xmark, size: 12),
                                                        Text(' Clear'),
                                                      ]
                                                  ),
                                                  onPressed: () {
                                                    ref.read(settingsProvider).setString(settingsTxDxDirectory, '');
                                                    ref.read(settingsProvider).setString(settingsTxDxDirectoryMacosSecureBookmark, '');
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('📂 Select directory'),
                                                  onPressed: () => pickTxDxDirectory(ref),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                ),
                                TableRow(
                                    children: [
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
                                                    value: ref.watch(settingsProvider).getBool(settingsFileAutoReload),
                                                    onChanged: (value) {
                                                      ref.watch(settingsProvider).setBool(settingsFileAutoReload, value);
                                                    }
                                                ),
                                              ]
                                          )
                                      )
                                    ]
                                ),
                                TableRow(
                                    children: [
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
                                                    value: ref.watch(settingsProvider).getBool(settingsFileSaveOrdered),
                                                    onChanged: (value) {
                                                      ref.watch(settingsProvider).setBool(settingsFileSaveOrdered, value);
                                                    }
                                                ),
                                              ]
                                          )
                                      )
                                    ]
                                ),
                              ]
                          ),

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
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateSettingsNextUpDays(int change, WidgetRef ref) {
    final settings = ref.read(settingsProvider);

    var current = settings.getInt(settingsUpcomingDays);
    settings.setInt(settingsUpcomingDays, (current + change).clamp(nextUpDaysMin, nextUpDaysMax));
  }
}
