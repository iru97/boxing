import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:boxing/features/settings/domain/app_settings.dart';

class SettingsRepository {
  final Box<String> _box;
  static const _key = 'app_settings';

  SettingsRepository(this._box);

  AppSettings load() {
    final json = _box.get(_key);
    if (json != null) {
      try {
        return AppSettings.fromJson(jsonDecode(json));
      } catch (_) {
        return const AppSettings();
      }
    }
    return const AppSettings();
  }

  Future<void> save(AppSettings settings) async {
    await _box.put(_key, jsonEncode(settings.toJson()));
  }
}
