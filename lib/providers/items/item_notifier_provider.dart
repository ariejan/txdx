import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:txdx/providers/files/file_notifier_provider.dart';
import 'package:txdx/providers/settings/settings_provider.dart';
import 'package:txdx/txdx/txdx_file.dart';
import 'package:txdx/txdx/txdx_item.dart';

import '../../config/settings.dart';

final itemsNotifierProvider = StateNotifierProvider<ItemNotifier, List<TxDxItem>>((ref) {
  final settings = ref.watch(settingsProvider);

  final todoFilename = settings.getString(settingsFileTodoTxt);
  final todoFile = ref.watch(todoFileProvider).maybeWhen(
      data: (file) => file,
      orElse: () => null);

  final archiveFilename = settings.getString(settingsFileArchiveTxt);
  final archiveFile = ref.watch(archiveFileProvider).maybeWhen(
      data: (file) => file,
      orElse: () => null);

  return ItemNotifier(ref, todoFile, archiveFile, todoFilename, archiveFilename);
});

class ItemNotifier extends StateNotifier<List<TxDxItem>> {
  ItemNotifier(this.ref, this.todoFile, this.archiveFile, this.todoFilename, this.archiveFilename) : super(const []) {
    _initialize();
  }

  final StateNotifierProviderRef ref;
  final File? todoFile;
  final File? archiveFile;

  final String? todoFilename;
  final String? archiveFilename;

  Future<void> _initialize() async {
    if (todoFile != null) {
      loadItemsFromDisk();
    } else {
      state = [];
    }
  }

  void loadItemsFromDisk() async {
    TxDxFile.openFromFile(todoFile!).then((theItems) {
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

    if (archiveFile != null) {
      TxDxFile.appendToFile(archiveFile!, completedItems);

      items.removeWhere((item) => item.completed);
      _setState(items);
    }
  }

  void _setState(List<TxDxItem> value) {
    state = value;
    final sorted = ref.read(settingsProvider).getBool(settingsFileSaveOrdered);

    if (todoFile != null) {
      TxDxFile.saveToFile(todoFile!, value, sorted: sorted);
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