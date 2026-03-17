import 'package:flutter/widgets.dart';

import 'package:boxing/core/theme/app_typography.dart';

class CountdownDisplay extends StatelessWidget {
  final Duration remaining;
  final Color color;

  const CountdownDisplay({
    super.key,
    required this.remaining,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final totalSeconds = remaining.inSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final text = '$minutes:${seconds.toString().padLeft(2, '0')}';

    return Semantics(
      label: '$minutes minutes $seconds seconds remaining',
      child: RepaintBoundary(
        child: Text(
          text,
          style: AppTypography.countdown(color),
        ),
      ),
    );
  }
}
