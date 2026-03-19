import 'package:boxing/features/sessions/domain/session_model.dart';

class RoundTemplates {
  RoundTemplates._();

  // --- Boxing ---

  static const offenseDefense = RoundTemplate(
    id: 'offense_defense',
    name: 'Offense / Defense',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Offense',
          durationSec: 120,
          color: 'work',
          audioCue: 'bell_single',
          comboCategories: ['punch']),
      RoundSegment(
          label: 'Defense',
          durationSec: 60,
          color: 'warning',
          audioCue: 'bell_double',
          comboCategories: ['defense']),
    ],
    repeatCount: 1, // 3 min total
  );

  static const bagConditioning = RoundTemplate(
    id: 'bag_conditioning',
    name: 'Bag + Conditioning',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Bag Work',
          durationSec: 60,
          color: 'work',
          audioCue: 'bell_single'),
      RoundSegment(label: 'Conditioning', durationSec: 30, color: 'warning'),
    ],
    repeatCount: 2, // 3 min total
  );

  static const burnoutFinisher = RoundTemplate(
    id: 'burnout',
    name: 'Burnout Finisher',
    isPreset: true,
    segments: [
      RoundSegment(label: 'Normal', durationSec: 120, color: 'work'),
      RoundSegment(
          label: 'Hard',
          durationSec: 45,
          color: 'warning',
          audioCue: 'bell_double'),
      RoundSegment(
          label: 'All-Out',
          durationSec: 15,
          color: 'rest',
          audioCue: 'bell_single'),
    ],
    repeatCount: 1, // 3 min total
  );

  static const pyramid = RoundTemplate(
    id: 'pyramid',
    name: 'Pyramid',
    isPreset: true,
    segments: [
      RoundSegment(label: 'Build', durationSec: 30, color: 'work'),
      RoundSegment(label: 'Build', durationSec: 60, color: 'work'),
      RoundSegment(
          label: 'Peak',
          durationSec: 120,
          color: 'warning',
          audioCue: 'bell_single'),
      RoundSegment(label: 'Taper', durationSec: 60, color: 'work'),
      RoundSegment(label: 'Taper', durationSec: 30, color: 'work'),
    ],
    repeatCount: 1, // 5 min total
  );

  static const stationRotation = RoundTemplate(
    id: 'station_rotation',
    name: 'Station Rotation',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Bag Work',
          durationSec: 60,
          color: 'work',
          audioCue: 'bell_single'),
      RoundSegment(label: 'Jump Rope', durationSec: 45, color: 'warning'),
      RoundSegment(label: 'Shadow Box', durationSec: 45, color: 'work'),
    ],
    repeatCount: 2, // 5 min total
  );

  // --- Muay Thai ---

  static const mtKickDrill = RoundTemplate(
    id: 'mt_kick_drill',
    name: 'Kick Drill (L/R)',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Left Kicks',
          durationSec: 90,
          color: 'work',
          audioCue: 'bell_single',
          comboCategories: ['kick']),
      RoundSegment(
          label: 'Right Kicks',
          durationSec: 90,
          color: 'warning',
          audioCue: 'bell_double',
          comboCategories: ['kick']),
    ],
    repeatCount: 1, // 3:00 total
  );

  static const mtClinchKnees = RoundTemplate(
    id: 'mt_clinch_knees',
    name: 'Clinch & Knees',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Clinch',
          durationSec: 120,
          color: 'work',
          audioCue: 'bell_single',
          comboCategories: ['grappling']),
      RoundSegment(
          label: 'Knee Barrage',
          durationSec: 60,
          color: 'warning',
          audioCue: 'bell_double',
          comboCategories: ['knee']),
    ],
    repeatCount: 1, // 3:00 total
  );

  static const mtElbowCombo = RoundTemplate(
    id: 'mt_elbow_combo',
    name: 'Elbows + Combos',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Combos',
          durationSec: 90,
          color: 'work',
          audioCue: 'bell_single',
          comboCategories: ['punch', 'kick']),
      RoundSegment(
          label: 'Elbows',
          durationSec: 90,
          color: 'warning',
          audioCue: 'bell_double',
          comboCategories: ['elbow']),
    ],
    repeatCount: 1, // 3:00 total
  );

  // --- MMA ---

  static const mmaGroundPound = RoundTemplate(
    id: 'mma_ground_pound',
    name: 'Ground & Pound',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Positional Control',
          durationSec: 180,
          color: 'work',
          audioCue: 'bell_single'),
      RoundSegment(
          label: 'Ground Strikes',
          durationSec: 120,
          color: 'warning',
          audioCue: 'bell_double'),
    ],
    repeatCount: 1, // 5:00 total
  );

  static const mmaSprawlBrawl = RoundTemplate(
    id: 'mma_sprawl_brawl',
    name: 'Sprawl & Brawl',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Striking',
          durationSec: 90,
          color: 'work',
          audioCue: 'bell_single'),
      RoundSegment(
          label: 'Sprawl Defense',
          durationSec: 30,
          color: 'rest',
          audioCue: 'bell_double'),
      RoundSegment(
          label: 'Counter Strike',
          durationSec: 60,
          color: 'warning',
          audioCue: 'bell_single'),
    ],
    repeatCount: 1, // 3:00 total
  );

  static const mmaTransitions = RoundTemplate(
    id: 'mma_transitions',
    name: 'Transition Drill',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Standing',
          durationSec: 120,
          color: 'work',
          audioCue: 'bell_single'),
      RoundSegment(
          label: 'Clinch',
          durationSec: 90,
          color: 'warning',
          audioCue: 'bell_double'),
      RoundSegment(
          label: 'Ground',
          durationSec: 90,
          color: 'rest',
          audioCue: 'bell_single'),
    ],
    repeatCount: 1, // 5:00 total
  );

  // --- BJJ ---

  static const bjjGuardPass = RoundTemplate(
    id: 'bjj_guard_pass',
    name: 'Guard Passing Drill',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Pass',
          durationSec: 90,
          color: 'work',
          audioCue: 'bell_single'),
      RoundSegment(
          label: 'Retain',
          durationSec: 90,
          color: 'warning',
          audioCue: 'bell_double'),
    ],
    repeatCount: 1, // 3:00 total
  );

  static const bjjSubEscape = RoundTemplate(
    id: 'bjj_sub_escape',
    name: 'Sub Defense Drill',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Attack',
          durationSec: 60,
          color: 'work',
          audioCue: 'bell_single'),
      RoundSegment(
          label: 'Escape',
          durationSec: 60,
          color: 'warning',
          audioCue: 'bell_double'),
    ],
    repeatCount: 1, // 2:00 total
  );

  // --- Kickboxing ---

  static const kbKickBox = RoundTemplate(
    id: 'kb_kick_box',
    name: 'Kick-Box Combo',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Boxing Combos',
          durationSec: 90,
          color: 'work',
          audioCue: 'bell_single',
          comboCategories: ['punch']),
      RoundSegment(
          label: 'Kick Combos',
          durationSec: 90,
          color: 'warning',
          audioCue: 'bell_double',
          comboCategories: ['kick']),
    ],
    repeatCount: 1, // 3:00 total
  );

  static const kbLowKick = RoundTemplate(
    id: 'kb_low_kick',
    name: 'Low Kick Drill',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Lead Leg',
          durationSec: 60,
          color: 'work',
          audioCue: 'bell_single'),
      RoundSegment(
          label: 'Rear Leg',
          durationSec: 60,
          color: 'warning',
          audioCue: 'bell_double'),
    ],
    repeatCount: 1, // 2:00 total
  );

  // --- Wrestling ---

  static const wrTakedownDrill = RoundTemplate(
    id: 'wr_takedown_drill',
    name: 'Takedown Drill',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Offense',
          durationSec: 60,
          color: 'work',
          audioCue: 'bell_single'),
      RoundSegment(
          label: 'Defense',
          durationSec: 60,
          color: 'warning',
          audioCue: 'bell_double'),
    ],
    repeatCount: 1, // 2:00 total
  );

  static const wrScramble = RoundTemplate(
    id: 'wr_scramble',
    name: 'Scramble Drill',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Top',
          durationSec: 30,
          color: 'work',
          audioCue: 'bell_single'),
      RoundSegment(
          label: 'Bottom',
          durationSec: 30,
          color: 'warning',
          audioCue: 'bell_double'),
    ],
    repeatCount: 1, // 1:00 total
  );

  /// All available pre-built templates
  static const List<RoundTemplate> all = [
    // boxing
    offenseDefense,
    bagConditioning,
    burnoutFinisher,
    pyramid,
    stationRotation,
    // muay thai
    mtKickDrill,
    mtClinchKnees,
    mtElbowCombo,
    // mma
    mmaGroundPound,
    mmaSprawlBrawl,
    mmaTransitions,
    // bjj
    bjjGuardPass,
    bjjSubEscape,
    // kickboxing
    kbKickBox,
    kbLowKick,
    // wrestling
    wrTakedownDrill,
    wrScramble,
  ];
}
