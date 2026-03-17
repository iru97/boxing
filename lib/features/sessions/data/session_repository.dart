import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'package:boxing/core/constants/preset_sessions.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';

class SessionRepository {
  final Box<String> _box;
  static const _uuid = Uuid();

  SessionRepository(this._box);

  /// All presets (immutable, always available).
  List<SessionModel> getAllPresets() => PresetSessions.all;

  /// All user-created sessions from Hive.
  List<SessionModel> getCustomSessions() {
    final sessions = <SessionModel>[];
    for (final key in _box.keys) {
      final json = _box.get(key);
      if (json != null) {
        try {
          sessions.add(SessionModel.fromJson(jsonDecode(json)));
        } catch (_) {
          // Skip corrupted entries
        }
      }
    }
    return sessions;
  }

  /// All sessions: presets first, then custom.
  List<SessionModel> getAll() {
    return [...getAllPresets(), ...getCustomSessions()];
  }

  /// Find a session by ID (searches presets and custom).
  SessionModel? getById(String id) {
    // Check presets first
    for (final preset in PresetSessions.all) {
      if (preset.id == id) return preset;
    }
    // Check custom sessions
    final json = _box.get(id);
    if (json != null) {
      try {
        return SessionModel.fromJson(jsonDecode(json));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Save (create or update) a custom session.
  Future<void> saveSession(SessionModel session) async {
    final json = jsonEncode(session.toJson());
    await _box.put(session.id, json);
  }

  /// Delete a custom session. Presets cannot be deleted.
  Future<bool> deleteSession(String id) async {
    // Prevent deleting presets
    for (final preset in PresetSessions.all) {
      if (preset.id == id) return false;
    }
    await _box.delete(id);
    return true;
  }

  /// Duplicate a session with a new ID and name.
  Future<SessionModel> duplicateSession(SessionModel session) async {
    final duplicate = session.copyWith(
      id: _uuid.v4(),
      name: '${session.name} (copy)',
      isPreset: false,
    );
    await saveSession(duplicate);
    return duplicate;
  }
}
