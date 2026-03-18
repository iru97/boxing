import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:boxing/core/constants/round_templates.dart';
import 'package:boxing/features/sessions/data/template_repository.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';

/// Hive box provider for templates (overridden in main.dart).
final templateBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError('templateBoxProvider must be overridden');
});

/// Provides the TemplateRepository backed by Hive.
final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  final box = ref.watch(templateBoxProvider);
  return TemplateRepository(box);
});

/// All templates (presets + custom).
final allTemplatesProvider = Provider<List<RoundTemplate>>((ref) {
  ref.watch(_templatesInvalidator);
  final repo = ref.watch(templateRepositoryProvider);
  return [...RoundTemplates.all, ...repo.getAll()];
});

/// Custom templates only.
final customTemplatesProvider = Provider<List<RoundTemplate>>((ref) {
  ref.watch(_templatesInvalidator);
  return ref.watch(templateRepositoryProvider).getAll();
});

/// Lookup a template by ID (searches presets and custom).
final templateByIdProvider =
    Provider.family<RoundTemplate?, String>((ref, id) {
  ref.watch(_templatesInvalidator);
  // Check presets first
  for (final preset in RoundTemplates.all) {
    if (preset.id == id) return preset;
  }
  // Check custom templates
  return ref.watch(templateRepositoryProvider).getById(id);
});

/// Invalidation counter — increment to refresh template lists.
final _templatesInvalidator = StateProvider<int>((ref) => 0);

/// Controller for template CRUD operations.
final templatesControllerProvider =
    Provider<TemplatesController>((ref) => TemplatesController(ref));

class TemplatesController {
  final Ref _ref;

  TemplatesController(this._ref);

  TemplateRepository get _repo => _ref.read(templateRepositoryProvider);

  Future<void> saveTemplate(RoundTemplate template) async {
    await _repo.save(template);
    _invalidate();
  }

  Future<bool> deleteTemplate(String id) async {
    final result = await _repo.delete(id);
    if (result) _invalidate();
    return result;
  }

  Future<RoundTemplate> duplicateTemplate(RoundTemplate template) async {
    final dup = await _repo.duplicate(template);
    _invalidate();
    return dup;
  }

  void _invalidate() {
    _ref.read(_templatesInvalidator.notifier).state++;
  }
}
