import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/config/colors.dart';
import 'package:txdx/widgets/settings/version_info_widget.dart';

import '../widgets/settings/file_settings_widget.dart';
import '../widgets/settings/interface_settings_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Settings"),
        backgroundColor: Theme.of(context).brightness == Brightness.light
          ? TxDxColors.lightBackground
          : TxDxColors.darkBackground,
        foregroundColor: Theme.of(context).textTheme.bodyText2?.color,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 16, 0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.clear_sharp, size: 18),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 64),
            child: Column(
              children: [
                SizedBox(
                    width: 600,
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

