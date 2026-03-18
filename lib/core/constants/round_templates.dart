import 'package:boxing/features/sessions/domain/session_model.dart';

class RoundTemplates {
  RoundTemplates._();

  static const offenseDefense = RoundTemplate(
    id: 'offense_defense',
    name: 'Offense / Defense',
    isPreset: true,
    segments: [
      RoundSegment(
          label: 'Offense',
          durationSec: 120,
          color: 'work',
          audioCue: 'bell_single'),
      RoundSegment(
          label: 'Defense',
          durationSec: 60,
          color: 'warning',
          audioCue: 'bell_double'),
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

  /// All available pre-built templates
  static const List<RoundTemplate> all = [
    offenseDefense,
    bagConditioning,
    burnoutFinisher,
    pyramid,
    stationRotation,
  ];
}
