import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/core/utils/duration_formatter.dart';
import 'package:boxing/core/utils/session_category.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/sessions/presentation/sessions_controller.dart';

class SessionListScreen extends ConsumerWidget {
  const SessionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSessions = ref.watch(allSessionsProvider);
    final presets = allSessions.where((s) => s.isPreset).toList();
    final custom = allSessions.where((s) => !s.isPreset).toList();

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
          if (custom.isNotEmpty) ...[
            Text(
              'My Sessions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...custom.map((session) => _SessionCard(
                  session: session,
                  onTap: () => context.push('/timer/${session.id}'),
                  onLongPress: () =>
                      _showCustomActions(context, ref, session),
                )),
            const SizedBox(height: 24),
          ],
          Text(
            'Quick Start',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: presets.length > 3 ? 3 : presets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final session = presets[index];
                return _QuickStartCard(
                  session: session,
                  onTap: () => context.push('/timer/${session.id}'),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'All Presets',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...presets.map((session) => _SessionCard(
                session: session,
                onTap: () => context.push('/timer/${session.id}'),
                onLongPress: () =>
                    _showPresetActions(context, ref, session),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/session/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCustomActions(
      BuildContext context, WidgetRef ref, SessionModel session) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.of(ctx).pop();
                context.push('/session/edit/${session.id}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Duplicate'),
              onTap: () async {
                Navigator.of(ctx).pop();
                final dup = await ref
                    .read(sessionsControllerProvider)
                    .duplicateSession(session);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Created "${dup.name}"')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(ctx).pop();
                _confirmDelete(context, ref, session);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPresetActions(
      BuildContext context, WidgetRef ref, SessionModel session) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Duplicate as Custom'),
              onTap: () async {
                Navigator.of(ctx).pop();
                final dup = await ref
                    .read(sessionsControllerProvider)
                    .duplicateSession(session);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Created "${dup.name}"')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, SessionModel session) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Session?'),
        content: Text('Delete "${session.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final deleted = await ref
                  .read(sessionsControllerProvider)
                  .deleteSession(session.id);
              if (context.mounted && deleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleted "${session.name}"')),
                );
              }
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

/// Compact horizontal card for Quick Start section.
class _QuickStartCard extends StatelessWidget {
  final SessionModel session;
  final VoidCallback onTap;

  const _QuickStartCard({
    required this.session,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = categoryColorFor(session);
    final totalMin = session.totalDuration.inMinutes;

    return SizedBox(
      width: 160,
      child: Card(
        color: AppColors.cardSurface,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: catColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        session.name,
                        style: Theme.of(context).textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${session.rounds}R  $totalMin min',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Full session card with category color dot and duration summary.
class _SessionCard extends StatelessWidget {
  final SessionModel session;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _SessionCard({
    required this.session,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = categoryColorFor(session);
    final totalMin = session.totalDuration.inMinutes;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Category color dot
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: catColor,
                  shape: BoxShape.circle,
                ),
              ),
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
                      '${DurationFormatter.formatSeconds(session.roundDurationSec)} work'
                      '${session.restDurationSec > 0 ? ' \u00B7 ${DurationFormatter.formatSeconds(session.restDurationSec)} rest' : ''}'
                      ' \u00B7 $totalMin min',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                '${session.rounds}R',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
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
