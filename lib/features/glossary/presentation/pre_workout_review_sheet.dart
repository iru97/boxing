import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:boxing/l10n/app_localizations.dart';
import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/features/combos/domain/technique.dart';
import 'package:boxing/features/combos/data/technique_library.dart';
import 'package:boxing/features/combos/data/combo_library.dart';
import 'package:boxing/features/combos/domain/combo_model.dart';
import 'package:boxing/features/glossary/domain/technique_category_meta.dart';
import 'package:boxing/features/glossary/data/technique_guide_library.dart';
import 'package:boxing/features/glossary/presentation/technique_detail_sheet.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';

/// Pre-workout modal bottom sheet showing all techniques the session will use.
///
/// Resolves techniques from the session's [ComboCalloutConfig] — sport +
/// difficulty → relevant combos → unique technique IDs. Groups them by
/// category with colored section headers. Tapping a card opens the full
/// [TechniqueDetailSheet].
///
/// Usage:
/// ```dart
/// await PreWorkoutReviewSheet.show(context, session);
/// ```
class PreWorkoutReviewSheet extends ConsumerWidget {
  final SessionModel session;

  const PreWorkoutReviewSheet({super.key, required this.session});

  /// Show the sheet. Returns a Future that resolves when it is dismissed.
  static Future<void> show(BuildContext context, SessionModel session) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => UncontrolledProviderScope(
        container: ProviderScope.containerOf(context),
        child: PreWorkoutReviewSheet(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final grouped = _resolveGroupedTechniques(session);

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          // Drag handle + title (not scrollable)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Column(
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).preWorkoutReviewSubtitle,
                  style: GoogleFonts.teko(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Scrollable list
          Expanded(
            child: grouped.isEmpty
                ? _EmptyBody()
                : ListView(
                    controller: controller,
                    padding:
                        const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    children: [
                      for (final entry in grouped.entries) ...[
                        _CategoryHeader(category: entry.key),
                        const SizedBox(height: 8),
                        for (final techniqueId in entry.value)
                          _CompactTechniqueCard(
                            techniqueId: techniqueId,
                            locale: locale,
                          ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
          ),

          // "Got it" dismiss button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brandRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    S.of(context).preWorkoutReviewDismiss,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Technique resolution logic
  // ---------------------------------------------------------------------------

  /// Returns a map of [TechniqueCategory] → ordered unique technique IDs
  /// derived from the session's combo config. Returns empty map when the
  /// session has no combo config or combos enabled is false.
  static Map<TechniqueCategory, List<String>> _resolveGroupedTechniques(
    SessionModel session,
  ) {
    final config = session.comboConfig;
    if (config == null || !config.enabled) return {};

    // Parse sport + difficulty filters from the config.
    final sport = _sportFromString(config.sport);
    final difficulty = _difficultyFromString(config.difficulty);

    // Gather all matching combos from the library.
    final matchingCombos = ComboLibrary.all.where((combo) {
      if (sport != null && combo.sport != sport) return false;
      if (difficulty != null && combo.difficulty != difficulty) return false;
      return true;
    });

    // Extract unique technique IDs preserving insertion order.
    final seen = <String>{};
    final orderedIds = <String>[];
    for (final combo in matchingCombos) {
      for (final id in combo.techniqueIds) {
        if (seen.add(id)) orderedIds.add(id);
      }
    }

    // Group by category.
    final grouped = <TechniqueCategory, List<String>>{};
    for (final id in orderedIds) {
      final technique = TechniqueLibrary.byId(id);
      if (technique == null) continue;
      grouped.putIfAbsent(technique.category, () => []).add(id);
    }

    return grouped;
  }

  static ComboSport? _sportFromString(String sport) => switch (sport) {
        'boxing' => ComboSport.boxing,
        'muayThai' => ComboSport.muayThai,
        'mma' => ComboSport.mma,
        'kickboxing' => ComboSport.kickboxing,
        'bjj' => ComboSport.bjj,
        'wrestling' => ComboSport.wrestling,
        'defense' => ComboSport.defense,
        'footwork' => ComboSport.footwork,
        _ => null,
      };

  static ComboDifficulty? _difficultyFromString(String difficulty) =>
      switch (difficulty) {
        'beginner' => ComboDifficulty.beginner,
        'intermediate' => ComboDifficulty.intermediate,
        'advanced' => ComboDifficulty.advanced,
        _ => null,
      };
}

// ---------------------------------------------------------------------------
// Category section header
// ---------------------------------------------------------------------------

class _CategoryHeader extends StatelessWidget {
  final TechniqueCategory category;
  const _CategoryHeader({required this.category});

  @override
  Widget build(BuildContext context) {
    final meta = TechniqueCategoryMeta.all[category]!;
    final label = switch (meta.labelKey) {
      'punch' => 'PUNCHES',
      'defense' => 'DEFENSE',
      'footwork' => 'FOOTWORK',
      'kick' => 'KICKS',
      'elbow' => 'ELBOWS',
      'knee' => 'KNEES',
      'grappling' => 'GRAPPLING',
      _ => meta.labelKey.toUpperCase(),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(meta.icon, size: 14, color: meta.color),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: meta.color,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              color: meta.color.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Compact technique card (smaller than full glossary card)
// ---------------------------------------------------------------------------

class _CompactTechniqueCard extends StatelessWidget {
  final String techniqueId;
  final String locale;

  const _CompactTechniqueCard({
    required this.techniqueId,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final technique = TechniqueLibrary.byId(techniqueId);
    if (technique == null) return const SizedBox.shrink();

    final meta = TechniqueCategoryMeta.all[technique.category]!;
    final displayName =
        technique.ttsText[locale] ?? technique.ttsText['en'] ?? techniqueId;
    final guide = TechniqueGuideLibrary.all[techniqueId];
    final description = guide?.description[locale] ??
        guide?.description['en'] ??
        '';
    final preview = _firstSentence(description);

    return Card(
      color: AppColors.raisedSurface,
      margin: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: () => TechniqueDetailSheet.show(context, techniqueId),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Small category icon circle
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: meta.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(meta.icon, size: 16, color: meta.color),
              ),
              const SizedBox(width: 10),

              // Name + one-liner
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                    ),
                    if (preview.isNotEmpty)
                      Text(
                        preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                      ),
                  ],
                ),
              ),

              // Tap hint
              Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _firstSentence(String text) {
    if (text.isEmpty) return '';
    final idx = text.indexOf('.');
    if (idx == -1) return text;
    return text.substring(0, idx + 1);
  }
}

// ---------------------------------------------------------------------------
// Empty body when no techniques resolved
// ---------------------------------------------------------------------------

class _EmptyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fitness_center,
                size: 40, color: Colors.white.withValues(alpha: 0.2)),
            const SizedBox(height: 12),
            Text(
              'No technique info available for this session.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
