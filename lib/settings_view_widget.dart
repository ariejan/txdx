import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsViewWidget extends ConsumerWidget {
  const SettingsViewWidget({Key? key}) : super(key: key);

  Future<String?> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['txt'],
      );

      if (result != null) {
        print(result.files.first.path);
        return result.files.first.path;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onPressed: _pickFile,
            )
          ],
        )
      ),
    );
  }
}
