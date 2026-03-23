import 'package:flutter/material.dart';

/// Bulleted list of form cue points for a technique.
///
/// Each point is preceded by a colored bullet dot.
class FormPointsList extends StatelessWidget {
  final List<String> points;
  final Color bulletColor;

  const FormPointsList({
    super.key,
    required this.points,
    this.bulletColor = const Color(0xFFFFB300), // AppColors.brandGold
  });

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < points.length; i++) ...[
          _FormPoint(text: points[i], bulletColor: bulletColor),
          if (i < points.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _FormPoint extends StatelessWidget {
  final String text;
  final Color bulletColor;

  const _FormPoint({required this.text, required this.bulletColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, right: 10),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: bulletColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.4,
                ),
          ),
        ),
      ],
    );
  }
}
