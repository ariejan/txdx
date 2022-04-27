
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/items/contexts_provider.dart';
import 'package:txdx/providers/items/item_count_provider.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';
import 'package:txdx/providers/items/projects_provider.dart';

import '../../config/filters.dart';
import '../../config/icons.dart';
import '../../config/colors.dart';
import '../../providers/files/file_notifier_provider.dart';
import 'menu_header_widget.dart';
import 'menu_item_widget.dart';

class SidebarWidget extends ConsumerWidget {
  const SidebarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contexts = ref.watch(contextsProvider);
    final projects = ref.watch(projectsProvider);

    final badgeColor = Theme.of(context).highlightColor;
    final archiveAvailable = ref.watch(archivingAvailableProvider);

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MenuItemWidget(
                    iconData: txdxIconData[filterAll],
                    title: 'All',
                    itemFilterValue: filterAll,
                    badgeCount: ref.watch(itemsCount(filterAll)),
                    badgeColor: badgeColor,
                  ),
                  MenuItemWidget(
                    iconData: txdxIconData[filterToday],
                    title: 'Today',
                    itemFilterValue: filterToday,
                    badgeCount: ref.watch(itemsCount(filterToday)),
                    badgeColor: badgeColor,
                  ),
                  MenuItemWidget(
                    iconData: txdxIconData[filterUpcoming],
                    title: 'Upcoming',
                    itemFilterValue: filterUpcoming,
                    badgeCount: ref.watch(itemsCount(filterUpcoming)),
                    badgeColor: badgeColor,
                  ),
                  MenuItemWidget(
                    iconData: txdxIconData[filterSomeday],
                    title: 'Someday',
                    itemFilterValue: filterSomeday,
                    badgeCount: ref.watch(itemsCount(filterSomeday)),
                    badgeColor: badgeColor,
                  ),
                  MenuItemWidget(
                    iconData: txdxIconData[filterOverdue],
                    title: 'Overdue',
                    itemFilterValue: filterOverdue,
                    badgeCount: ref.watch(itemsCount(filterOverdue)),
                    badgeColor: badgeColor,
                  ),

                  if (archiveAvailable) MenuItemWidget(
                    iconData: Icons.archive_outlined,
                    title: 'Archive',
                    highlighted: ref.watch(currentlyAccessibleFileProvider) == AccessibleFile.ARCHIVE,
                    onTap: () {
                      print('opening archives');
                      ref.read(currentlyAccessibleFileProvider.state).state = AccessibleFile.ARCHIVE;
                    },
                  ),

                  if (projects.isNotEmpty) const MenuHeaderWidget(
                    'Projects',
                    fontSize: 14 ,
                    margin: EdgeInsets.fromLTRB(0, 12, 0, 8),
                  ),

                  Column(
                    children: projects.map((project) =>
                      MenuItemWidget(
                        title: project,
                        iconData: Icons.label_sharp,
                        indicatorColor: TxDxColors.projects,
                        itemFilterValue: project,
                        badgeCount: ref.watch(itemsCount(project)),
                        badgeColor: badgeColor,
                      )
                    ).toList(),
                  ),

                  if (contexts.isNotEmpty) const MenuHeaderWidget(
                    'Contexts',
                    fontSize: 14,
                    margin: EdgeInsets.fromLTRB(0, 12, 0, 8),
                  ),

                  Column(
                    children: contexts.map((context) =>
                        MenuItemWidget(
                          title: context,
                          iconData: Icons.label_sharp,
                          indicatorColor: TxDxColors.contexts,
                          itemFilterValue: context,
                          badgeCount: ref.watch(itemsCount(context)),
                          badgeColor: badgeColor,
                        )
                    ).toList(),
                  ),

                ]
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? TxDxColors.lightBackground
                : TxDxColors.darkBackground,
            border: Border(
              top: BorderSide(color: Theme.of(context).brightness == Brightness.light
                  ? TxDxColors.lightEditBorder
                  : TxDxColors.darkEditBorder,
              ),
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MenuItemWidget(
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                  title: 'Settings',
                  iconData: Icons.tune_sharp,
                  color: Theme.of(context).disabledColor,
                ),
              ]
          ),
        ),
      ],
    );
  }
}