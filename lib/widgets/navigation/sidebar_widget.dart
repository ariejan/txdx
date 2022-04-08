
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
                      const MenuItemWidget(
                        icon: FaIcon(FontAwesomeIcons.tableCells, size: 16),
                        title: 'All',
                        itemFilterValue: filterAll,
                      ),
                      MenuItemWidget(
                        icon: const FaIcon(FontAwesomeIcons.calendarDay, size: 16),
                        title: 'Today',
                        itemFilterValue: filterToday,
                        badgeCount: ref.watch(itemsCountDueToday),
                      ),
                      const MenuItemWidget(
                        icon: FaIcon(FontAwesomeIcons.calendarWeek, size: 16),
                        title: 'Upcoming',
                        itemFilterValue: filterUpcoming,
                      ),
                      const MenuItemWidget(
                        icon: FaIcon(FontAwesomeIcons.calendarDays, size: 16),
                        title: 'Someday',
                        itemFilterValue: filterSomeday,
                      ),
                      const MenuItemWidget(
                        icon: FaIcon(FontAwesomeIcons.calendarXmark, size: 16),
                        title: 'Overdue',
                        itemFilterValue: filterOverdue,
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