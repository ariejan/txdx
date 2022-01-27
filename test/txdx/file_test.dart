import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:txdx/txdx/txdx_file.dart';
import 'package:txdx/txdx/txdx_item.dart';

void main() {
  void _expectNumberOfEntriesInFile(String filename, int expectedNumberOfItems) {
    TxDxFile.openFromFile(filename).then((items) {
      expect(items, hasLength(expectedNumberOfItems));
    });
  }

  group('test example.txt reading/parsing', () {
    test('parse the file', () {
      _expectNumberOfEntriesInFile(Directory.current.path + '/test/examples/example.txt', 3);
    });
  });

  group('test writing to file', () {
    test('write to file', () {
      final items = [
        TxDxItem.fromText('(A) 2022-01-25 Test writing files +txdx @testing due:2022-01-28'),
        TxDxItem.fromText('x 2022-01-25 2022-01-18 Buy flowers @shopping pri:B'),
      ];

      final tmpFilename = Directory.current.path + '/test/examples/write-test.txt';

      TxDxFile.saveToFile(tmpFilename, items).then((_) {
        _expectNumberOfEntriesInFile(tmpFilename, 2);

        final file = File(tmpFilename);
        file.deleteSync();
      });
    });
  });


}