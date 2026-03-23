import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
// url_launcher is not in pubspec.yaml yet — video button shows a snackbar
// fallback until the package is added. TODO: add url_launcher to pubspec.yaml.

import 'package:boxing/l10n/app_localizations.dart';
import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/features/combos/data/technique_library.dart';
import 'package:boxing/features/glossary/domain/technique_category_meta.dart';
import 'package:boxing/features/glossary/presentation/glossary_providers.dart';
import 'package:boxing/features/glossary/presentation/glossary_screen.dart';
import 'package:boxing/features/glossary/presentation/widgets/form_points_list.dart';
import 'package:boxing/features/glossary/presentation/widgets/technique_chip.dart';

/// Full-detail modal bottom sheet for a single technique.
///
/// Usage:
/// ```dart
/// TechniqueDetailSheet.show(context, '1');
/// ```
///
/// Supports pushing related technique sheets on top of itself (navigation
/// stack grows naturally with [showModalBottomSheet]).
class TechniqueDetailSheet extends ConsumerWidget {
  final String techniqueId;

  const TechniqueDetailSheet({super.key, required this.techniqueId});

  /// Open the detail sheet for [techniqueId].
  static Future<void> show(BuildContext context, String techniqueId) {
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
        child: TechniqueDetailSheet(techniqueId: techniqueId),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guide = ref.watch(techniqueGuideProvider(techniqueId));
    final technique = TechniqueLibrary.byId(techniqueId);

    if (guide == null || technique == null) {
      return _NotFoundBody(techniqueId: techniqueId);
    }

    final locale = Localizations.localeOf(context).languageCode;
    final description =
        guide.description[locale] ?? guide.description['en'] ?? '';
    final formPoints =
        guide.formPoints[locale] ?? guide.formPoints['en'] ?? [];
    final meta = TechniqueCategoryMeta.all[technique.category]!;
    final displayName =
        technique.ttsText[locale] ?? technique.ttsText['en'] ?? technique.id;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          // Drag handle
          const _DragHandle(),
          const SizedBox(height: 20),

          // Hero icon or image
          _TechniqueHero(
            imageAssetPath: guide.imageAssetPath,
            meta: meta,
          ),
          const SizedBox(height: 16),

          // Technique name
          Text(
            displayName,
            style: GoogleFonts.teko(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 2,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Category badge
          Center(
            child: _CategoryBadge(meta: meta),
          ),
          const SizedBox(height: 24),

          // Description section
          if (description.isNotEmpty) ...[
            _SectionHeader(
              label: S.of(context).techniqueDetailDescription,
              color: meta.color,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 24),
          ],

          // Key points section
          if (formPoints.isNotEmpty) ...[
            _SectionHeader(
              label: S.of(context).techniqueDetailKeyPoints,
              color: meta.color,
            ),
            const SizedBox(height: 10),
            FormPointsList(points: formPoints, bulletColor: meta.color),
            const SizedBox(height: 24),
          ],

          // Related techniques section
          if (guide.relatedTechniqueIds.isNotEmpty) ...[
            _SectionHeader(
              label: S.of(context).techniqueDetailRelated,
              color: meta.color,
            ),
            const SizedBox(height: 10),
            _RelatedTechniquesRow(
              relatedIds: guide.relatedTechniqueIds,
              currentLocale: locale,
              onTap: (id) => TechniqueDetailSheet.show(context, id),
            ),
            const SizedBox(height: 24),
          ],

          // Video link
          if (guide.videoUrl != null)
            _VideoButton(videoUrl: guide.videoUrl!),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Not-found fallback
// ---------------------------------------------------------------------------

class _NotFoundBody extends StatelessWidget {
  final String techniqueId;
  const _NotFoundBody({required this.techniqueId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _DragHandle(),
          const SizedBox(height: 32),
          Icon(Icons.help_outline,
              size: 48, color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'No guide for "$techniqueId"',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Drag handle
// ---------------------------------------------------------------------------

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero image / icon placeholder
// ---------------------------------------------------------------------------

class _TechniqueHero extends StatelessWidget {
  final String? imageAssetPath;
  final TechniqueCategoryMeta meta;

  const _TechniqueHero({required this.imageAssetPath, required this.meta});

  @override
  Widget build(BuildContext context) {
    if (imageAssetPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imageAssetPath!,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: meta.color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(meta.icon, size: 40, color: meta.color),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category badge chip
// ---------------------------------------------------------------------------

class _CategoryBadge extends StatelessWidget {
  final TechniqueCategoryMeta meta;
  const _CategoryBadge({required this.meta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: meta.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: meta.color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(meta.icon, size: 14, color: meta.color),
          const SizedBox(width: 6),
          Text(
            localizedCategoryLabel(context, meta.labelKey),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: meta.color,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color color;

  const _SectionHeader({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            color: color.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Related techniques row
// ---------------------------------------------------------------------------

class _RelatedTechniquesRow extends StatelessWidget {
  final List<String> relatedIds;
  final String currentLocale;
  final ValueChanged<String> onTap;

  const _RelatedTechniquesRow({
    required this.relatedIds,
    required this.currentLocale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final id in relatedIds)
          Builder(
            builder: (context) {
              final technique = TechniqueLibrary.byId(id);
              if (technique == null) return const SizedBox.shrink();
              final label = technique.ttsText[currentLocale] ??
                  technique.ttsText['en'] ??
                  id;
              return TechniqueChip(
                label: label,
                category: technique.category,
                onTap: () => onTap(id),
              );
            },
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Video link button
// ---------------------------------------------------------------------------

class _VideoButton extends StatelessWidget {
  final String videoUrl;
  const _VideoButton({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.play_circle_outline, size: 20),
        label: Text(S.of(context).techniqueDetailWatchVideo),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white.withValues(alpha: 0.8),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          // TODO(url_launcher): once url_launcher is added to pubspec.yaml,
          // replace this with:
          //   final uri = Uri.tryParse(videoUrl);
          //   if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(videoUrl)),
          );
        },
      ),
    );
  }
}
