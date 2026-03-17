import 'package:flutter/material.dart';

import 'package:boxing/core/theme/app_typography.dart';

class PhaseLabel extends StatelessWidget {
  final String label;
  final Color color;

  const PhaseLabel({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.phaseLabel(color),
    );
  }
}
