import 'package:flutter/material.dart';
import 'package:boxing/core/theme/app_colors.dart';

enum Sport {
  boxing(
    id: 'boxing',
    label: 'Boxing',
    icon: Icons.sports_mma,
    color: SportColors.boxing,
  ),
  muayThai(
    id: 'muayThai',
    label: 'Muay Thai',
    icon: Icons.sports_kabaddi,
    color: SportColors.muayThai,
  ),
  mma(
    id: 'mma',
    label: 'MMA',
    icon: Icons.shield,
    color: SportColors.mma,
  ),
  bjj(
    id: 'bjj',
    label: 'BJJ',
    icon: Icons.self_improvement,
    color: SportColors.bjj,
  ),
  kickboxing(
    id: 'kickboxing',
    label: 'Kickboxing',
    icon: Icons.sports_martial_arts,
    color: SportColors.kickboxing,
  ),
  wrestling(
    id: 'wrestling',
    label: 'Wrestling',
    icon: Icons.fitness_center,
    color: SportColors.wrestling,
  );

  const Sport({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String id;
  final String label;
  final IconData icon;
  final Color color;

  static Sport? fromId(String? id) {
    if (id == null) return null;
    return Sport.values.cast<Sport?>().firstWhere(
      (s) => s!.id == id,
      orElse: () => null,
    );
  }
}
