
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/items/item_notifier_provider.dart';

final projectsProvider = Provider<List<String>>((ref)  {
  final items = ref.watch(todoItemsProvider);
  final theSet = <String>{};
  for (var item in items) {
    theSet.addAll(item.projects);
  }

  final theList = theSet.toList();
  theList.sort();
  return theList;
});