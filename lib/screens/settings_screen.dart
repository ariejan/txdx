import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';
import 'package:txdx/input/browser.dart';

import '../config/settings.dart';
import '../providers/settings/platform_info_provider.dart';
import '../providers/settings/settings_provider.dart';
import '../widgets/navigation/menu_header_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<String?> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      return result.files.first.path;
    }

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namespace = ref.watch(namespaceProvider);
    final appVersion = ref.watch(appVersionProvider);

    final usingSystemTheme = ref.watch(settingsProvider).getBool(settingsThemeUseSystem);

    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  child: const Text('❮ back'),
                  onPressed: () => Navigator.pop(context)
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
              child: SizedBox(
                width: 500,
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
                                child: Text('Use system theme brightness'),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Switch(
                                            value: ref.watch(settingsProvider).getBool(settingsThemeUseSystem),
                                            onChanged: (value) {
                                              ref.read(settingsProvider).setBool(settingsThemeUseSystem, value);
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
                                child: Text('Use system dark theme'),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Switch(
                                            value: ref.watch(settingsProvider).getBool(settingsThemeUseDark),
                                            onChanged: !usingSystemTheme ? (value) {
                                              ref.read(settingsProvider).setBool(settingsThemeUseDark, value);
                                            } : null,
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
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                              value: ref.watch(settingsProvider).getString(settingsDefaultFilter),
                                              buttonHeight: 28,
                                              buttonPadding: const EdgeInsets.all(0),
                                              buttonWidth: 140,
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
                                  padding: const EdgeInsets.all(8.0),
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
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.minus, size: 12),
                                    onPressed: () {
                                      _updateSettingsNextUpDays(-1, ref);
                                    },
                                  ),
                                  Text(ref.watch(settingsProvider).getInt(settingsUpcomingDays).toString(),
                                  ),
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.plus, size: 12),
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
                                child: Text('Todo.txt file'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Consumer(builder: (context, ref, _) {
                                      final filename = ref.watch(settingsProvider).getString(settingsFileTodoTxt);
                                      return Text(
                                          filename ?? 'No file selected'
                                      );
                                    }),
                                    TextButton(
                                      child: const Text('📂 Select file'),
                                      onPressed: () => {
                                        _pickFile().then((filename) async {
                                          if (Platform.isMacOS && filename != null) {
                                            final _secureBookmarks = SecureBookmarks();
                                            final bookmark = await _secureBookmarks.bookmark(File(filename));
                                            ref.read(settingsProvider).setString(settingsTodoTxtMacosSecureBookmark, bookmark);
                                          }
                                          ref.read(settingsProvider).setString(settingsFileTodoTxt, filename ?? '');
                                        })
                                      },
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
                        TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Archive.txt file'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Consumer(builder: (context, ref, _) {
                                      final filename = ref.watch(settingsProvider).getString(settingsFileArchiveTxt);
                                      return Text(
                                          filename ?? 'No file selected'
                                      );
                                    }),
                                    TextButton(
                                      child: const Text('📂 Select file'),
                                      onPressed: () => {
                                        _pickFile().then((filename) async {
                                          if (Platform.isMacOS && filename != null) {
                                            final _secureBookmarks = SecureBookmarks();
                                            final bookmark = await _secureBookmarks.bookmark(File(filename));
                                            ref.read(settingsProvider).setString(settingsArchiveTxtMacosSecureBookmark, bookmark);
                                          }

                                          ref.read(settingsProvider).setString(settingsFileArchiveTxt, filename ?? '');
                                        })
                                      },
                                    ),
                                  ],
                                ),
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
                    const Text('Published under the MIT License'),
                    TextButton(
                      onPressed: () => launchInBrowser('https://www.devroom.io/txdx'),
                      child: const Text('https://www.devroom.io/txdx')
                    )

                  ]
                )
              ),
            ),
          ],
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
