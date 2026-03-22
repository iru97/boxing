import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:boxing/core/constants/sport.dart';
import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/core/utils/duration_formatter.dart';
import 'package:boxing/core/utils/session_category.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/sessions/presentation/sessions_controller.dart';
import 'package:boxing/features/ads/presentation/widgets/banner_ad_widget.dart';
import 'package:boxing/features/timer/domain/timer_checkpoint.dart';
import 'package:boxing/features/timer/presentation/checkpoint_controller.dart';
import 'package:boxing/features/programs/presentation/programs_controller.dart';
import 'package:boxing/features/programs/domain/training_program.dart';
import 'package:boxing/features/programs/domain/program_progress.dart';
import 'package:boxing/l10n/app_localizations.dart';

class SessionListScreen extends ConsumerWidget {
  const SessionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkpoint = ref.watch(activeCheckpointProvider);
    final allSessions = ref.watch(allSessionsProvider);
    final custom = allSessions.where((s) => !s.isPreset).toList();

    // Quick Start uses the first 3 presets unfiltered.
    final allPresets = allSessions.where((s) => s.isPreset).toList();

    // Preset section respects the sport filter.
    final filteredPresets = ref.watch(filteredPresetsProvider);
    final sportGroups = groupPresetsBySport(filteredPresets);
    final selectedSport = ref.watch(selectedSportFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
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
                      onDiscard: () =>
                          _confirmDiscard(context, ref, checkpoint),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Active programs + browse shortcut
                  _ProgramsHomeSection(),
                  const SizedBox(height: 16),

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
                      itemCount:
                          allPresets.length > 3 ? 3 : allPresets.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final session = allPresets[index];
                        return _QuickStartCard(
                          session: session,
                          onTap: () =>
                              context.push('/timer/${session.id}'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sport filter chips
                  Text(
                    S.of(context).sectionPresetsTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  _SportFilterChips(
                    selectedSport: selectedSport,
                    onSelected: (sport) {
                      ref
                          .read(selectedSportFilterProvider.notifier)
                          .state = sport;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Sport-grouped preset sections
                  for (final (sportLabel, sportColor, subcategories)
                      in sportGroups)
                    _SportSection(
                      sportLabel: sportLabel,
                      sportColor: sportColor,
                      subcategories: subcategories,
                      onSessionTap: (session) =>
                          context.push('/timer/${session.id}'),
                      onSessionLongPress: (session) =>
                          _showPresetActions(context, ref, session),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
            const BannerAdWidget(),
          ],
        ),
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
                      content: Text(
                          S.of(context).snackbarSessionCreated(dup.name)),
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
                      content: Text(
                          S.of(context).snackbarSessionCreated(dup.name)),
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
                    content: Text(
                        S.of(context).snackbarSessionDeleted(session.name)),
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

// ---------------------------------------------------------------------------
// Programs home section – active programs + browse button
// ---------------------------------------------------------------------------

class _ProgramsHomeSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePrograms = ref.watch(activeProgramsProvider);
    final controller = ref.watch(programsControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Active programs shortcuts
        if (activePrograms.isNotEmpty) ...[
          _SectionHeader(
            label: 'Programs',
            color: AppColors.brandRed,
            icon: Icons.fitness_center,
          ),
          const SizedBox(height: 8),
          for (final (program, progress) in activePrograms) ...[
            _ActiveProgramCard(
              program: program,
              progress: progress,
              nextDay: controller.nextIncompleteDay(program, progress),
              onTap: () => context.push('/programs/${program.id}'),
              onContinue: (weekNum, dayNum) {
                context.push(
                  '/programs/${program.id}/day/w${weekNum}d$dayNum',
                );
              },
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
        ],

        // Browse all programs button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.explore, size: 18),
            label: Text(
              activePrograms.isEmpty ? 'Training Programs' : 'Browse All Programs',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white.withValues(alpha: 0.7),
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.15),
              ),
              minimumSize: const Size.fromHeight(44),
            ),
            onPressed: () => context.push('/programs'),
          ),
        ),
      ],
    );
  }
}

class _ActiveProgramCard extends StatelessWidget {
  final TrainingProgram program;
  final ProgramProgress progress;
  final (int, int)? nextDay;
  final VoidCallback onTap;
  final void Function(int weekNum, int dayNum) onContinue;

  const _ActiveProgramCard({
    required this.program,
    required this.progress,
    required this.nextDay,
    required this.onTap,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final sport = Sport.fromId(program.sport);
    final sportColor = sport?.color ?? SportColors.boxing;
    final completionPct = progress.completionPercentage(program.totalDays);

    return Card(
      color: AppColors.cardSurface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Progress circle
              SizedBox(
                width: 40,
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: completionPct,
                      strokeWidth: 3,
                      backgroundColor: AppColors.divider,
                      valueColor: AlwaysStoppedAnimation(sportColor),
                    ),
                    Text(
                      '${(completionPct * 100).round()}%',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: sportColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Program info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (nextDay != null)
                      Text(
                        'Next: Week ${nextDay!.$1}, Day ${nextDay!.$2}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                      ),
                  ],
                ),
              ),

              // Continue button
              if (nextDay != null)
                IconButton(
                  icon: Icon(Icons.play_circle_fill,
                      color: sportColor, size: 28),
                  onPressed: () => onContinue(nextDay!.$1, nextDay!.$2),
                  tooltip: 'Continue',
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sport filter chips
// ---------------------------------------------------------------------------

class _SportFilterChips extends StatelessWidget {
  final Sport? selectedSport;
  final ValueChanged<Sport?> onSelected;

  const _SportFilterChips({
    required this.selectedSport,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // "All" chip
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(l.sportFilterAll),
              selected: selectedSport == null,
              onSelected: (_) => onSelected(null),
              selectedColor: AppColors.brandRed.withValues(alpha: 0.25),
              checkmarkColor: AppColors.brandRed,
              labelStyle: TextStyle(
                color: selectedSport == null
                    ? AppColors.brandRed
                    : Colors.white.withValues(alpha: 0.6),
                fontSize: 13,
                fontWeight: selectedSport == null
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
              backgroundColor: AppColors.cardSurface,
              side: BorderSide(
                color: selectedSport == null
                    ? AppColors.brandRed.withValues(alpha: 0.6)
                    : AppColors.divider,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ),
          // Sport chips
          for (final sport in Sport.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: Icon(sport.icon, size: 14, color: sport.color),
                label: Text(_sportLabel(l, sport)),
                selected: selectedSport == sport,
                onSelected: (_) =>
                    onSelected(selectedSport == sport ? null : sport),
                selectedColor: sport.color.withValues(alpha: 0.2),
                checkmarkColor: sport.color,
                labelStyle: TextStyle(
                  color: selectedSport == sport
                      ? sport.color
                      : Colors.white.withValues(alpha: 0.6),
                  fontSize: 13,
                  fontWeight: selectedSport == sport
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
                backgroundColor: AppColors.cardSurface,
                side: BorderSide(
                  color: selectedSport == sport
                      ? sport.color.withValues(alpha: 0.6)
                      : AppColors.divider,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ),
        ],
      ),
    );
  }

  static String _sportLabel(S l, Sport sport) => switch (sport) {
        Sport.boxing => l.sportBoxing,
        Sport.muayThai => l.sportMuayThai,
        Sport.mma => l.sportMma,
        Sport.bjj => l.sportBjj,
        Sport.kickboxing => l.sportKickboxing,
        Sport.wrestling => l.sportWrestling,
      };
}

// ---------------------------------------------------------------------------
// Sport section: one expandable tile per sport, subcategory headers inside
// ---------------------------------------------------------------------------

class _SportSection extends StatelessWidget {
  final String sportLabel;
  final Color sportColor;
  final List<(String, List<SessionModel>)> subcategories;
  final ValueChanged<SessionModel> onSessionTap;
  final ValueChanged<SessionModel> onSessionLongPress;

  const _SportSection({
    required this.sportLabel,
    required this.sportColor,
    required this.subcategories,
    required this.onSessionTap,
    required this.onSessionLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final sessionCount =
        subcategories.fold(0, (acc, sub) => acc + sub.$2.length);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        initiallyExpanded: false,
        leading: Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: sportColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          sportLabel,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: sportColor,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w700,
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
        children: [
          for (final (subcatLabel, sessions) in subcategories) ...[
            _SubcategoryHeader(
              label: subcatLabel,
              color: sportColor,
            ),
            const SizedBox(height: 4),
            ...sessions.map(
              (session) => _SessionCard(
                session: session,
                onTap: () => onSessionTap(session),
                onLongPress: () => onSessionLongPress(session),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

/// Small header for subcategories within a sport section.
class _SubcategoryHeader extends StatelessWidget {
  final String label;
  final Color color;

  const _SubcategoryHeader({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color.withValues(alpha: 0.7),
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: color.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared section header (used for My Sessions)
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Quick Start card
// ---------------------------------------------------------------------------

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
                    if (session.comboConfig?.enabled == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.record_voice_over,
                          size: 14,
                          color: Colors.amber.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
                Text(
                  S.of(context).sessionCardQuickFormat(
                      session.rounds, totalMin),
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

// ---------------------------------------------------------------------------
// Full session card
// ---------------------------------------------------------------------------

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
                            style:
                                Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (session.comboConfig?.enabled == true)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.record_voice_over,
                              size: 16,
                              color: Colors.amber.withValues(alpha: 0.7),
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
                              DurationFormatter.formatSeconds(
                                  session.roundDurationSec),
                              DurationFormatter.formatSeconds(
                                  session.restDurationSec),
                              totalMin,
                            )
                          : S.of(context).sessionCardWorkOnly(
                              DurationFormatter.formatSeconds(
                                  session.roundDurationSec),
                              totalMin,
                            ),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
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

// ---------------------------------------------------------------------------
// In Progress card
// ---------------------------------------------------------------------------

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
                    style:
                        Theme.of(context).textTheme.labelLarge?.copyWith(
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
