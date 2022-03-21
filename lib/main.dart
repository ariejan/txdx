import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:txdx/screens/home_screen.dart';
import 'package:txdx/screens/settings_screen.dart';
import 'package:window_size/window_size.dart';

import 'providers/shared_preferences_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('TxDx');
    setWindowMinSize(const Size(400, 300));
    setWindowMaxSize(Size.infinite);
  }

  runApp(
    const ProviderScope(
        child: TxDxApp()),
  );
}

class TxDxApp extends ConsumerWidget {
  const TxDxApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namespace = ref.watch(namespaceProvider);

    return GetMaterialApp(
      title: namespace == 'release'  ? 'TxDx' : 'TxDx - Debug',
      debugShowCheckedModeBanner: namespace != 'release',
      theme: NordTheme.light(),
      darkTheme: NordTheme.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
