
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/items/contexts_provider.dart';
import 'package:txdx/providers/items/item_count_provider.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';
import 'package:txdx/providers/items/projects_provider.dart';

import '../../config/filters.dart';
import '../../providers/files/file_notifier_provider.dart';
import '../../config/colors.dart';
import 'menu_header_widget.dart';
import 'menu_item_widget.dart';

class SidebarWidget extends ConsumerWidget {
  const SidebarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contexts = ref.watch(contextsProvider);
    final projects = ref.watch(projectsProvider);

    final archiveAvailable = ref.watch(archivingAvailableProvider);

    final badgeColor = Theme.of(context).brightness == Brightness.dark
        ? TxDxColors.darkBadge2
        : TxDxColors.lightBadge2;

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const MenuHeaderWidget('TxDx'),
                  MenuItemWidget(
                    iconData: Icons.checklist_sharp,
                    title: 'All',
                    itemFilterValue: filterAll,
                    badgeCount: ref.watch(itemsCount(filterAll)),
                    badgeColor: badgeColor,
                  ),
                  MenuItemWidget(
                    iconData: Icons.today_sharp,
                    title: 'Today',
                    itemFilterValue: filterToday,
                    badgeCount: ref.watch(itemsCount(filterToday)),
                    badgeColor: badgeColor,
                  ),
                  MenuItemWidget(
                    iconData: Icons.date_range_sharp,
                    title: 'Upcoming',
                    itemFilterValue: filterUpcoming,
                    badgeCount: ref.watch(itemsCount(filterUpcoming)),
                    badgeColor: badgeColor,
                  ),
                  MenuItemWidget(
                    iconData: Icons.update_sharp,
                    title: 'Someday',
                    itemFilterValue: filterSomeday,
                    badgeCount: ref.watch(itemsCount(filterSomeday)),
                    badgeColor: badgeColor,
                  ),
                  MenuItemWidget(
                    iconData: Icons.event_busy_sharp,
                    title: 'Overdue',
                    itemFilterValue: filterOverdue,
                    badgeCount: ref.watch(itemsCount(filterOverdue)),
                    badgeColor: badgeColor,
                  ),

                  if (projects.isNotEmpty) const MenuHeaderWidget(
                    'Projects',
                    fontSize: 11,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                    fontSize: 11,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (archiveAvailable) MenuItemWidget(
                    title: 'Archive completed',
                    iconData: Icons.archive_outlined,
                    onTap: () => ref.read(itemsNotifierProvider.notifier).archiveCompleted(),
                    color: Theme.of(context).disabledColor,
                  ),
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
      ),
    );
  }
}