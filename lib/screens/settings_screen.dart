import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/txdx/txdx_list.dart';

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
          TextButton(
            child: const Text('back'),
            onPressed: () => Navigator.pop(context)
          ),
          const Text('Settings'),
          TextButton(
            child: const Text('pick file'),
            onPressed: () => {
              _pickFile().then((filename) {
                ref.read(filenameNotifierProvider.notifier).setFilename(filename ?? '');
              })
            },
          ),
          Consumer(builder: (context, ref, _) {
            final filenameNotifier = ref.watch(filenameNotifierProvider);
            return filenameNotifier.map(
              data: (data) => Text('${data.value}'),
              loading: (_) => const CircularProgressIndicator(),
              error: (_) => const Text('Error'),
            );
          }),
        ],
      ),
    );
  }
}
