import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/config/colors.dart';
import 'package:txdx/config/filters.dart';
import 'package:txdx/config/icons.dart';
import 'package:txdx/providers/items/scoped_item_notifier.dart';

class TxDxDrawer extends ConsumerStatefulWidget {
  const TxDxDrawer({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TxDxDrawerState();
}

class _TxDxDrawerState extends ConsumerState<TxDxDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                ? TxDxColors.lightSelection
                : TxDxColors.darkSelection,
            ),
            child: const Text(
              'TxDx',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 32,
              ),
            ),
          ),
          ListTile(
            title: const Text('Everything'),
            leading: Icon(txdxIconData[filterAll]),
            onTap: () {
              ref.read(itemFilter.state).state = filterAll;
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Today'),
            leading: Icon(txdxIconData[filterToday]),
            onTap: () {
              ref.read(itemFilter.state).state = filterToday;
              Navigator.pop(context);
            },
          ),
        ]
      )
    );
  }

}