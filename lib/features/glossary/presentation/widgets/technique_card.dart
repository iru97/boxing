import 'package:flutter/material.dart';

import 'package:boxing/features/combos/domain/technique.dart';
import 'package:boxing/features/glossary/domain/technique_category_meta.dart';
import 'package:boxing/core/theme/app_colors.dart';

/// A card row for the glossary list.
///
/// Leading: category-colored icon in a small circle.
/// Title: technique display name.
/// Subtitle: first sentence of description.
/// Trailing: chevron right.
class TechniqueCard extends StatelessWidget {
  final String techniqueId;

  /// Short display name for the technique (from TechniqueLibrary ttsText).
  final String displayName;
  final TechniqueCategory category;

  /// First sentence of the description, used as subtitle.
  final String descriptionPreview;
  final VoidCallback onTap;

  const TechniqueCard({
    super.key,
    required this.techniqueId,
    required this.displayName,
    required this.category,
    required this.descriptionPreview,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final meta = TechniqueCategoryMeta.all[category]!;

    return Card(
      color: AppColors.cardSurface,
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Category icon circle
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: meta.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(meta.icon, size: 18, color: meta.color),
              ),
              const SizedBox(width: 12),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      descriptionPreview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                    ),
                  ],
                ),
              ),

              // Trailing chevron
              Icon(
                Icons.chevron_right,
                color: Colors.white.withValues(alpha: 0.3),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
