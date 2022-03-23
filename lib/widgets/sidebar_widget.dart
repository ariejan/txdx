
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:txdx/providers/contexts_provider.dart';
import 'package:txdx/providers/item_notifier_provider.dart';
import 'package:txdx/providers/projects_provider.dart';

import '../providers/file_notifier_provider.dart';
import '../theme/colors.dart';
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const MenuHeaderWidget('TxDx'),
              const MenuItemWidget(
                icon: FaIcon(FontAwesomeIcons.th, size: 16),
                title: 'All',
                itemFilterValue: "all",
              ),
              const MenuItemWidget(
                icon: FaIcon(FontAwesomeIcons.calendarDay, size: 16),
                title: 'Today',
                itemFilterValue: "due:today",
              ),
              const MenuItemWidget(
                icon: FaIcon(FontAwesomeIcons.calendarWeek, size: 16),
                title: 'Next 7 days',
                itemFilterValue: "due:in7days",
              ),
              const Divider(),
              const MenuItemWidget(
                icon: FaIcon(FontAwesomeIcons.angry, size: 16),
                title: 'Overdue',
                itemFilterValue: "due:overdue",
              ),
              const MenuHeaderWidget(
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

              const MenuHeaderWidget(
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
          ListView(
            shrinkWrap: true,
            controller: ScrollController(),
            children: [
              if (archiveAvailable) MenuItemWidget(
                title: 'Archive completed',
                color: Theme.of(context).disabledColor,
                icon: FaIcon(
                  FontAwesomeIcons.archive,
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
                  FontAwesomeIcons.cog,
                  size: 16,
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ]
          )
        ]
      ),
    );
  }
}