
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:txdx/providers/contexts_provider.dart';
import 'package:txdx/providers/projects_provider.dart';
import 'package:txdx/providers/scoped_item_notifier.dart';

import 'menu_header_widget.dart';
import 'menu_item_widget.dart';

class SidebarWidget extends ConsumerWidget {
  const SidebarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contexts = ref.watch(contextsProvider);
    final projects = ref.watch(projectsProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const MenuHeaderWidget('TxDx'),
              MenuItemWidget(
                icon: const FaIcon(FontAwesomeIcons.th, size: 16),
                title: 'All',
                onTap: () => ref.read(itemFilter.state).state = null,
              ),
              MenuItemWidget(
                icon: const FaIcon(FontAwesomeIcons.calendarDay, size: 16),
                title: 'Today',
                onTap: () => ref.read(itemFilter.state).state = "due:today",
              ),
              MenuItemWidget(
                icon: const FaIcon(FontAwesomeIcons.calendarWeek, size: 16),
                title: 'Next 7 days',
                onTap: () => ref.read(itemFilter.state).state = "due:in7days",
              ),
              Divider(),
              MenuItemWidget(
                icon: const FaIcon(FontAwesomeIcons.angry, size: 16),
                title: 'Overdue',
                onTap: () => ref.read(itemFilter.state).state = "due:overdue",
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
                      indicatorColor: Colors.teal,
                      onTap: () {
                        ref.read(itemFilter.state).state = context;
                      },
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
                    indicatorColor: Colors.orange,
                    onTap: () {
                      ref.read(itemFilter.state).state = project;
                    },
                  )
                ).toList(),
              ),
            ]
          ),
          ListView(
            shrinkWrap: true,
            controller: ScrollController(),
            children: [
              MenuItemWidget(
                onTap: () => Navigator.pushNamed(context, '/settings'),
                title: 'Settings',
                icon: const FaIcon(FontAwesomeIcons.cog, size: 16),
              ),
            ]
          )
        ]
      ),
    );
  }
}