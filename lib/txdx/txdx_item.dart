import 'package:jiffy/jiffy.dart';
import 'package:quiver/core.dart';
import 'package:uuid/uuid.dart';

import 'txdx_syntax.dart';

const _uuid = Uuid();

class TxDxItem {

  static const priorities = ['A', 'B', 'C', 'D', null];

  final String id;
  final bool completed;
  final String description;
  final String? priority;
  final DateTime? createdOn;
  final DateTime? completedOn;
  final Iterable<String> contexts;
  final Iterable<String> projects;
  final Map<String, String> tags;
  final bool isNew;

  TxDxItem({
    required this.id,
    this.completed = false,
    this.description = '',
    this.priority,
    this.createdOn,
    this.completedOn,
    this.isNew = false,
    this.contexts = const <String>[],
    this.projects = const <String>[],
    this.tags = const <String, String>{},
  });

  static TxDxItem newFromText(String text) {
    return fromText(text).copyWith(isNew: true);
  }

  static TxDxItem fromText(String text) {
    return fromTextWithId(_uuid.v4(), text);
  }

  static TxDxItem fromTextWithId(String id, String text) {
    return TxDxItem(
      id: id,
      completed: TxDxSyntax.getCompleted(text),
      description: TxDxSyntax.getDescription(text),
      priority: TxDxSyntax.getPriority(text),
      createdOn: TxDxSyntax.getCreatedOn(text),
      completedOn: TxDxSyntax.getCompletedOn(text),
      tags: TxDxSyntax.getTags(text),
      contexts: TxDxSyntax.getContexts(text),
      projects: TxDxSyntax.getProjects(text),
    );
  }

  TxDxItem copyWith({
    bool? completed,
    String? description,
    Optional<String>? priority,
    DateTime? createdOn,
    DateTime? completedOn,
    bool? isNew,
    Iterable<String>? contexts,
    Iterable<String>? projects,
    Map<String, String>? tags,
  }) {
    return TxDxItem(
      id: id,
      completed: completed ?? this.completed,
      description: description ?? this.description,
      priority: priority != null ? priority.orNull : this.priority,
      createdOn: createdOn ?? this.createdOn,
      completedOn: completedOn ?? this.completedOn,
      isNew: isNew ?? this.isNew,
      contexts: contexts ?? this.contexts,
      projects: projects ?? this.projects,
      tags: tags ?? this.tags,
    );
  }

  TxDxItem toggleComplete() {
    if (!completed) {
      return _markCompleted();
    } else {
      return _markNotCompleted();
    }
  }

  TxDxItem prioDown() {
    final pIdx = priorities.indexOf(priority);
    final newIdx = (pIdx + 1) % priorities.length;
    return copyWith(
      priority: Optional.fromNullable(priorities[newIdx]),
    );
  }

  TxDxItem prioUp() {
    final pIdx = priorities.indexOf(priority);
    final newIdx = (pIdx - 1) % priorities.length;
    return copyWith(
      priority: Optional.fromNullable(priorities[newIdx]),
    );
  }

  TxDxItem _markCompleted() {
    var newItem = TxDxItem(
      id: id,
      completed: true,
      description: description,
      priority: null,
      createdOn: createdOn,
      completedOn: DateTime.now(),
      contexts: contexts,
      projects: projects,
      tags: tags,
    );

    if (priority != null) {
      newItem = newItem.addTags({'pri': priority!});
    }

    return newItem;
  }

  TxDxItem _markNotCompleted() {
    return TxDxItem(
      id: id,
      completed: false,
      description: description,
      priority: null,
      createdOn: createdOn,
      completedOn: null,
      contexts: contexts,
      projects: projects,
      tags: tags,
    );
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
      tagsWithoutDue.keys.map((k) => '$k:${tags[k]}').join(' '),
    ].where((element) => element != '').join(' ');
  }

  bool hasContextOrProject(String filter) {
    return contexts.contains(filter) || projects.contains(filter);
  }

  Map<String, String> get tagsWithoutDue {
    var result = Map<String, String>.from(tags);
    result.removeWhere((key, value) => key == 'due');
    return result;
  }
  bool get hasDueOn => tags.containsKey('due');

  DateTime? get dueOn {
    if (tags.containsKey('due')) {
      return DateTime.tryParse(tags['due']!);
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (other is TxDxItem) {
      return toString() == other.toString();
    }
    return false;
  }

  @override
  int get hashCode => toString().hashCode;

  TxDxItem moveToToday() {
    return postpone(0);
  }

  TxDxItem postpone(int days) {
    var newTags = Map<String, String>.from(tags);
    final futureDate = DateTime.now().add(Duration(days: days));
    newTags['due'] = Jiffy(futureDate).format('yyyy-MM-dd');
    return copyWith(tags: newTags);
  }

  TxDxItem setPriority(String? priority) {
    return copyWith(
      priority: Optional.fromNullable(priority),
    );
  }

  bool hasSetPriority() {
    return priority?.isNotEmpty ?? false;
  }

  TxDxItem setDueOn(DateTime? dueOn) {
    var newTags = Map<String, String>.from(tags);

    if (dueOn == null) {
      if (newTags.keys.contains('due')) {
        newTags.remove('due');
      }
    } else {
      newTags['due'] = Jiffy(dueOn).format('yyyy-MM-dd');
    }

    return copyWith(tags: newTags);
  }

  TxDxItem removeContext(String context) {
    var newContexts = List<String>.from(contexts);
    newContexts.remove(context);
    return copyWith(contexts: newContexts.toSet().toList());
  }

  TxDxItem addContexts(Iterable<String> addedContexts) {
    var newContexts = List<String>.from(contexts);
    newContexts.addAll(addedContexts);
    return copyWith(contexts: newContexts.toSet().toList());
  }

  TxDxItem removeProject(String project) {
    var newProjects = List<String>.from(projects);
    newProjects.remove(project);
    return copyWith(projects: newProjects.toSet().toList());
  }

  TxDxItem addProjects(Iterable<String> addedProjects) {
    var newProjects = List<String>.from(projects);
    newProjects.addAll(addedProjects);
    return copyWith(projects: newProjects.toSet().toList());
  }

  TxDxItem addTags(Map<String, String> addedTags) {
    var newTags = Map<String, String>.from(tags);
    addedTags.forEach((key, value) => newTags[key] = value);
    return copyWith(tags: newTags);
  }

  TxDxItem removeTagName(String tagName) {
    var newTags = Map<String, String>.from(tags);
    newTags.remove(tagName);
    return copyWith(tags: newTags);
  }
}