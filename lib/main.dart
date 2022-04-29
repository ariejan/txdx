import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:txdx/config/features.dart';
import 'package:txdx/screens/desktop/desktop_home_screen.dart';
import 'package:txdx/screens/mobile/mobile_home_screen.dart';
import 'package:txdx/screens/settings_screen.dart';
import 'package:window_size/window_size.dart';

import 'providers/items/item_count_provider.dart';
import 'providers/settings/settings_provider.dart';
import 'config/settings.dart';
import 'config/theme.dart';
import 'screens/common/loading_screen.dart';
import 'screens/mobile/add_item_screen.dart';
import 'widgets/desktop/no_glow_scroll_behavior.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (fIsDesktop) {
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
          return const LoadingScreen();
        } else if (file is AsyncLoading || interface is AsyncLoading) {
          return const LoadingScreen();
        }

        return const TxDxApp();
      }),
    ),
  );
}

class TxDxApp extends ConsumerWidget {
  const TxDxApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    if (fSupportBadgeCount) {
      ref.listen(badgeCount, (_, int next) {
        (next == 0)
            ? FlutterAppBadger.removeBadge()
            : FlutterAppBadger.updateBadgeCount(next);
      });
    }

    final namespace = ref.watch(namespaceProvider);
    final appTitle = namespace == 'release' ? 'TxDx' : 'TxDx - DEBUG';

    if (fIsDesktop) {
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

    final desktopRoutes = {
      '/': (context) => const DesktopHomeScreen(),
      '/settings': (context) => const SettingsScreen(),
    };

    final mobileRoutes = {
      '/': (context) => const MobileHomeScreen(),
      '/addItem': (context) => const AddItemScreen(),
    };

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
      routes: fIsDesktop ? desktopRoutes : mobileRoutes,
    );
  }
}
