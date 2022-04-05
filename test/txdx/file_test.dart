import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:txdx/txdx/txdx_file.dart';
import 'package:txdx/txdx/txdx_item.dart';

void main() {
  Future<void> _expectNumberOfEntriesInFile(File file, int expectedNumberOfItems) async {
    final items = await TxDxFile.openFromFile(file);
    expect(items, hasLength(expectedNumberOfItems));
  }

  group('test example.txt reading/parsing', () {
    test('parse the file', () {
      _expectNumberOfEntriesInFile(File(Directory.current.path + '/test/examples/example.txt'), 3);
    });
  });

  group('test writing to file', () {
    test('write to file', () {
      final items = [
        TxDxItem.fromText('(A) 2022-01-25 Test writing files +txdx @testing due:2022-01-28'),
        TxDxItem.fromText('x 2022-01-25 2022-01-18 Buy flowers @shopping pri:B'),
      ];

      final tmpFilename = Directory.current.path + '/test/examples/write-test.txt';
      final tmpFile = File(tmpFilename);

      TxDxFile.saveToFile(tmpFile, items).then((_) {
        _expectNumberOfEntriesInFile(tmpFile, 2).then((_) {
          tmpFile.deleteSync();
        });
      });
    });
  });

  group('test appending to file', () {
    test('append to file', () async {
      final items = [
        TxDxItem.fromText('(A) 2022-01-25 Test writing files +txdx @testing due:2022-01-28'),
        TxDxItem.fromText('x 2022-01-25 2022-01-18 Buy flowers @shopping pri:B'),
      ];
      final newItems = [
        TxDxItem.fromText('x 2022-01-25 2022-01-18 Do another thing'),
      ];

      final tmpFilename = Directory.current.path + '/test/examples/append-test.txt';
      final tmpFile = File(tmpFilename);

      TxDxFile.saveToFile(tmpFile, items).then((_) {
        _expectNumberOfEntriesInFile(tmpFile, 2).then((_) {
          TxDxFile.appendToFile(tmpFile, newItems).then((_) {
            _expectNumberOfEntriesInFile(tmpFile, 3).then((_) {
              tmpFile.deleteSync();
            });
          });
        });
      });
    });
  });

  group('test file for equality', () {
    test('reports equal data files', () async {
      final items = [
        TxDxItem.fromText('(A) 2022-01-25 Test writing files +txdx @testing due:2022-01-28'),
        TxDxItem.fromText('x 2022-01-25 2022-01-18 Buy flowers @shopping pri:B'),
      ];
      final tmpFilename = Directory.current.path + '/test/examples/equality-test.txt';
      final tmpFile = File(tmpFilename);
      await TxDxFile.saveToFile(tmpFile, items);

      final reorderedItems = [
        TxDxItem.fromText('x 2022-01-25 2022-01-18 Buy flowers @shopping pri:B'),
        TxDxItem.fromText('(A) 2022-01-25 Test writing files +txdx @testing due:2022-01-28'),
      ];

      final changedItems = [
        TxDxItem.fromText('x 2022-01-25 2022-01-18 Buy flowers @shopping pri:B'),
        TxDxItem.fromText('x 2022-03-31 2022-01-25 Test writing files +txdx @testing due:2022-01-28'),
      ];

      final sameItemsEquality = await TxDxFile.compareFileToDataEquality(tmpFile, items);
      final reorderedItemsEquality = await TxDxFile.compareFileToDataEquality(tmpFile, reorderedItems);
      final changedItemsEquality = await TxDxFile.compareFileToDataEquality(tmpFile, changedItems);

      expect(sameItemsEquality, isTrue);
      expect(reorderedItemsEquality, isTrue);
      expect(changedItemsEquality, isFalse);
    });
  });
}