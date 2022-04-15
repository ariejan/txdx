
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        ? TxDxColors.darkBadge
        : TxDxColors.lightBadge2;

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const MenuHeaderWidget('TxDx'),
                      MenuItemWidget(
                        icon: const FaIcon(FontAwesomeIcons.tableCells, size: 16),
                        title: 'All',
                        itemFilterValue: filterAll,
                        badgeCount: ref.watch(itemsCount(filterAll)),
                        badgeColor: badgeColor,
                      ),
                      MenuItemWidget(
                        icon: const FaIcon(FontAwesomeIcons.calendarDay, size: 16),
                        title: 'Today',
                        itemFilterValue: filterToday,
                        badgeCount: ref.watch(itemsCount(filterToday)),
                        badgeColor: badgeColor,
                      ),
                      MenuItemWidget(
                        icon: const FaIcon(FontAwesomeIcons.calendarWeek, size: 16),
                        title: 'Upcoming',
                        itemFilterValue: filterUpcoming,
                        badgeCount: ref.watch(itemsCount(filterUpcoming)),
                        badgeColor: badgeColor,
                      ),
                      MenuItemWidget(
                        icon: const FaIcon(FontAwesomeIcons.calendarDays, size: 16),
                        title: 'Someday',
                        itemFilterValue: filterSomeday,
                        badgeCount: ref.watch(itemsCount(filterSomeday)),
                        badgeColor: badgeColor,
                      ),
                      MenuItemWidget(
                        icon: const FaIcon(FontAwesomeIcons.calendarXmark, size: 16),
                        title: 'Overdue',
                        itemFilterValue: filterOverdue,
                        badgeCount: ref.watch(itemsCount(filterOverdue)),
                        badgeColor: badgeColor,
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
                              indicatorColor: TxDxColors.contexts,
                              itemFilterValue: context,
                              badgeCount: ref.watch(itemsCount(context)),
                              badgeColor: badgeColor,
                            )
                        ).toList(),
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
                            indicatorColor: TxDxColors.projects,
                            itemFilterValue: project,
                            badgeCount: ref.watch(itemsCount(project)),
                            badgeColor: badgeColor,
                          )
                        ).toList(),
                      ),
                    ]
                  ),
                ]
              ),
            ),
          ),
          SizedBox(
            child: ListView(
                shrinkWrap: true,
                controller: ScrollController(),
                children: [
                  if (archiveAvailable) MenuItemWidget(
                    title: 'Archive completed',
                    color: Theme.of(context).disabledColor,
                    icon: FaIcon(
                      FontAwesomeIcons.boxArchive,
                      size: 16,
                      color: Theme.of(context).disabledColor,
                    ),
                    onTap: () => ref.read(itemsNotifierProvider.notifier).archiveCompleted(),
                  ),
                  MenuItemWidget(
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                    color: Theme.of(context).disabledColor,
                    title: 'Settings',
                    icon: FaIcon(
                      FontAwesomeIcons.gear,
                      size: 16,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
}