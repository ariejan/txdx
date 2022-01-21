import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main.dart';

class SettingsViewWidget extends ConsumerWidget {
  const SettingsViewWidget({Key? key}) : super(key: key);

  Future<String?> _pickFile(WidgetRef ref) async {
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
    final prefs = ref.watch(sharedPreferencesProvider);
    final String? _filename = prefs.getString('filename');

    return Material(
      child: Container(
        child: Column(
          children: [
            TextButton(
              child: Text('back'),
              onPressed: () => Navigator.pop(context)
            ),
            Text('Settings'),
            TextButton(
              child: Text('pick file'),
              onPressed: () => {
                _pickFile(ref).then((filename) {
                  prefs.setString('filename', filename ?? '');
                  ref.refresh(sharedPreferencesProvider);
                })
              },
            ),
            Text('Seleced file: ${_filename ?? 'no file selected'}'),
          ],
        )
      ),
    );
  }
}
