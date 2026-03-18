import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boxing/app/router.dart';
import 'package:boxing/core/theme/app_theme.dart';
import 'package:boxing/features/settings/presentation/settings_controller.dart';
import 'package:boxing/l10n/app_localizations.dart';

class BoxingApp extends ConsumerWidget {
  const BoxingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final themeMode = switch (settings.themeMode) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark,
    };

    final locale = settings.locale == 'system'
        ? null
        : Locale(settings.locale);

    return MaterialApp.router(
      title: 'Boxing Timer',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
    );
  }
}
