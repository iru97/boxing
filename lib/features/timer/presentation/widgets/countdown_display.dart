import 'package:flutter/widgets.dart';

import 'package:boxing/core/theme/app_typography.dart';
import 'package:boxing/l10n/app_localizations.dart';

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
      label: S.of(context).a11yCountdownRemaining(minutes, seconds),
      child: RepaintBoundary(
        child: Text(
          text,
          style: AppTypography.countdown(color),
        ),
      ),
    );
  }
}
