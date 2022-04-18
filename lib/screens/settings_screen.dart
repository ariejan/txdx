import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/widgets/settings/version_info_widget.dart';

import '../widgets/settings/file_settings_widget.dart';
import '../widgets/settings/interface_settings_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        children: const [
                          InterfaceSettingsWidget(),
                          FileSettingsWidget(),
                          VersionInfoWidget(),
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
}
