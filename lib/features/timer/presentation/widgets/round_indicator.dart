import 'package:flutter/material.dart';

import 'package:boxing/core/theme/app_typography.dart';

class RoundIndicator extends StatelessWidget {
  final int currentRound;
  final int totalRounds;

  const RoundIndicator({
    super.key,
    required this.currentRound,
    required this.totalRounds,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'ROUND $currentRound / $totalRounds',
      style: AppTypography.roundIndicator(
        Colors.white.withValues(alpha: 0.87),
      ),
    );
  }
}
