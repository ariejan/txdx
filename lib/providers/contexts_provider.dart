
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:txdx/providers/item_notifier_provider.dart';

final contextsProvider = Provider<List<String>>((ref) {
  final itemsNotifier = ref.watch(itemsNotifierProvider.notifier);

  final contextsSet = Set<String>();
  itemsNotifier.getItems().forEach((item) => contextsSet.addAll(item.contexts));

  return contextsSet.toList();
});