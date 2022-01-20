import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsViewWidget extends ConsumerWidget {
  const SettingsViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsList(
      sections: [
        SettingsSection(
            title: const Text('TODO.txt files'),
            tiles: [
              SettingsTile(
                leading: const FaIcon(FontAwesomeIcons.android),
                title: const Text('TODO.txt file'),
              ),
              SettingsTile(
                leading: const FaIcon(FontAwesomeIcons.apple),
                title: const Text('Archive file'),
              )
            ]
        )
      ],
    );
  }
}
