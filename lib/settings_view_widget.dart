import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsViewWidget extends StatefulWidget {
  const SettingsViewWidget({Key? key}) : super(key: key);

  @override
  State<SettingsViewWidget> createState() => _SettingsViewWidgetState();
}

class _SettingsViewWidgetState extends State<SettingsViewWidget> {

  @override
  Widget build(BuildContext context) {
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