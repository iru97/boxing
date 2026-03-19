import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:boxing/core/constants/sport.dart';
import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/features/programs/domain/training_program.dart';
import 'package:boxing/features/programs/domain/program_progress.dart';
import 'package:boxing/features/programs/presentation/programs_controller.dart';

class ProgramBrowseScreen extends ConsumerWidget {
  const ProgramBrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programs = ref.watch(allProgramsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          'Programs',
          style: GoogleFonts.teko(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: programs.length,
        itemBuilder: (context, index) {
          final program = programs[index];
          final progress =
              ref.watch(programProgressProvider(program.id));
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _ProgramCard(
              program: program,
              progress: progress,
              onTap: () => context.push('/programs/${program.id}'),
            ),
          );
        },
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final TrainingProgram program;
  final ProgramProgress? progress;
  final VoidCallback onTap;

  const _ProgramCard({
    required this.program,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sport = Sport.fromId(program.sport);
    final sportColor = sport?.color ?? SportColors.boxing;
    final completionPct =
        progress?.completionPercentage(program.totalDays) ?? 0.0;
    final hasStarted = progress != null;

    return Card(
      color: AppColors.cardSurface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color accent bar at top
            Container(
              height: 4,
              color: sportColor,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          program.name,
                          style:
                              Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      if (hasStarted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: sportColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${(completionPct * 100).round()}%',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: sportColor,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    program.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                  ),
                  const SizedBox(height: 12),

                  // Metadata chips
                  Row(
                    children: [
                      _MetaChip(
                        icon: sport?.icon ?? Icons.sports_mma,
                        label: sport?.label ?? program.sport,
                        color: sportColor,
                      ),
                      const SizedBox(width: 8),
                      _MetaChip(
                        icon: Icons.signal_cellular_alt,
                        label: _difficultyLabel(program.difficulty),
                        color: _difficultyColor(program.difficulty),
                      ),
                      const SizedBox(width: 8),
                      _MetaChip(
                        icon: Icons.calendar_today,
                        label: '${program.durationWeeks} weeks',
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 8),
                      _MetaChip(
                        icon: Icons.fitness_center,
                        label: '${program.totalDays} days',
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ],
                  ),

                  // Progress bar if started
                  if (hasStarted) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: completionPct,
                        minHeight: 4,
                        backgroundColor:
                            AppColors.divider,
                        valueColor:
                            AlwaysStoppedAnimation(sportColor),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _difficultyLabel(String difficulty) => switch (difficulty) {
        'beginner' => 'Beginner',
        'intermediate' => 'Intermediate',
        'advanced' => 'Advanced',
        _ => difficulty,
      };

  static Color _difficultyColor(String difficulty) => switch (difficulty) {
        'beginner' => const Color(0xFF4CAF50),
        'intermediate' => const Color(0xFFFF9800),
        'advanced' => const Color(0xFFF44336),
        _ => Colors.grey,
      };
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontSize: 11,
              ),
        ),
      ],
    );
  }
}
