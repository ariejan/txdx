import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/input/browser.dart';
import 'package:txdx/providers/file_notifier_provider.dart';

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
                                final filenameNotifier = ref.watch(todoTxtFilenameProvider);
                                return filenameNotifier.map(
                                  data: (data) => Text(
                                      (data.value == null) ? 'No file selected' : data.value!
                                  ),
                                  loading: (_) => const CircularProgressIndicator(),
                                  error: (_) => const Text('Error'),
                                );
                              }),
                              TextButton(
                                child: const Text('📂 Select file'),
                                onPressed: () => {
                                  _pickFile().then((filename) {
                                    ref.read(todoTxtFilenameProvider.notifier).setFilename(filename ?? '');
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
                                  final filenameNotifier = ref.watch(archiveTxtFilenameProvider);
                                  return filenameNotifier.map(
                                    data: (data) => Text(
                                        (data.value == null) ? 'No file selected' : data.value!
                                    ),
                                    loading: (_) => const CircularProgressIndicator(),
                                    error: (_) => const Text('Error'),
                                  );
                                }),
                                TextButton(
                                  child: const Text('📂 Select file'),
                                  onPressed: () => {
                                    _pickFile().then((filename) {
                                      ref.read(archiveTxtFilenameProvider.notifier).setFilename(filename ?? '');
                                    })
                                  },
                                ),
                              ],
                            ),
                          )
                        ]
                    )
                  ]
                ),

                const MenuHeaderWidget(
                  'About',
                  margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                ),

                const Text('TxDx 1.0.0', style: TextStyle(fontWeight: FontWeight.bold)),
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
}
