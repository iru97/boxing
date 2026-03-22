import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:boxing/core/constants/sport.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/core/utils/duration_formatter.dart';
import 'package:boxing/features/programs/domain/training_program.dart';
import 'package:boxing/features/programs/domain/program_progress.dart';
import 'package:boxing/features/programs/presentation/programs_controller.dart';
import 'package:boxing/l10n/app_localizations.dart';

class ProgramDetailScreen extends ConsumerWidget {
  final String programId;

  const ProgramDetailScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final program = ref.watch(programByIdProvider(programId));
    final progress = ref.watch(programProgressProvider(programId));
    final controller = ref.watch(programsControllerProvider);

    if (program == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(child: Text(S.of(context).programNotFound)),
      );
    }

    final sport = Sport.fromId(program.sport);
    final sportColor = sport?.color ?? SportColors.boxing;
    final hasStarted = progress != null;
    final completionPct =
        progress?.completionPercentage(program.totalDays) ?? 0.0;
    final isComplete =
        progress?.isFullyComplete(program.totalDays) ?? false;
    final nextDay = controller.nextIncompleteDay(program, progress);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar with hero header
          SliverAppBar(
            backgroundColor: AppColors.cardSurface,
            expandedHeight: 200,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            actions: [
              if (hasStarted)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'reset') {
                      _confirmReset(context, ref, program);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'reset',
                      child: Row(
                        children: [
                          const Icon(Icons.restart_alt,
                              size: 20, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(S.of(context).programResetProgress,
                              style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      sportColor.withValues(alpha: 0.3),
                      AppColors.cardSurface,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        program.name,
                        style: GoogleFonts.teko(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 2,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _DetailChip(
                            icon: sport?.icon ?? Icons.sports_mma,
                            label: sport?.label ?? program.sport,
                            color: sportColor,
                          ),
                          const SizedBox(width: 12),
                          _DetailChip(
                            icon: Icons.signal_cellular_alt,
                            label: _difficultyLabel(
                                context, program.difficulty),
                            color: _difficultyColor(program.difficulty),
                          ),
                          const SizedBox(width: 12),
                          _DetailChip(
                            icon: Icons.calendar_today,
                            label:
                                '${program.durationWeeks} weeks  /  ${program.totalDays} days',
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                      if (hasStarted) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: completionPct,
                                  minHeight: 4,
                                  backgroundColor: AppColors.divider,
                                  valueColor: AlwaysStoppedAnimation(
                                      sportColor),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${(completionPct * 100).round()}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: sportColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Description
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                program.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
              ),
            ),
          ),

          // Week sections
          for (final week in program.weeks) ...[
            SliverToBoxAdapter(
              child: _WeekSection(
                week: week,
                program: program,
                progress: progress,
                sportColor: sportColor,
                nextDay: nextDay,
                onDayTap: (day) {
                  context.push(
                    '/programs/$programId/day/w${week.weekNumber}d${day.dayNumber}',
                  );
                },
              ),
            ),
          ],

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),

      // Bottom action button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isComplete
              ? FilledButton.icon(
                  icon: const Icon(Icons.check_circle, size: 20),
                  label: Text(S.of(context).programComplete),
                  style: FilledButton.styleFrom(
                    backgroundColor: sportColor,
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: null,
                )
              : FilledButton.icon(
                  icon: Icon(
                    hasStarted ? Icons.play_arrow : Icons.rocket_launch,
                    size: 20,
                  ),
                  label: Text(
                    hasStarted
                        ? S.of(context).programContinue(
                            nextDay?.$1 ?? 1, nextDay?.$2 ?? 1)
                        : S.of(context).programStart,
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: sportColor,
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: () async {
                    if (!hasStarted) {
                      await controller.startProgram(programId);
                    }
                    if (context.mounted && nextDay != null) {
                      context.push(
                        '/programs/$programId/day/w${nextDay.$1}d${nextDay.$2}',
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }

  void _confirmReset(
    BuildContext context,
    WidgetRef ref,
    TrainingProgram program,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(ctx).programResetTitle),
        content: Text(S.of(ctx).programResetMessage(program.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(S.of(ctx).buttonCancel),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(programsControllerProvider)
                  .resetProgress(program.id);
              Navigator.of(ctx).pop();
            },
            child: Text(
              S.of(ctx).programResetConfirm,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  static String _difficultyLabel(
          BuildContext context, String difficulty) =>
      switch (difficulty) {
        'beginner' => S.of(context).comboDifficultyBeginner,
        'intermediate' => S.of(context).comboDifficultyIntermediate,
        'advanced' => S.of(context).comboDifficultyAdvanced,
        _ => difficulty,
      };

  static Color _difficultyColor(String difficulty) => switch (difficulty) {
        'beginner' => const Color(0xFF4CAF50),
        'intermediate' => const Color(0xFFFF9800),
        'advanced' => const Color(0xFFF44336),
        _ => Colors.grey,
      };
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _DetailChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
              ),
        ),
      ],
    );
  }
}

class _WeekSection extends StatelessWidget {
  final ProgramWeek week;
  final TrainingProgram program;
  final ProgramProgress? progress;
  final Color sportColor;
  final (int, int)? nextDay;
  final ValueChanged<ProgramDay> onDayTap;

  const _WeekSection({
    required this.week,
    required this.program,
    required this.progress,
    required this.sportColor,
    required this.nextDay,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final weekComplete = week.days.every(
      (d) =>
          progress?.isDayComplete(week.weekNumber, d.dayNumber) ?? false,
    );

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        initiallyExpanded: !weekComplete &&
            (nextDay == null || nextDay!.$1 == week.weekNumber),
        leading: weekComplete
            ? Icon(Icons.check_circle, color: sportColor, size: 20)
            : Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${week.weekNumber}',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 10,
                        ),
                  ),
                ),
              ),
        title: Text(
          S.of(context).programWeekLabel(week.weekNumber, week.name),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: weekComplete
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.white,
              ),
        ),
        subtitle: Text(
          week.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.4),
              ),
        ),
        children: [
          for (final day in week.days)
            _DayTile(
              day: day,
              weekNumber: week.weekNumber,
              isComplete: progress?.isDayComplete(
                      week.weekNumber, day.dayNumber) ??
                  false,
              isNext: nextDay != null &&
                  nextDay!.$1 == week.weekNumber &&
                  nextDay!.$2 == day.dayNumber,
              sportColor: sportColor,
              onTap: () => onDayTap(day),
            ),
        ],
      ),
    );
  }
}

class _DayTile extends StatelessWidget {
  final ProgramDay day;
  final int weekNumber;
  final bool isComplete;
  final bool isNext;
  final Color sportColor;
  final VoidCallback onTap;

  const _DayTile({
    required this.day,
    required this.weekNumber,
    required this.isComplete,
    required this.isNext,
    required this.sportColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final session = day.session;
    final totalMin = session.totalDuration.inMinutes;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isNext
          ? sportColor.withValues(alpha: 0.1)
          : AppColors.raisedSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isNext
            ? BorderSide(color: sportColor.withValues(alpha: 0.4))
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Completion indicator
              if (isComplete)
                Icon(Icons.check_circle, color: sportColor, size: 24)
              else if (isNext)
                Icon(Icons.play_circle_fill,
                    color: sportColor, size: 24)
              else
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                ),
              const SizedBox(width: 12),

              // Day info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).programDayLabel(
                          day.dayNumber, day.name),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            color: isComplete
                                ? Colors.white.withValues(alpha: 0.5)
                                : Colors.white,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${session.rounds} rds x ${DurationFormatter.formatSeconds(session.roundDurationSec)}'
                      '  |  ~$totalMin min',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.chevron_right,
                color: isNext
                    ? sportColor
                    : Colors.white.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
