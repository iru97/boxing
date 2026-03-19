import 'dart:ui';

import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';

/// Resolved display category for a session.
enum SessionCategory {
  // Per-sport subcategories
  boxingCompetition('Competition', SportColors.boxing),
  boxingTraining('Training', SportColors.boxing),
  boxingDrills('Drills', SportColors.boxing),

  muayThaiCompetition('Competition', SportColors.muayThai),
  muayThaiTraining('Training', SportColors.muayThai),
  muayThaiDrills('Drills', SportColors.muayThai),

  mmaCompetition('Competition', SportColors.mma),
  mmaTraining('Training', SportColors.mma),
  mmaDrills('Drills', SportColors.mma),

  bjjCompetition('Competition', SportColors.bjj),
  bjjTraining('Training', SportColors.bjj),
  bjjDrills('Drills', SportColors.bjj),

  kickboxingCompetition('Competition', SportColors.kickboxing),
  kickboxingTraining('Training', SportColors.kickboxing),
  kickboxingDrills('Drills', SportColors.kickboxing),

  wrestlingCompetition('Competition', SportColors.wrestling),
  wrestlingTraining('Training', SportColors.wrestling),
  wrestlingDrills('Drills', SportColors.wrestling),

  conditioning('Conditioning', CategoryColors.conditioning),
  custom('My Sessions', CategoryColors.custom);

  const SessionCategory(this.label, this.color);
  final String label;
  final Color color;
}

/// Derives the category from the session's sport and category fields.
SessionCategory categoryFor(SessionModel session) {
  if (!session.isPreset) return SessionCategory.custom;

  final sport = session.sport;
  final cat = session.category;

  if (sport == null && cat == 'conditioning') {
    return SessionCategory.conditioning;
  }

  return switch ((sport, cat)) {
    ('boxing', 'competition') => SessionCategory.boxingCompetition,
    ('boxing', 'training') => SessionCategory.boxingTraining,
    ('boxing', 'drills') => SessionCategory.boxingDrills,
    ('muayThai', 'competition') => SessionCategory.muayThaiCompetition,
    ('muayThai', 'training') => SessionCategory.muayThaiTraining,
    ('muayThai', 'drills') => SessionCategory.muayThaiDrills,
    ('mma', 'competition') => SessionCategory.mmaCompetition,
    ('mma', 'training') => SessionCategory.mmaTraining,
    ('mma', 'drills') => SessionCategory.mmaDrills,
    ('bjj', 'competition') => SessionCategory.bjjCompetition,
    ('bjj', 'training') => SessionCategory.bjjTraining,
    ('bjj', 'drills') => SessionCategory.bjjDrills,
    ('kickboxing', 'competition') => SessionCategory.kickboxingCompetition,
    ('kickboxing', 'training') => SessionCategory.kickboxingTraining,
    ('kickboxing', 'drills') => SessionCategory.kickboxingDrills,
    ('wrestling', 'competition') => SessionCategory.wrestlingCompetition,
    ('wrestling', 'training') => SessionCategory.wrestlingTraining,
    ('wrestling', 'drills') => SessionCategory.wrestlingDrills,
    _ => SessionCategory.custom,
  };
}

/// Returns the sport color for a session (for card accent bars).
Color categoryColorFor(SessionModel session) {
  final sport = session.sport;
  if (sport != null) {
    return switch (sport) {
      'boxing' => SportColors.boxing,
      'muayThai' => SportColors.muayThai,
      'mma' => SportColors.mma,
      'bjj' => SportColors.bjj,
      'kickboxing' => SportColors.kickboxing,
      'wrestling' => SportColors.wrestling,
      _ => CategoryColors.custom,
    };
  }
  if (session.category == 'conditioning') return CategoryColors.conditioning;
  return CategoryColors.custom;
}

/// Groups presets by sport, then by subcategory within each sport.
/// Returns: [ ('Boxing', [ ('Competition', [sessions]), ... ]), ... ]
List<(String, Color, List<(String, List<SessionModel>)>)> groupPresetsBySport(
    List<SessionModel> presets) {
  final sportOrder = [
    'boxing',
    'muayThai',
    'mma',
    'bjj',
    'kickboxing',
    'wrestling',
    null,
  ];
  final categoryOrder = [
    'competition',
    'training',
    'drills',
    'conditioning',
  ];

  final sportGroups = <String?, Map<String?, List<SessionModel>>>{};

  for (final session in presets) {
    final sport = session.sport;
    final cat = session.category;
    sportGroups.putIfAbsent(sport, () => {});
    sportGroups[sport]!.putIfAbsent(cat, () => []);
    sportGroups[sport]![cat]!.add(session);
  }

  final result =
      <(String, Color, List<(String, List<SessionModel>)>)>[];
  for (final sport in sportOrder) {
    if (!sportGroups.containsKey(sport)) continue;
    final sportLabel = switch (sport) {
      'boxing' => 'Boxing',
      'muayThai' => 'Muay Thai',
      'mma' => 'MMA',
      'bjj' => 'BJJ',
      'kickboxing' => 'Kickboxing',
      'wrestling' => 'Wrestling',
      _ => 'Conditioning',
    };
    final sportColor = switch (sport) {
      'boxing' => SportColors.boxing,
      'muayThai' => SportColors.muayThai,
      'mma' => SportColors.mma,
      'bjj' => SportColors.bjj,
      'kickboxing' => SportColors.kickboxing,
      'wrestling' => SportColors.wrestling,
      _ => CategoryColors.conditioning,
    };
    final subcategories = <(String, List<SessionModel>)>[];
    for (final cat in categoryOrder) {
      final sessions = sportGroups[sport]![cat];
      if (sessions != null && sessions.isNotEmpty) {
        final catLabel = switch (cat) {
          'competition' => 'Competition',
          'training' => 'Training',
          'drills' => 'Drills',
          'conditioning' => 'Conditioning',
          _ => 'Other',
        };
        subcategories.add((catLabel, sessions));
      }
    }
    if (subcategories.isNotEmpty) {
      result.add((sportLabel, sportColor, subcategories));
    }
  }

  return result;
}
