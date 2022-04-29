import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/config/colors.dart';
import 'package:txdx/config/filters.dart';
import 'package:txdx/config/icons.dart';
import 'package:txdx/providers/items/scoped_item_notifier.dart';

import '../../../providers/files/file_notifier_provider.dart';
import '../../../providers/items/contexts_provider.dart';
import '../../../providers/items/item_notifier_provider.dart';
import '../../../providers/items/projects_provider.dart';

class TxDxDrawer extends ConsumerStatefulWidget {
  const TxDxDrawer({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TxDxDrawerState();
}

class _TxDxDrawerState extends ConsumerState<TxDxDrawer> {
  @override
  Widget build(BuildContext context) {
    final contexts = ref.watch(contextsProvider);
    final projects = ref.watch(projectsProvider);
    final archiveAvailable = ref.watch(archivingAvailableProvider);


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: TxDxColors.txdxGradient(),
            ),
            child: Text(
              'TxDx',
              style: TextStyle(
                color: Theme.of(context).appBarTheme.foregroundColor,
                fontWeight: FontWeight.w900,
                fontSize: 48,
              ),
            ),
          ),
          ListTile(
            title: const Text('Everything'),
            leading: Icon(txdxIconData[filterAll]),
            onTap: () {
              ref.read(itemFilter.state).state = filterAll;
              ref.read(currentlyAccessibleFileProvider.state).state = AccessibleFile.todo;
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Today'),
            leading: Icon(txdxIconData[filterToday]),
            onTap: () {
              ref.read(itemFilter.state).state = filterToday;
              ref.read(currentlyAccessibleFileProvider.state).state = AccessibleFile.todo;
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Upcoming'),
            leading: Icon(txdxIconData[filterUpcoming]),
            onTap: () {
              ref.read(itemFilter.state).state = filterUpcoming;
              ref.read(currentlyAccessibleFileProvider.state).state = AccessibleFile.todo;
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Someday'),
            leading: Icon(txdxIconData[filterSomeday]),
            onTap: () {
              ref.read(itemFilter.state).state = filterSomeday;
              ref.read(currentlyAccessibleFileProvider.state).state = AccessibleFile.todo;
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Overdue'),
            leading: Icon(txdxIconData[filterOverdue]),
            onTap: () {
              ref.read(itemFilter.state).state = filterOverdue;
              ref.read(currentlyAccessibleFileProvider.state).state = AccessibleFile.todo;
              Navigator.pop(context);
            },
          ),

          if (archiveAvailable) ListTile(
            title: const Text('Archive'),
            leading: const Icon(Icons.archive_outlined),
            onTap: () {
              ref.read(currentlyAccessibleFileProvider.state).state = AccessibleFile.archive;
              Navigator.pop(context);
            },
          ),

          ...projects.map((project) => ListTile(
            leading: Icon(txdxIconData['project'], color: TxDxColors.projects),
            title: Text(project),
            onTap: () {
              ref.read(itemFilter.state).state = project;
              ref.read(currentlyAccessibleFileProvider.state).state = AccessibleFile.todo;
              Navigator.pop(context);
            },
          )),

          ...contexts.map((contextName) => ListTile(
            leading: Icon(txdxIconData['context'], color: TxDxColors.contexts),
            title: Text(contextName),
            onTap: () {
              ref.read(itemFilter.state).state = contextName;
              ref.read(currentlyAccessibleFileProvider.state).state = AccessibleFile.todo;
              Navigator.pop(context);
            },
          )),
        ]
      )
    );
  }

}