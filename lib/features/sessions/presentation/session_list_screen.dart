import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:boxing/core/constants/preset_sessions.dart';
import 'package:boxing/core/utils/duration_formatter.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';

class SessionListScreen extends StatelessWidget {
  const SessionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presets = PresetSessions.all;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boxing Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Quick Start',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...presets.map((session) => _SessionCard(session: session)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/session/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final SessionModel session;

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final totalDuration = session.totalDuration;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => context.push('/timer/${session.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${session.rounds} rounds × ${DurationFormatter.formatSeconds(session.roundDurationSec)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                DurationFormatter.format(totalDuration),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.play_arrow, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
