import 'package:flutter/material.dart';

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
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: Colors.white.withValues(alpha: 0.9),
        letterSpacing: 2,
      ),
    );
  }
}
