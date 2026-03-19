import 'package:boxing/features/sessions/domain/session_model.dart';

class ConditioningPresets {
  ConditioningPresets._();

  static const List<SessionModel> all = [
    SessionModel(
      id: 'preset_conditioning',
      name: 'Conditioning',
      rounds: 10,
      roundDurationSec: 30,
      restDurationSec: 30,
      warningTimeSec: 5,
      isPreset: true,
      sport: null,
      category: 'conditioning',
    ),
    SessionModel(
      id: 'preset_tabata',
      name: 'Tabata',
      rounds: 8,
      roundDurationSec: 20,
      restDurationSec: 10,
      warningTimeSec: 0,
      isPreset: true,
      sport: null,
      category: 'conditioning',
    ),
    SessionModel(
      id: 'preset_emom',
      name: 'EMOM',
      rounds: 10,
      roundDurationSec: 60,
      restDurationSec: 0,
      warningTimeSec: 10,
      isPreset: true,
      sport: null,
      category: 'conditioning',
    ),
  ];
}
