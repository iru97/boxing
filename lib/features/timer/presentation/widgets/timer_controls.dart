import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:boxing/l10n/app_localizations.dart';

class TimerControls extends StatelessWidget {
  final bool isPaused;
  final Color accentColor;
  final VoidCallback onPauseResume;
  final VoidCallback onSkipBack;
  final VoidCallback onSkipForward;

  const TimerControls({
    super.key,
    required this.isPaused,
    required this.accentColor,
    required this.onPauseResume,
    required this.onSkipBack,
    required this.onSkipForward,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Semantics(
          label: S.of(context).a11yPreviousRound,
          button: true,
          child: _ControlButton(
            icon: Icons.skip_previous_rounded,
            size: 64,
            color: accentColor,
            onTap: isPaused ? null : onSkipBack,
          ),
        ),
        const SizedBox(width: 24),
        Semantics(
          label: isPaused ? S.of(context).a11yResume : S.of(context).a11yPause,
          button: true,
          child: _ControlButton(
            icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            size: 80,
            color: accentColor,
            filled: true,
            onTap: onPauseResume,
          ),
        ),
        const SizedBox(width: 24),
        Semantics(
          label: S.of(context).a11yNextRound,
          button: true,
          child: _ControlButton(
            icon: Icons.skip_next_rounded,
            size: 64,
            color: accentColor,
            onTap: isPaused ? null : onSkipForward,
          ),
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final bool filled;
  final VoidCallback? onTap;

  const _ControlButton({
    required this.icon,
    required this.size,
    required this.color,
    this.filled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    final displayColor = isDisabled
        ? color.withValues(alpha: 0.3)
        : color;

    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: filled ? displayColor : Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap != null
              ? () {
                  HapticFeedback.selectionClick();
                  onTap!();
                }
              : null,
          child: Center(
            child: Icon(
              icon,
              size: size * 0.5,
              color: filled ? Colors.black : displayColor,
            ),
          ),
        ),
      ),
    );
  }
}
