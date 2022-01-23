import 'dart:io';

import 'txdx.dart';

class TxDxFile {

  static Future<List<TxDxItem>> openFromFile(String filename) async {
    List<String> lines = await _readLines(filename);
    final theList = <TxDxItem>[];

    for (var line in lines) {
      theList.add(TxDxItem.fromText(line));
    }

    return theList;
  }

  static Future<List<String>> _readLines(String filename) async {
    File file = await _openFile(filename);
    List<String> lines = await file.readAsLines();
    return lines;
  }

  static Future<File> _openFile(String filename) async {
    return File(filename);
  }

}