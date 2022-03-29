import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:txdx/input/browser.dart';

import '../settings.dart';
import '../providers/platform_info_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/menu_header_widget.dart';

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
          SizedBox(
            width: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MenuHeaderWidget(
                  'Settings',
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
                                  _pickFile().then((filename) {
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
                                    _pickFile().then((filename) {
                                      ref.read(settingsProvider).setString(settingsFileArchiveTxt, filename ?? '');
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
                          child: Text('Number of days for "Upcoming" items'),
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
                              Text(ref.watch(settingsProvider).getInt(settingsNextUpDays).toString(),
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
                    )
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
        ],
      ),
    );
  }

  void _updateSettingsNextUpDays(int change, WidgetRef ref) {
    final settings = ref.read(settingsProvider);

    var current = settings.getInt(settingsNextUpDays);
    settings.setInt(settingsNextUpDays, (current + change).clamp(nextUpDaysMin, nextUpDaysMax));
  }
}
