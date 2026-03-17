import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boxing/features/settings/data/settings_repository.dart';
import 'package:boxing/features/settings/domain/app_settings.dart';
import 'package:boxing/main.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return SettingsRepository(box);
});

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return AppSettingsNotifier(repo);
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repo;

  AppSettingsNotifier(this._repo) : super(_repo.load());

  Future<void> update(AppSettings settings) async {
    state = settings;
    await _repo.save(settings);
  }

  Future<void> updateField(AppSettings Function(AppSettings) updater) async {
    final updated = updater(state);
    await update(updated);
  }
}
