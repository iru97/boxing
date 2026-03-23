import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:boxing/core/constants/sport.dart';
import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/core/utils/duration_formatter.dart';
import 'package:boxing/features/programs/domain/training_program.dart';
import 'package:boxing/features/programs/presentation/programs_controller.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/l10n/app_localizations.dart';

class ProgramDayScreen extends ConsumerWidget {
  final String programId;
  final String weekDay; // format: 'w1d2'

  const ProgramDayScreen({
    super.key,
    required this.programId,
    required this.weekDay,
  });

  (int, int) _parseWeekDay() {
    final match = RegExp(r'w(\d+)d(\d+)').firstMatch(weekDay);
    if (match == null) return (1, 1);
    return (int.parse(match.group(1)!), int.parse(match.group(2)!));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final program = ref.watch(programByIdProvider(programId));
    final progress = ref.watch(programProgressProvider(programId));
    final (weekNum, dayNum) = _parseWeekDay();

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
        body: Center(child: Text(s.programNotFound)),
      );
    }

    final day = program.dayAt(weekNum, dayNum);
    if (day == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(child: Text(s.programDayNotFound)),
      );
    }

    // L5: bounds-check the weeks array before indexing.
    if (weekNum < 1 || weekNum > program.weeks.length) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(child: Text(s.programDayNotFound)),
      );
    }

    final session = day.session;
    final sport = Sport.fromId(program.sport);
    final sportColor = sport?.color ?? SportColors.boxing;
    final isComplete =
        progress?.isDayComplete(weekNum, dayNum) ?? false;
    final totalMin = session.totalDuration.inMinutes;
    final week = program.weeks[weekNum - 1];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          s.programWeekDayTitle(weekNum, dayNum),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day title
            Text(
              day.name,
              style: GoogleFonts.teko(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 2,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),

            // Week context
            Text(
              s.programWeekLabel(weekNum, week.name),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: sportColor.withValues(alpha: 0.8),
                  ),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              day.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: 24),

            // Session details card
            _SessionDetailCard(
              session: session,
              sportColor: sportColor,
            ),

            const Spacer(),

            // Completion status
            if (isComplete)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle,
                        color: sportColor, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      s.programDayCompleted,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(
                            color: sportColor,
                          ),
                    ),
                  ],
                ),
              ),

            // Start button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.play_arrow, size: 24),
                label: Text(
                  isComplete ? s.programDayRepeat : s.programDayStart,
                  style: const TextStyle(fontSize: 16),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: sportColor,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(56),
                ),
                onPressed: () => _startWorkout(
                  context,
                  ref,
                  session,
                  weekNum,
                  dayNum,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Total time hint
            Center(
              child: Text(
                s.programDayTotalMin(totalMin),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _startWorkout(
    BuildContext context,
    WidgetRef ref,
    SessionModel session,
    int weekNum,
    int dayNum,
  ) {
    // Mark the day as started (ensure progress record exists)
    final controller = ref.read(programsControllerProvider);
    controller.startProgram(programId);

    // Navigate to the timer with the session as extra data.
    // The timer screen will get the session from extra since it is not
    // in the session repository (it is embedded in the program).
    context.push(
      '/timer/program',
      extra: {
        'session': session,
        'programId': programId,
        'weekNum': weekNum,
        'dayNum': dayNum,
      },
    );
  }
}

class _SessionDetailCard extends StatelessWidget {
  final SessionModel session;
  final Color sportColor;

  const _SessionDetailCard({
    required this.session,
    required this.sportColor,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final comboConfig = session.comboConfig;

    return Card(
      color: AppColors.cardSurface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.programWorkoutDetails,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: sportColor,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),

            // Grid of details
            Row(
              children: [
                Expanded(
                  child: _DetailItem(
                    label: s.programDetailRounds,
                    value: '${session.rounds}',
                  ),
                ),
                Expanded(
                  child: _DetailItem(
                    label: s.programDetailWork,
                    value: DurationFormatter.formatSeconds(
                        session.roundDurationSec),
                  ),
                ),
                Expanded(
                  child: _DetailItem(
                    label: s.programDetailRest,
                    value: DurationFormatter.formatSeconds(
                        session.restDurationSec),
                  ),
                ),
              ],
            ),

            // Combo config info
            if (comboConfig != null && comboConfig.enabled) ...[
              const SizedBox(height: 12),
              Container(
                height: 1,
                color: AppColors.divider,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.mic, size: 14, color: sportColor),
                  const SizedBox(width: 6),
                  Text(
                    s.programComboCallouts,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                          color: sportColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _ComboChip(
                    label: _localizedDifficulty(context, comboConfig.difficulty),
                    color: sportColor,
                  ),
                  const SizedBox(width: 8),
                  _ComboChip(
                    label: _localizedIntensity(context, comboConfig.intensity),
                    color: sportColor,
                  ),
                  if (comboConfig.includeDefense) ...[
                    const SizedBox(width: 8),
                    _ComboChip(
                      label: s.programComboDefense,
                      color: sportColor,
                    ),
                  ],
                  if (comboConfig.includeFootwork) ...[
                    const SizedBox(width: 8),
                    _ComboChip(
                      label: s.programComboFootwork,
                      color: sportColor,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _localizedDifficulty(BuildContext context, String d) {
    final s = S.of(context);
    return switch (d) {
      'beginner' => s.comboDifficultyBeginner,
      'intermediate' => s.comboDifficultyIntermediate,
      'advanced' => s.comboDifficultyAdvanced,
      _ => _capitalize(d),
    };
  }

  static String _localizedIntensity(BuildContext context, String i) {
    final s = S.of(context);
    return switch (i) {
      'relaxed' => s.comboIntensityRelaxed,
      'moderate' => s.comboIntensityModerate,
      'intense' => s.comboIntensityIntense,
      'hurricane' => s.comboIntensityHurricane,
      _ => _capitalize(i),
    };
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.4),
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _ComboChip extends StatelessWidget {
  final String label;
  final Color color;

  const _ComboChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontSize: 11,
            ),
      ),
    );
  }
}
