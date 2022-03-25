import 'dart:io';

import 'txdx_item.dart';

class TxDxFile {

  static Future<void> saveToFile(String filename, List<TxDxItem> items) async {
    final contents = items.map((e) => e.toString()).join('\n');
    File file = await _getFile(filename);
    await file.writeAsString(contents, flush: true);
  }

  static Future<void> appendToFile(String filename, List<TxDxItem> items) async {
    final contents = items.map((e) => e.toString()).join('\n');
    File file = await _getFile(filename);
    await file.writeAsString(contents + '\n', flush: true, mode: FileMode.writeOnlyAppend);
  }

  static Future<List<TxDxItem>> openFromFile(String filename) async {
    List<String> lines = await _readLines(filename);
    final theList = <TxDxItem>[];

    for (var line in lines) {
      theList.add(TxDxItem.fromText(line));
    }

    return theList;
  }

  static Future<List<String>> _readLines(String filename) async {
    File file = await _getFile(filename);
    List<String> lines = await file.readAsLines();
    return lines;
  }

  static Future<File> _getFile(String filename) async {
    return File(filename);
  }

  // Returns true if data in the file and the provided list are the same
  static Future<bool> compareFileToDataEquality(String filename, List<TxDxItem> items) async {
    final fileItems = await openFromFile(filename);

    if (fileItems.length != items.length) {
      return false;
    }

    for (final fileItem in fileItems) {
      // FIXME: Check equality based on String version to avoid IDs
      if (!items.contains(fileItem)) {
        return false;
      }
    }

    return true;
  }
}