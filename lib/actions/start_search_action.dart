import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:txdx/providers/items/selected_item_provider.dart';
import 'package:txdx/utils/focus.dart';

import '../config/shortcuts.dart';
import '../providers/items/scoped_item_notifier.dart';

class StartSearchAction extends Action<SearchIntent> {

  final WidgetRef ref;

  StartSearchAction(this.ref);

  @override
  Object? invoke(SearchIntent intent) {
    ref.read(searchTextProvider.state).state = '';
    ref.read(isSearchingProvider.state).state = true;

    ref.read(selectedItemIdStateProvider.state).state = null;

    searchFocusNode.requestFocus();

    return null;
  }
}