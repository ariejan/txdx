import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewWidget extends StatefulWidget {
  SettingsViewWidget({Key? key}) : super(key: key);

  @override
  _SettingsViewWidgetState createState() => _SettingsViewWidgetState();
}

class _SettingsViewWidgetState extends State<SettingsViewWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _filename;

  void _pickFile() async {
    final SharedPreferences prefs = await _prefs;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['txt'],
      );

      if (result != null) {
        String filename = result.files.first.path ?? '';

        setState(() {
          _filename = prefs.setString('filename', filename).then((bool success) {
            return filename;
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<String> _filename = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('filename') ?? '';
    });

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
            ),
            FutureBuilder<String>(
              future: _filename,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text('Selected: ${snapshot.data}');
                    }
                }
              }
            ),
          ],
        )
      ),
    );
  }
}
