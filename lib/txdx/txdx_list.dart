import 'txdx_item.dart';

class TxDxList {
  List<TxDxItem> items = <TxDxItem>[];

  String filename;

  TxDxList(this.filename) {
    items.add(TxDxItem('(A) 2022-01-12 Do something with priority +project @context'));
    items.add(TxDxItem('(C) 2022-01-12 Do something later +project @context due:2022-12-31'));
    items.add(TxDxItem('x 2022-01-13 2022-01-10 Did something +project @context pri:B'));
  }
}