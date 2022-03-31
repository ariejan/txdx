import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:txdx/providers/settings/settings_provider.dart';
import 'package:txdx/txdx/txdx_file.dart';
import 'package:txdx/txdx/txdx_item.dart';

import '../../config/settings.dart';

final itemsNotifierProvider =
  StateNotifierProvider<ItemNotifier, List<TxDxItem>>((ref) => ItemNotifier(ref));

class ItemNotifier extends StateNotifier<List<TxDxItem>> {
  ItemNotifier(this.ref) : super(const []) {
    _initialize();
  }

  final StateNotifierProviderRef ref;
  late final String? todoFilename;
  late final String? archiveFilename;

  Future<void> _initialize() async {
    todoFilename = ref.watch(settingsProvider).getString(settingsFileTodoTxt);
    archiveFilename = ref.watch(settingsProvider).getString(settingsFileArchiveTxt);

    if (todoFilename != null && todoFilename != '') {
      loadItemsFromDisk();
    } else {
      state = [];
    }
  }

  void loadItemsFromDisk() {
    TxDxFile.openFromFile(todoFilename!).then((theItems) {
      state = theItems;
    }).catchError((e) {
      state = [];
      Get.dialog(
          AlertDialog(
            title: const Text("Cannot open your TODO.txt file!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text('Oh noes! It seems we cannot open that file for you.'),
                  Text('$todoFilename'),
                  const Text('Please select a file from settings.')
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Get.back();
                },
              )
            ],
          ),
          barrierDismissible: false);
    });
  }

  List<TxDxItem> getItems() {
    return state;
  }

  String? createItem(String? input) {
    final items = getItems();

    if (input != null && input.isNotEmpty) {
      var theItem = TxDxItem.fromText(input);
      if (theItem.createdOn == null) {
        theItem = theItem.copyWith(createdOn: DateTime.now());
      }

      final theItems = [
        ...items,
        theItem,
      ];
      _setState(theItems);

      return theItem.id;
    }

    return null;
  }

  void deleteItem(String id) {
    final items = getItems().toList();
    final itemIdx = items.indexWhere((item) => item.id == id);
    if (itemIdx >= 0) {
      items.removeAt(itemIdx);
      _setState(items);
    }
  }

  TxDxItem? getItem(String? id) {
    if (id == null) {
      return null;
    }
    final items = getItems();
    final itemIdx = items.indexWhere((item) => item.id == id);
    if (itemIdx >= 0) {
      final theItem = items.elementAt(itemIdx);
      return theItem;
    } else {
      return null;
    }
  }

  void updateItem(String id, String text) {
    final items = getItems().toList();
    final itemIdx = items.indexWhere((item) => item.id == id);
    if (itemIdx >= 0) {
      final updatedItem = TxDxItem.fromTextWithId(id, text);
      items.replaceRange(itemIdx, itemIdx + 1, [updatedItem]);
      _setState(items);
    }
  }

  Future<void> prioDown(String id) async {
    final items = getItems().toList();
    final itemIdx = items.indexWhere((item) => item.id == id);
    if (itemIdx >= 0) {
      final theItem = items.elementAt(itemIdx);
      items.replaceRange(itemIdx, itemIdx + 1, [theItem.prioDown()]);
      _setState(items);
    }
  }

  Future<void> prioUp(String id) async {
    final items = getItems().toList();
    final itemIdx = items.indexWhere((item) => item.id == id);
    if (itemIdx >= 0) {
      final theItem = items.elementAt(itemIdx);
      items.replaceRange(itemIdx, itemIdx + 1, [theItem.prioUp()]);
      _setState(items);
    }
  }


  Future<void> toggleComplete(String id) async {
    final items = getItems().toList();
    final itemIdx = items.indexWhere((item) => item.id == id);
    if (itemIdx >= 0) {
      final theItem = items.elementAt(itemIdx);
      items.replaceRange(itemIdx, itemIdx + 1, [theItem.toggleComplete()]);
      _setState(items);
    }
  }

  Future<void> archiveCompleted() async {
    final items = getItems().toList();
    final completedItems = items.where((item) => item.completed).toList();

    if (archiveFilename != null && File(archiveFilename!).existsSync()) {
      TxDxFile.appendToFile(archiveFilename!, completedItems);

      items.removeWhere((item) => item.completed);
      _setState(items);
    }
  }

  void _setState(List<TxDxItem> value) {
    state = value;

    if (todoFilename != null && todoFilename != '') {
      TxDxFile.saveToFile(todoFilename!, value);
    }
  }

  Future<void> moveToToday(String id) async {
    final items = getItems().toList();
    final itemIdx = items.indexWhere((item) => item.id == id);
    if (itemIdx >= 0) {
      final theItem = items.elementAt(itemIdx);
      items.replaceRange(itemIdx, itemIdx + 1, [theItem.moveToToday()]);
      _setState(items);
    }
  }

  Future<void> postpone(String id, int days) async {
    final items = getItems().toList();
    final itemIdx = items.indexWhere((item) => item.id == id);
    if (itemIdx >= 0) {
      final theItem = items.elementAt(itemIdx);
      items.replaceRange(itemIdx, itemIdx + 1, [theItem.postpone(days)]);
      _setState(items);
    }
  }

  Future<void> setPriority(String id, String? priority) async {
    final items = getItems().toList();
    final itemIdx = items.indexWhere((item) => item.id == id);
    if (itemIdx >= 0) {
      final theItem = items.elementAt(itemIdx);
      items.replaceRange(itemIdx, itemIdx + 1, [theItem.setPriority(priority)]);
      _setState(items);
    }
  }}