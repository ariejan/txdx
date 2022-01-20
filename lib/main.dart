import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  runApp(
    const ProviderScope(
        child: TxDxApp()
    ),
  );
}

class TxDxApp extends ConsumerWidget {
  const TxDxApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'TxDx',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TxDxListViewWidget(),
        '/settings': (context) => SettingsViewWidget(),
      },
    );
  }
}
