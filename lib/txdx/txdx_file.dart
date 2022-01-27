import 'dart:io';

import 'txdx_item.dart';

class TxDxFile {

  static Future<void> saveToFile(String filename, List<TxDxItem> items) async {
    final contents = items.map((e) => e.toString()).join('\n');
    File file = await _getFile(filename);
    await file.writeAsString(contents, flush: true);
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

}