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
      return copyWith(
        completed: true,
        completedOn: DateTime.now(),
      );
    } else {
      return copyWith(
        completed: false,
        completedOn: null,
      );
    }
  }
}