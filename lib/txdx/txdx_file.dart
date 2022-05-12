import 'dart:io';

import 'txdx_item.dart';

class TxDxFile {

  static Future<void> saveToFile(File file, List<TxDxItem> items, { bool sorted = false }) async {
    items = items.where((item) => !item.isNew).toList();

    var itemLines = items.map((e) => e.toString()).toList();

    if (sorted) {
      itemLines.sort();
    }

    final contents = itemLines.join('\n');
    await file.writeAsString('$contents\n', flush: true);
  }

  static Future<void> appendToFile(File file, List<TxDxItem> items) async {
    final contents = items.map((e) => e.toString()).join('\n');
    await file.writeAsString('$contents\n', flush: true, mode: FileMode.writeOnlyAppend);
  }

  static Future<List<TxDxItem>> openFromFile(File file) async {
    List<String> lines = await file.readAsLines();
    final theList = <TxDxItem>[];

    for (var line in lines) {
      theList.add(TxDxItem.fromText(line));
    }

    return theList;
  }

  // Returns true if data in the file and the provided list are the same
  static Future<bool> compareFileToDataEquality(File file, List<TxDxItem> items) async {
    items = items.where((item) => !item.isNew).toList();
    final fileItems = await openFromFile(file);

    if (fileItems.length != items.length) return false;

    for (final fileItem in fileItems) {
      if (!items.contains(fileItem)) return false;
    }

    return true;
  }
}