import 'dart:io';

import 'package:flutter/material.dart';
import 'package:txdx/settings_view_widget.dart';
import 'package:window_size/window_size.dart';

import 'txdx_list_view_widget.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const TxDxListViewWidget(filename: ''),
        '/settings': (context) => const SettingsViewWidget(),
      },
    );
  }
}
