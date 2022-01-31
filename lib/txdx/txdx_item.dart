import 'package:jiffy/jiffy.dart';
import 'package:uuid/uuid.dart';

import 'txdx_syntax.dart';

const _uuid = Uuid();

class TxDxItem {

  late String id;
  final bool completed;
  final String description;
  final String? priority;
  final DateTime? createdOn;
  final DateTime? completedOn;
  final DateTime? dueOn;
  final Iterable<String> contexts;
  final Iterable<String> projects;
  final Map<String, String> tags;

  TxDxItem({
    this.completed = false,
    this.description = '',
    this.priority,
    this.createdOn,
    this.completedOn,
    this.dueOn,
    this.contexts = const <String>[],
    this.projects = const <String>[],
    this.tags = const <String, String>{},
  }) : id = _uuid.v4();


  /// Creates a TxDxItem from a Todo.txt formatted `text`.
  static TxDxItem fromText(text) {
    return TxDxItem(
      completed: TxDxSyntax.getCompleted(text),
      description: TxDxSyntax.getDescription(text),
      priority: TxDxSyntax.getPriority(text),
      createdOn: TxDxSyntax.getCreatedOn(text),
      completedOn: TxDxSyntax.getCompletedOn(text),
      dueOn: TxDxSyntax.getDueOn(text),
      tags: TxDxSyntax.getTags(text),
      contexts: TxDxSyntax.getContexts(text),
      projects: TxDxSyntax.getProjects(text),
    );
  }

  TxDxItem copyWith({
    bool? completed,
    String? description,
    String? priority,
    DateTime? createdOn,
    DateTime? completedOn,
    DateTime? dueOn,
    Iterable<String>? contexts,
    Iterable<String>? projects,
    Map<String, String>? tags,
  }) {
    TxDxItem theItem = TxDxItem(
      completed: completed ?? this.completed,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      createdOn: createdOn ?? this.createdOn,
      completedOn: completedOn ?? this.completedOn,
      dueOn: dueOn ?? this.dueOn,
      contexts: contexts ?? this.contexts,
      projects: projects ?? this.projects,
      tags: tags ?? this.tags,
    );
    theItem.id = id;
    return theItem;
  }

  bool get hasDueOn => dueOn != null;

  TxDxItem toggleComplete() {
    if (!completed) {
      return _markCompleted();
    } else {
      return _markNotCompleted();
    }
  }

  TxDxItem _markCompleted() {
    TxDxItem theItem = TxDxItem(
      completed: true,
      description: description,
      priority: null,
      createdOn: createdOn,
      completedOn: DateTime.now(),
      dueOn: dueOn,
      contexts: contexts,
      projects: projects,
      tags: tags,
    );
    theItem.id = id;
    return theItem;
  }

  TxDxItem _markNotCompleted() {
    TxDxItem theItem = TxDxItem(
      completed: false,
      description: description,
      priority: null,
      createdOn: createdOn,
      completedOn: null,
      dueOn: dueOn,
      contexts: contexts,
      projects: projects,
      tags: tags,
    );
    theItem.id = id;
    return theItem;
  }

  Map<String, dynamic> _toMap() {
    return {
      'completed': completed,
      'description': description,
      'priority': priority,
      'createdOn': createdOn,
      'completedOn': completedOn,
      'dueOn': dueOn,

    };
  }

  ///get function to get the properties of Item
  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }

  @override
  String toString() {
    return [
      completed ? 'x' : '',
      priority != null ? '($priority)' : '',
      completedOn != null ? Jiffy(completedOn).format('yyyy-MM-dd') : '',
      createdOn != null ? Jiffy(createdOn).format('yyyy-MM-dd') : '',
      description,
      contexts.join(" "),
      projects.join(" "),
      dueOn != null ? 'due:${Jiffy(dueOn).format('yyyy-MM-dd')}' : '',
      tags.keys.map((k) => '$k:${tags[k]}').join(' '),
    ].where((element) => element != '').join(' ');
  }
}