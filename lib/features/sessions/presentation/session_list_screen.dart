import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/core/utils/duration_formatter.dart';
import 'package:boxing/core/utils/session_category.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/sessions/presentation/sessions_controller.dart';
import 'package:boxing/features/timer/domain/timer_checkpoint.dart';
import 'package:boxing/features/timer/presentation/checkpoint_controller.dart';
import 'package:boxing/l10n/app_localizations.dart';

class SessionListScreen extends ConsumerWidget {
  const SessionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkpoint = ref.watch(activeCheckpointProvider);
    final allSessions = ref.watch(allSessionsProvider);
    final presets = allSessions.where((s) => s.isPreset).toList();
    final custom = allSessions.where((s) => !s.isPreset).toList();
    final grouped = groupPresetsByCategory(presets);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Action icons row
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.history,
                      color: Colors.white.withValues(alpha: 0.5)),
                  onPressed: () => context.push('/history'),
                ),
                IconButton(
                  icon: Icon(Icons.settings,
                      color: Colors.white.withValues(alpha: 0.5)),
                  onPressed: () => context.push('/settings'),
                ),
              ],
            ),
          ),

          // Brand name
          const SizedBox(height: 8),
          Center(
            child: Text(
              S.of(context).appBrandName,
              style: GoogleFonts.teko(
                fontSize: 48,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 6.0,
                height: 1.0,
              ),
            ),
          ),

          // Accent divider with red dot
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 200,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.divider,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.brandRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.divider,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tagline
          const SizedBox(height: 8),
          Center(
            child: Text(
              S.of(context).appTagline,
              style: GoogleFonts.barlowCondensed(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.4),
                letterSpacing: 2.5,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // In Progress card
          if (checkpoint != null) ...[
            _InProgressCard(
              checkpoint: checkpoint,
              onResume: () => context.push(
                '/timer/${checkpoint.sessionId}?resume=true',
              ),
              onDiscard: () => _confirmDiscard(context, ref, checkpoint),
            ),
            const SizedBox(height: 16),
          ],

          // Custom sessions section
          if (custom.isNotEmpty) ...[
            _SectionHeader(
              label: S.of(context).sectionMySessionsTitle,
              color: CategoryColors.custom,
              icon: Icons.person,
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

          // Quick Start horizontal row
          Text(
            S.of(context).sectionQuickStartTitle,
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

          // Grouped preset sections — collapsible, default closed
          Text(
            S.of(context).sectionPresetsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          for (final (category, sessions) in grouped)
            _CollapsibleCategory(
              label: _localizedCategoryLabel(context, category),
              color: category.color,
              icon: _iconForCategory(category),
              sessionCount: sessions.length,
              children: sessions.map((session) => _SessionCard(
                    session: session,
                    onTap: () => context.push('/timer/${session.id}'),
                    onLongPress: () =>
                        _showPresetActions(context, ref, session),
                  )).toList(),
            ),
          const SizedBox(height: 20),
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/session/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  static String _localizedCategoryLabel(
      BuildContext context, SessionCategory category) {
    final l = S.of(context);
    return switch (category) {
      SessionCategory.boxing => l.categoryBoxing,
      SessionCategory.bagWork => l.categoryBagWork,
      SessionCategory.conditioning => l.categoryConditioning,
      SessionCategory.combatSport => l.categoryCombatSport,
      SessionCategory.beginner => l.categoryBeginner,
      SessionCategory.compound => l.categoryCompound,
      SessionCategory.custom => l.sectionMySessionsTitle,
    };
  }

  static IconData _iconForCategory(SessionCategory category) {
    return switch (category) {
      SessionCategory.boxing => Icons.sports_mma,
      SessionCategory.bagWork => Icons.fitness_center,
      SessionCategory.conditioning => Icons.local_fire_department,
      SessionCategory.combatSport => Icons.shield,
      SessionCategory.beginner => Icons.school,
      SessionCategory.compound => Icons.view_timeline,
      SessionCategory.custom => Icons.person,
    };
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
              title: Text(S.of(context).actionEdit),
              onTap: () {
                Navigator.of(ctx).pop();
                context.push('/session/edit/${session.id}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: Text(S.of(context).actionDuplicate),
              onTap: () async {
                Navigator.of(ctx).pop();
                final dup = await ref
                    .read(sessionsControllerProvider)
                    .duplicateSession(session);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).snackbarSessionCreated(dup.name)),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                S.of(context).actionDelete,
                style: const TextStyle(color: Colors.red),
              ),
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
              title: Text(S.of(context).actionDuplicateAsCustom),
              onTap: () async {
                Navigator.of(ctx).pop();
                final dup = await ref
                    .read(sessionsControllerProvider)
                    .duplicateSession(session);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).snackbarSessionCreated(dup.name)),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDiscard(
      BuildContext context, WidgetRef ref, TimerCheckpoint checkpoint) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).discardSessionTitle),
        content: Text(
            S.of(context).discardSessionMessage(checkpoint.sessionName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(S.of(context).buttonCancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(checkpointControllerProvider).clearCheckpoint();
              Navigator.of(ctx).pop();
            },
            child: Text(
              S.of(context).buttonDiscard,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, SessionModel session) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).deleteSessionTitle),
        content: Text(S.of(context).deleteSessionMessage(session.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(S.of(context).buttonCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final deleted = await ref
                  .read(sessionsControllerProvider)
                  .deleteSession(session.id);
              if (context.mounted && deleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).snackbarSessionDeleted(session.name)),
                  ),
                );
              }
            },
            child: Text(
              S.of(context).actionDelete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

/// Category section header with icon, label, and colored accent line.
class _SectionHeader extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _SectionHeader({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                letterSpacing: 0.5,
              ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            color: color.withValues(alpha: 0.3),
          ),
        ),
      ],
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
                  S.of(context).sessionCardQuickFormat(session.rounds, totalMin),
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

/// Full session card with category color accent and duration summary.
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
    final hasTemplate = session.roundTemplate != null;

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
              // Category color bar (vertical accent)
              Container(
                width: 4,
                height: 40,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: catColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            session.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (hasTemplate)
                          Icon(
                            Icons.view_timeline,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session.restDurationSec > 0
                          ? S.of(context).sessionCardWorkRest(
                              DurationFormatter.formatSeconds(session.roundDurationSec),
                              DurationFormatter.formatSeconds(session.restDurationSec),
                              totalMin,
                            )
                          : S.of(context).sessionCardWorkOnly(
                              DurationFormatter.formatSeconds(session.roundDurationSec),
                              totalMin,
                            ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                S.of(context).sessionCardRoundsFormat(session.rounds),
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

/// Collapsible category section — starts collapsed to reduce clutter.
class _CollapsibleCategory extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final int sessionCount;
  final List<Widget> children;

  const _CollapsibleCategory({
    required this.label,
    required this.color,
    required this.icon,
    required this.sessionCount,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Remove divider lines that ExpansionTile adds by default
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        initiallyExpanded: false,
        leading: Icon(icon, size: 18, color: color),
        title: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                letterSpacing: 0.5,
              ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$sessionCount',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.expand_more,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ],
        ),
        children: children,
      ),
    );
  }
}

/// Card shown when there's an in-progress session that can be resumed.
class _InProgressCard extends StatelessWidget {
  final TimerCheckpoint checkpoint;
  final VoidCallback onResume;
  final VoidCallback onDiscard;

  const _InProgressCard({
    required this.checkpoint,
    required this.onResume,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    final remainingSec = checkpoint.phaseRemainingMs ~/ 1000;
    final phaseLabel = switch (checkpoint.enginePhase) {
      'warmup' => S.of(context).phaseLabelWarmup,
      'work' => S.of(context).phaseLabelWork,
      'segment' => S.of(context).phaseLabelWork,
      'rest' => S.of(context).phaseLabelRest,
      _ => '',
    };

    return Card(
      color: TimerColors.work.withValues(alpha: 0.15),
      child: InkWell(
        onTap: onResume,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.play_circle_fill,
                      color: TimerColors.work, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    S.of(context).inProgressTitle,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: TimerColors.work,
                          letterSpacing: 1.0,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                checkpoint.sessionName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '${S.of(context).inProgressRoundFormat(checkpoint.currentRound, 0).replaceFirst('/0', '/${_totalRoundsFromJson(checkpoint)}')}  ·  $phaseLabel  ·  ${DurationFormatter.formatSeconds(remainingSec)} ${S.of(context).inProgressTimeLeft}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.play_arrow, size: 20),
                      label: Text(S.of(context).buttonResume),
                      style: FilledButton.styleFrom(
                        backgroundColor: TimerColors.work,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(0, 48),
                      ),
                      onPressed: onResume,
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white.withValues(alpha: 0.6),
                      side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.2)),
                      minimumSize: const Size(0, 48),
                    ),
                    onPressed: onDiscard,
                    child: Text(S.of(context).buttonDiscard),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _totalRoundsFromJson(TimerCheckpoint checkpoint) {
    try {
      final map = const JsonDecoder()
          .convert(checkpoint.sessionJson) as Map<String, dynamic>;
      return (map['rounds'] as int?) ?? 0;
    } catch (_) {
      return 0;
    }
  }
}
