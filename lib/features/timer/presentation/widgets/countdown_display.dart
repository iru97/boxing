import 'package:flutter/widgets.dart';

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

    return RepaintBoundary(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 80,
          fontWeight: FontWeight.w300,
          color: color,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
