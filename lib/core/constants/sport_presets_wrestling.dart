import 'package:boxing/core/constants/round_templates.dart';
import 'package:boxing/features/combos/domain/combo_callout_config.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';

class WrestlingPresets {
  WrestlingPresets._();

  static const List<SessionModel> all = [
    // --- Competition ---
    SessionModel(
      id: 'preset_wr_folkstyle_college',
      name: 'NCAA Folkstyle',
      rounds: 3,
      roundDurationSec: 180,
      restDurationSec: 30,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'wrestling',
      category: 'competition',
      roundOverrides: [
        RoundOverride(round: 1, durationSec: 180),
        RoundOverride(round: 2, durationSec: 120),
        RoundOverride(round: 3, durationSec: 120),
      ],
    ),
    SessionModel(
      id: 'preset_wr_folkstyle_hs',
      name: 'HS Folkstyle',
      rounds: 3,
      roundDurationSec: 120,
      restDurationSec: 30,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'wrestling',
      category: 'competition',
    ),
    SessionModel(
      id: 'preset_wr_freestyle',
      name: 'Freestyle / Greco',
      rounds: 2,
      roundDurationSec: 180,
      restDurationSec: 30,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'wrestling',
      category: 'competition',
    ),

    // --- Training ---
    SessionModel(
      id: 'preset_wr_live',
      name: 'Live Wrestling',
      rounds: 6,
      roundDurationSec: 180,
      restDurationSec: 30,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'wrestling',
      category: 'training',
    ),
    SessionModel(
      id: 'preset_wr_situational',
      name: 'Situational Wrestling',
      rounds: 8,
      roundDurationSec: 120,
      restDurationSec: 15,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'wrestling',
      category: 'training',
      comboConfig: ComboCalloutConfig(
        enabled: true,
        sport: 'wrestling',
        difficulty: 'intermediate',
        intensity: 'moderate',
      ),
    ),
    SessionModel(
      id: 'preset_wr_shark_bait',
      name: 'Shark Bait',
      rounds: 10,
      roundDurationSec: 30,
      restDurationSec: 10,
      warningTimeSec: 5,
      isPreset: true,
      sport: 'wrestling',
      category: 'training',
    ),
    SessionModel(
      id: 'preset_wr_drilling',
      name: 'Technique Drilling',
      rounds: 6,
      roundDurationSec: 180,
      restDurationSec: 30,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'wrestling',
      category: 'training',
      comboConfig: ComboCalloutConfig(
        enabled: true,
        sport: 'wrestling',
        difficulty: 'beginner',
        intensity: 'relaxed',
      ),
    ),

    // --- Drills ---
    SessionModel(
      id: 'preset_wr_takedown_drill',
      name: 'Takedown Drill',
      rounds: 8,
      roundDurationSec: 120,
      restDurationSec: 15,
      warningTimeSec: 10,
      isPreset: true,
      sport: 'wrestling',
      category: 'drills',
      roundTemplate: RoundTemplates.wrTakedownDrill,
    ),
    SessionModel(
      id: 'preset_wr_scramble',
      name: 'Scramble Drill',
      rounds: 6,
      roundDurationSec: 60,
      restDurationSec: 15,
      warningTimeSec: 5,
      isPreset: true,
      sport: 'wrestling',
      category: 'drills',
      roundTemplate: RoundTemplates.wrScramble,
    ),
  ];
}
