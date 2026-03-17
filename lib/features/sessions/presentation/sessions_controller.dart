import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boxing/features/sessions/data/session_repository.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/main.dart';

/// Provides the SessionRepository backed by Hive.
final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  final box = ref.watch(sessionsBoxProvider);
  return SessionRepository(box);
});

/// All sessions (presets + custom).
final allSessionsProvider = Provider<List<SessionModel>>((ref) {
  ref.watch(_sessionsInvalidator);
  return ref.watch(sessionRepositoryProvider).getAll();
});

/// Custom sessions only.
final customSessionsProvider = Provider<List<SessionModel>>((ref) {
  ref.watch(_sessionsInvalidator);
  return ref.watch(sessionRepositoryProvider).getCustomSessions();
});

/// Lookup a session by ID.
final sessionByIdProvider =
    Provider.family<SessionModel?, String>((ref, id) {
  ref.watch(_sessionsInvalidator);
  return ref.watch(sessionRepositoryProvider).getById(id);
});

/// Invalidation counter — increment to refresh session lists.
final _sessionsInvalidator = StateProvider<int>((ref) => 0);

/// Controller for session CRUD operations.
final sessionsControllerProvider =
    Provider<SessionsController>((ref) => SessionsController(ref));

class SessionsController {
  final Ref _ref;

  SessionsController(this._ref);

  SessionRepository get _repo => _ref.read(sessionRepositoryProvider);

  Future<void> saveSession(SessionModel session) async {
    await _repo.saveSession(session);
    _invalidate();
  }

  Future<bool> deleteSession(String id) async {
    final result = await _repo.deleteSession(id);
    if (result) _invalidate();
    return result;
  }

  Future<SessionModel> duplicateSession(SessionModel session) async {
    final dup = await _repo.duplicateSession(session);
    _invalidate();
    return dup;
  }

  void _invalidate() {
    _ref.read(_sessionsInvalidator.notifier).state++;
  }
}
