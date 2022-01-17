class TxDxItem {
  String text;

  RegExp contextsRegExp = RegExp(r'(?:\s+|^)@[^\s]+');
  RegExp projectsRegExp = RegExp(r'(?:\s+|^)\+[^\s]+');
  RegExp priorityRegExp = RegExp(r'(?:^|\s+)\(([A-Za-z])\)\s+');
  RegExp createdOnRegExp = RegExp(r'(?:^|-\d{2}\s|\)\s)(\d{4}-\d{2}-\d{2})\s');
  RegExp completedOnRegExp = RegExp(r'^x\s+(\d{4}-\d{2}-\d{2})\s+');
  RegExp completedRegExp = RegExp(r'^x\s+');
  RegExp dueOnRegExp = RegExp(r'(?:due:)(\d{4}-\d{2}-\d{2})(?:\s+|$)', caseSensitive: false);
  RegExp tagsRegExp = RegExp(r'([a-z]+):([A-Za-z0-9_-]+)', caseSensitive: false);

  late bool completed;
  late String description;
  late String? priority;
  late DateTime? createdOn;
  late DateTime? completedOn;
  late DateTime? dueOn;
  late Iterable<String> contexts;
  late Iterable<String> projects;
  late Map<String, String> tags;

  TxDxItem(this.text) {
    description = replaceEverything(text);

    tags = getMatchedPairs(tagsRegExp, text);

    contexts = getMatches(contextsRegExp, text);
    projects = getMatches(projectsRegExp, text);
    priority = getMatch(priorityRegExp, text);
    createdOn = getDate(createdOnRegExp, text);
    completedOn = getDate(completedOnRegExp, text);
    dueOn = getDate(dueOnRegExp, text);
    completed = getMatch(completedRegExp, text) != null;
  }

  void setCompleted(bool value) {
    completed = value;
  }

  String replaceEverything(String text) {
    return text.replaceAll(completedOnRegExp, '')
        .replaceAll(completedRegExp, '')
        .replaceAll(priorityRegExp, '')
        .replaceAll(contextsRegExp, '')
        .replaceAll(projectsRegExp, '')
        .replaceAll(dueOnRegExp, '')
        .replaceAll(tagsRegExp, '')
        .replaceAll(createdOnRegExp, '')
        .trim();
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
    RegExpMatch? match = regExp.firstMatch(text);
    if (match == null) return null;

    String? matchedDate = match.group(1);
    if (matchedDate == null) return null;

    return DateTime.tryParse(matchedDate.trim());
  }

  Map<String, String> getMatchedPairs(RegExp regExp, String text) {
    Iterable<RegExpMatch> matches = regExp.allMatches(text);
    Map<String, String> results = <String, String>{};

    matches.forEach((match) {
      String pair = match.group(0).toString().trim();
      List<String> keyVal = pair.split(':');
      results[keyVal[0]] = keyVal[1];
    });

    return results;
  }
}

class TxDxList {
  List<TxDxItem> items = <TxDxItem>[];

  String filename;

  TxDxList(this.filename) {
    items.add(TxDxItem('(A) 2022-01-12 Do something +project @context'));
    items.add(TxDxItem('(C) 2022-01-12 Do something later +project @context due:2022-12-31'));
    items.add(TxDxItem('x 2022-01-13 2022-01-10 Did something +project @context pri:B'));
  }
}