import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:txdx/due_notification_widget.dart';
import 'package:window_size/window_size.dart';

import 'txdx/txdx.dart';
import 'txdx_item_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('TxDx');
    setWindowMinSize(const Size(400, 300));
    setWindowMaxSize(Size.infinite);
  }

  runApp(const TxDxApp());
}

class TxDxApp extends StatelessWidget {
  const TxDxApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TxDx',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TodoListView(filename: 'todo.txt'),
    );
  }
}

class TodoListView extends StatefulWidget {
  const TodoListView({Key? key, required this.filename}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String filename;

  @override
  State<TodoListView> createState() => _TodoListViewState(filename);
}

class _TodoListViewState extends State<TodoListView> {
  String filename;
  late TxDxList txDxContext;

  _TodoListViewState(this.filename) {
    txDxContext = TxDxList(filename);
  }

  void _newTodoDialog() {}

  List<Widget> _getTxDxItemContainers() {
    return txDxContext.items
        .map((item) => TxDxItemWidget(
          item,
          onCompletedToggle: (bool completed) {
            setState(() {
              item.setCompleted(completed);
            });
          },
        ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: _getTxDxItemContainers(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
