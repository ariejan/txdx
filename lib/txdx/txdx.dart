class TxDxItem {
  String text;

  RegExp contextsRegexp = RegExp(r'(?:\s+|^)@[^\s]+');
  RegExp projectsRegexp = RegExp(r'(?:\s+|^)\+[^\s]+');
  RegExp priorityRegexp = RegExp(r'(?:^|\s+)\(([A-Za-z])\)\s+');
  RegExp createdOnRegExp = RegExp(r'(?:^|-\d{2}\s|\)\s)(\d{4}-\d{2}-\d{2})\s');

  late bool completed;
  late String description;
  late String? priority;
  late DateTime? createdOn;
  late Iterable<String> contexts;
  late Iterable<String> projects;

  TxDxItem(this.text) {
    completed = false;
    description = '';

    contexts = getMatches(contextsRegexp, text);
    projects = getMatches(projectsRegexp, text);
    priority = getMatch(priorityRegexp, text);
    createdOn = getDate(createdOnRegExp, text);
  }

  void setCompleted(bool value) {
    completed = value;
  }

  Iterable<String> getMatches(RegExp regExp, String text) {
    Iterable<RegExpMatch> matches = regExp.allMatches(text);
    return matches.map((e) => e.group(0).toString().trim()).toList();
  }

  String? getMatch(RegExp regExp, String text) {
    String? match = regExp.stringMatch(text);
    return (match != null) ? match[1] : null;
  }

  DateTime? getDate(RegExp regExp, String text) {
    String? match = regExp.stringMatch(text);
    if (match == null) return null;

    String stringDate = match.trim();
    DateTime? result = DateTime.tryParse(stringDate);
    return result;
  }
}

class TxDxContext {
  List<TxDxItem> items = <TxDxItem>[];

  String filename;

  TxDxContext(this.filename) {
    items.add(TxDxItem('(A) 2022-01-12 Do something +project @context'));
    items.add(TxDxItem('(C) 2022-01-12 Do something later +project @context due:2022-12-31'));
    items.add(TxDxItem('x 2022-01-13 2022-01-10 Did something +project @context pri:B'));
  }
}