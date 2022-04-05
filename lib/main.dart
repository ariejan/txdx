import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:txdx/screens/home_screen.dart';
import 'package:txdx/screens/settings_screen.dart';
import 'package:window_size/window_size.dart';

import 'providers/settings/settings_provider.dart';
import 'config/settings.dart';
import 'config/theme.dart';
import 'widgets/misc/no_glow_scroll_behavior.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('TxDx');
    setWindowMinSize(const Size(600, 380));
    setWindowMaxSize(Size.infinite);
  }

  runApp(
    ProviderScope(
      child: Consumer(builder: (context, ref, _) {
        final settingsFuture = ref.watch(settingsFutureProvider);
        return settingsFuture.maybeWhen(
          data: (d) => const TxDxApp(),
          orElse: () => const TxDxLoadingScreen(),
        );
      }),
    ),
  );
}

class TxDxLoadingScreen extends ConsumerWidget {
  const TxDxLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        home: Material(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Loading...'),
                  ),
                ]
            ),
          ),
        ),
    );
  }

}

class TxDxApp extends ConsumerWidget {
  const TxDxApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namespace = ref.watch(namespaceProvider);
    final appTitle = namespace == 'release' ? 'TxDx' : 'TxDx - Debug';

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle(appTitle);
    }

    final useSystemTheme = ref.watch(settingsProvider).getBool(settingsThemeUseSystem);
    final useDarkTheme = ref.watch(settingsProvider).getBool(settingsThemeUseDark);

    final themeMode = useSystemTheme ? ThemeMode.system : (useDarkTheme ? ThemeMode.dark : ThemeMode.light);

    return GetMaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: namespace != 'release',
      theme: TxDxTheme.light(),
      darkTheme: TxDxTheme.dark(),
      themeMode: themeMode,
      initialRoute: '/',
      builder: (_, navigator) {
        if (navigator == null) return Container();
        
        return ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: navigator,
        );
      },
      routes: {
        '/': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
