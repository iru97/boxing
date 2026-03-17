import 'package:flutter/material.dart';
import 'package:boxing/app/router.dart';
import 'package:boxing/core/theme/app_theme.dart';

class BoxingApp extends StatelessWidget {
  const BoxingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Boxing Timer',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
