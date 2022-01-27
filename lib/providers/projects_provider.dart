
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/item_notifier_provider.dart';

final projectsProvider = Provider<List<String>>((ref) {
  final itemsNotifier = ref.watch(itemsNotifierProvider.notifier);

  final projectsSet = Set<String>();
  itemsNotifier.getItems().forEach((item) => projectsSet.addAll(item.projects));

  return projectsSet.toList();
});