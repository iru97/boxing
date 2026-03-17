import 'dart:ui';

import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';

/// Maps sessions to their category color for card accent dots.
Color categoryColorFor(SessionModel session) {
  if (!session.isPreset) return CategoryColors.custom;

  return switch (session.id) {
    // Boxing: Pro, Amateur, Sparring, Pad Work
    'preset_pro_boxing_men' ||
    'preset_pro_boxing_women' ||
    'preset_amateur_boxing' ||
    'preset_amateur_women' ||
    'preset_sparring' ||
    'preset_pad_work' =>
      CategoryColors.boxing,

    // Bag Work: Heavy Bag, Speed Bag
    'preset_heavy_bag' || 'preset_speed_bag' => CategoryColors.bagWork,

    // Conditioning: Conditioning, Tabata, EMOM
    'preset_conditioning' ||
    'preset_tabata' ||
    'preset_emom' =>
      CategoryColors.conditioning,

    // Combat Sport: Muay Thai, MMA, Kickboxing
    'preset_muay_thai' ||
    'preset_mma' ||
    'preset_kickboxing' =>
      CategoryColors.combatSport,

    // Beginner: Beginner, Youth, Shadow Boxing
    'preset_beginner' ||
    'preset_youth_boxing' ||
    'preset_shadow_boxing' =>
      CategoryColors.beginner,

    _ => CategoryColors.custom,
  };
}
