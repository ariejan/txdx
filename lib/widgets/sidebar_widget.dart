
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'app_title_widget.dart';

class SidebarWidget extends ConsumerWidget {
  const SidebarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.indigo.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const AppTitleWidget(),
              ListView(
                shrinkWrap: true,
                children: const [
                  ListTile(
                    // onTap: () => Navigator.pushNamed(context, '/settings'),
                    title: Text('All', overflow: TextOverflow.clip),
                    leading: FaIcon(FontAwesomeIcons.th),
                  ),
                  ListTile(
                    // onTap: () => Navigator.pushNamed(context, '/settings'),
                    title: Text('Today', overflow: TextOverflow.clip),
                    leading: FaIcon(FontAwesomeIcons.calendarDay),
                  ),
                ],
              ),
            ]
          ),
          ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                onTap: () => Navigator.pushNamed(context, '/settings'),
                title: const Text('Settings', overflow: TextOverflow.clip),
                leading: const FaIcon(FontAwesomeIcons.cog),
              ),
            ]
          )
        ]
      ),
    );
  }

}