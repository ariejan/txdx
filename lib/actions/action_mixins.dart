import '../widgets/desktop/items/items_list_view.dart';

mixin ItemListManager {
  void jumpToIndex(int index) {
    ItemsListView.controller.scrollTo(
      index: index,
      duration: const Duration(microseconds: 250),
      alignment: 0.33,
    );
  }
}