
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:txdx/providers/contexts_provider.dart';
import 'package:txdx/providers/projects_provider.dart';

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
              const MenuItemWidget(
                icon: FaIcon(FontAwesomeIcons.th, size: 16),
                title: 'All',
              ),
              const MenuItemWidget(
                icon: FaIcon(FontAwesomeIcons.calendarDay, size: 16),
                title: 'Today',
              ),
              const MenuHeaderWidget(
                'Contexts',
                fontSize: 11,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              ),
              contexts.when(
                data: (contextStrings) {
                  return Column(
                    children: contextStrings.map((context) =>
                        MenuItemWidget(
                          title: context,
                          indicatorColor: Colors.teal,
                        )
                    ).toList(),
                  );
                },
                error: (err, _) => Text(err.toString()),
                loading: () => const CircularProgressIndicator(),
              ),
              const MenuHeaderWidget(
                'Projects',
                fontSize: 11,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              ),
              projects.when(
                  data: (projectStrings) {
                    return Column(
                      children: projectStrings.map((project) =>
                        MenuItemWidget(
                          title: project,
                          indicatorColor: Colors.orange,
                        )
                      ).toList(),
                    );
                  },
                  error: (err, _) => Text(err.toString()),
                  loading: () => const CircularProgressIndicator(),
              ),
            ]
          ),
          ListView(
            shrinkWrap: true,
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