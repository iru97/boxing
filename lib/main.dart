import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:boxing/app/app.dart';
import 'package:boxing/core/constants/app_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final sessionsBox =
      await Hive.openBox<String>(AppConstants.sessionsBoxName);
  final settingsBox =
      await Hive.openBox<String>(AppConstants.settingsBoxName);

  runApp(
    ProviderScope(
      overrides: [
        sessionsBoxProvider.overrideWithValue(sessionsBox),
        settingsBoxProvider.overrideWithValue(settingsBox),
      ],
      child: const BoxingApp(),
    ),
  );
}

/// Hive box providers for dependency injection
final sessionsBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError('sessionsBoxProvider must be overridden');
});

final settingsBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError('settingsBoxProvider must be overridden');
});
