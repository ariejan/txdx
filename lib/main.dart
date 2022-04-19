import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:txdx/screens/home_screen.dart';
import 'package:txdx/screens/settings_screen.dart';
import 'package:window_size/window_size.dart';

import 'providers/items/item_count_provider.dart';
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
    setWindowFrame(const Rect.fromLTWH(100, 100, 960, 720));
  }

  runApp(
    ProviderScope(
      child: Consumer(builder: (context, ref, _) {
        final file = ref.watch(fileSettingsFutureProvider);
        final interface = ref.watch(interfaceSettingsFutureProvider);

        if (file is AsyncError || interface is AsyncError) {
          return const TxDxLoadingScreen();
        } else if (file is AsyncLoading || interface is AsyncLoading) {
          return const TxDxLoadingScreen();
        }

        return const TxDxApp();
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

    if (Platform.isMacOS) {
      ref.listen(badgeCount, (_, int next) {
        (next == 0)
            ? FlutterAppBadger.removeBadge()
            : FlutterAppBadger.updateBadgeCount(next);
      });
    }

    final namespace = ref.watch(namespaceProvider);
    final appTitle = namespace == 'release' ? 'TxDx' : 'TxDx - Debug';

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle(appTitle);
    }

    final themeBrightness = ref.watch(interfaceSettingsProvider).getString(settingsThemeBrightness);
    var themeMode = ThemeMode.system;
    switch(themeBrightness) {
      case 'system':
        themeMode = ThemeMode.system;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      case 'light':
        themeMode = ThemeMode.light;
        break;
    }

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
          child: Scaffold(
            body: navigator,
          ),
        );
      },
      routes: {
        '/': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
