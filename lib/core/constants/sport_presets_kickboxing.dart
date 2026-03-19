import 'package:boxing/core/constants/round_templates.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';

class KickboxingPresets {
  KickboxingPresets._();

  static const List<SessionModel> all = [
    // --- Competition ---
    SessionModel(
      id: 'preset_kb_pro',
      name: 'Pro Kickboxing (K-1)',
      rounds: 3,
      roundDurationSec: 180,
      restDurationSec: 60,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'kickboxing',
      category: 'competition',
    ),
    SessionModel(
      id: 'preset_kb_pro_title',
      name: 'KB Title Fight',
      rounds: 5,
      roundDurationSec: 180,
      restDurationSec: 60,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'kickboxing',
      category: 'competition',
    ),
    SessionModel(
      id: 'preset_kb_amateur',
      name: 'Amateur Kickboxing',
      rounds: 3,
      roundDurationSec: 120,
      restDurationSec: 60,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'kickboxing',
      category: 'competition',
    ),

    // --- Training ---
    SessionModel(
      id: 'preset_kb_pad_work',
      name: 'KB Pad Work',
      rounds: 5,
      roundDurationSec: 180,
      restDurationSec: 60,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'kickboxing',
      category: 'training',
    ),
    SessionModel(
      id: 'preset_kb_heavy_bag',
      name: 'KB Bag Work',
      rounds: 6,
      roundDurationSec: 180,
      restDurationSec: 60,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'kickboxing',
      category: 'training',
    ),
    SessionModel(
      id: 'preset_kb_sparring',
      name: 'KB Sparring',
      rounds: 5,
      roundDurationSec: 180,
      restDurationSec: 60,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'kickboxing',
      category: 'training',
    ),
    SessionModel(
      id: 'preset_kb_shadow',
      name: 'KB Shadow Work',
      rounds: 5,
      roundDurationSec: 180,
      restDurationSec: 30,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'kickboxing',
      category: 'training',
    ),

    // --- Drills ---
    SessionModel(
      id: 'preset_kb_kick_box',
      name: 'Kick-Box Combo',
      rounds: 6,
      roundDurationSec: 180,
      restDurationSec: 60,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'kickboxing',
      category: 'drills',
      roundTemplate: RoundTemplates.kbKickBox,
    ),
    SessionModel(
      id: 'preset_kb_low_kick',
      name: 'Low Kick Drill',
      rounds: 6,
      roundDurationSec: 120,
      restDurationSec: 30,
      warningTimeSec: 5,
      isPreset: true,
      sport: 'kickboxing',
      category: 'drills',
      roundTemplate: RoundTemplates.kbLowKick,
    ),
  ];
}
