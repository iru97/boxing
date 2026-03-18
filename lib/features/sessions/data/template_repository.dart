import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'package:boxing/features/sessions/domain/session_model.dart';

class TemplateRepository {
  final Box<String> _box;
  static const _uuid = Uuid();

  TemplateRepository(this._box);

  /// All user-created templates from Hive.
  List<RoundTemplate> getAll() {
    final templates = <RoundTemplate>[];
    for (final key in _box.keys) {
      final json = _box.get(key);
      if (json != null) {
        try {
          templates.add(RoundTemplate.fromJson(jsonDecode(json)));
        } catch (_) {
          // Skip corrupted entries
        }
      }
    }
    return templates;
  }

  /// Find a template by ID (custom templates only).
  RoundTemplate? getById(String id) {
    final json = _box.get(id);
    if (json != null) {
      try {
        return RoundTemplate.fromJson(jsonDecode(json));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Save (create or update) a custom template.
  Future<void> save(RoundTemplate template) async {
    final json = jsonEncode(template.toJson());
    await _box.put(template.id, json);
  }

  /// Delete a custom template. Returns false if not found.
  Future<bool> delete(String id) async {
    if (!_box.containsKey(id)) return false;
    await _box.delete(id);
    return true;
  }

  /// Duplicate a template with a new ID and name.
  Future<RoundTemplate> duplicate(RoundTemplate template) async {
    final copy = template.copyWith(
      id: _uuid.v4(),
      name: '${template.name} (copy)',
      isPreset: false,
    );
    await save(copy);
    return copy;
  }
}
