import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/items/scoped_item_notifier.dart';

import '../../../config/settings.dart';
import '../../../providers/items/filter_provider.dart';
import '../../../providers/settings/settings_provider.dart';
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
          margin: EdgeInsets.fromLTRB(8, 12, 9, 12),
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
                                  buttonPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  itemHeight: 28,
                                  buttonHeight: 28,
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
                                        child: SizedBox(
                                          width: 140,
                                          child: Text(
                                            settingsThemeBrightnessOptions[key]!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
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
                                  buttonPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  itemHeight: 28,
                                  buttonHeight: 28,
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
                                        child: SizedBox(
                                          width: 140,
                                          child: Text(
                                            filterOptions[key]!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
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

              if (Platform.isMacOS) TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Filter for dock badge counter'),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  value: ref.watch(interfaceSettingsProvider).getString(settingsFilterMacosBadgeCount),
                                  buttonPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  itemHeight: 28,
                                  buttonHeight: 28,
                                  onChanged: (value) {
                                    ref.read(interfaceSettingsProvider).setString(settingsFilterMacosBadgeCount, value as String);
                                  },
                                  hint: Text(
                                    'Select Item',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                        child: SizedBox(
                                          width: 140,
                                          child: Text(
                                            filterOptions[key]!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
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
                                splashRadius: 10,
                                icon: const Icon(Icons.remove_sharp, size: 12),
                                onPressed: () {
                                  _updateSettingsNextUpDays(-1, ref);
                                },
                              ),
                              Text(ref.watch(interfaceSettingsProvider).getInt(settingsUpcomingDays).toString(),
                              ),
                              IconButton(
                                splashRadius: 10,
                                icon: const Icon(Icons.add_sharp, size: 12),
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
                      child: Text('Default item sorting'),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  value: ref.watch(interfaceSettingsProvider).getItemStateSorter(settingsDefaultSorting),
                                  buttonPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  buttonWidth: 180,
                                  itemHeight: 28,
                                  buttonHeight: 28,
                                  onChanged: (value) {
                                    ref.read(interfaceSettingsProvider).setItemStateSorter(settingsDefaultSorting, value as ItemStateSorter);
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
                                  items: settingsSortOrders.keys
                                      .map((key) =>
                                      DropdownMenuItem<ItemStateSorter>(
                                        value: key,
                                        child: Text(
                                          settingsSortOrders[key]!,
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