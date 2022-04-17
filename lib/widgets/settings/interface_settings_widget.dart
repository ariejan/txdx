import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/settings.dart';
import '../../providers/items/filter_provider.dart';
import '../../providers/settings/settings_provider.dart';
import '../navigation/menu_header_widget.dart';

class InterfaceSettingsWidget extends ConsumerWidget {
  const InterfaceSettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterOptions = ref.watch(filterProvider);

    final currentFilter = ref.watch(interfaceSettingsProvider).getString(settingsDefaultFilter);
    if (currentFilter != null && !filterOptions.keys.contains(currentFilter)) {
      filterOptions[currentFilter] = currentFilter;
    }

    return Column(
      children: [
        const MenuHeaderWidget(
          'Interface settings',
          margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
        ),

        Table(
            children: [
              TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Theme'),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  value: ref.watch(interfaceSettingsProvider).getString(settingsThemeBrightness),
                                  buttonHeight: 28,
                                  buttonPadding: const EdgeInsets.all(0),
                                  buttonWidth: 180,
                                  itemHeight: 28,
                                  onChanged: (value) {
                                    ref.read(interfaceSettingsProvider).setString(settingsThemeBrightness, value as String);
                                  },
                                  hint: Text(
                                    'Select Item',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme
                                          .of(context)
                                          .hintColor,
                                    ),
                                  ),
                                  items: settingsThemeBrightnessOptions.keys
                                      .map((key) =>
                                      DropdownMenuItem<String>(
                                        value: key,
                                        child: Text(
                                          settingsThemeBrightnessOptions[key]!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )).toList(),
                                ),
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
                      child: Text('Start-up default filter'),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  value: ref.watch(interfaceSettingsProvider).getString(settingsDefaultFilter),
                                  buttonHeight: 28,
                                  buttonPadding: const EdgeInsets.all(0),
                                  buttonWidth: 180,
                                  itemHeight: 28,
                                  onChanged: (value) {
                                    ref.read(interfaceSettingsProvider).setString(settingsDefaultFilter, value as String);
                                  },
                                  hint: Text(
                                    'Select Item',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme
                                          .of(context)
                                          .hintColor,
                                    ),
                                  ),
                                  items: filterOptions.keys
                                      .map((key) =>
                                      DropdownMenuItem<String>(
                                        value: key,
                                        child: Text(
                                          filterOptions[key]!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )).toList(),
                                ),
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
                      child: Text('Show items due today in Upcoming'),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Switch(
                                value: ref.watch(interfaceSettingsProvider).getBool(settingsTodayInUpcoming),
                                onChanged: (value) {
                                  ref.read(interfaceSettingsProvider).setBool(settingsTodayInUpcoming, value);
                                },
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
                      child: Text('Number of days for Upcoming items'),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const FaIcon(FontAwesomeIcons.minus, size: 10),
                                onPressed: () {
                                  _updateSettingsNextUpDays(-1, ref);
                                },
                              ),
                              Text(ref.watch(interfaceSettingsProvider).getInt(settingsUpcomingDays).toString(),
                              ),
                              IconButton(
                                icon: const FaIcon(FontAwesomeIcons.plus, size: 10),
                                onPressed: () {
                                  _updateSettingsNextUpDays(1, ref);
                                },
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
                      child: Text('Automatically add current project or context filter to new items.'),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Switch(
                                value: ref.watch(interfaceSettingsProvider).getBool(settingsAutoAddFilter),
                                onChanged: (value) {
                                  ref.read(interfaceSettingsProvider).setBool(settingsAutoAddFilter, value);
                                },
                              ),
                            ]
                        )
                    )
                  ]
              ),
            ]
        ),
      ]
    );
  }

  void _updateSettingsNextUpDays(int change, WidgetRef ref) {
    final settings = ref.read(interfaceSettingsProvider);

    var current = settings.getInt(settingsUpcomingDays);
    settings.setInt(settingsUpcomingDays, (current + change).clamp(nextUpDaysMin, nextUpDaysMax));
  }
}