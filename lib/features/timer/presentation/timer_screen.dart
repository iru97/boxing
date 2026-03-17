import 'package:flutter/material.dart';
import 'package:boxing/core/theme/app_colors.dart';

class TimerScreen extends StatelessWidget {
  final String sessionId;

  const TimerScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TimerColors.idle.withValues(alpha: 0.1),
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '0:00',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 80,
                    fontWeight: FontWeight.w300,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'READY',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 48),
            FilledButton.icon(
              onPressed: () {
                // Timer start will be implemented in Sprint 1
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('START'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(200, 64),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
