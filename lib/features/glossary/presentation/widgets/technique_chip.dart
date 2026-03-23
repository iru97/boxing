import 'package:flutter/material.dart';

import 'package:boxing/features/combos/domain/technique.dart';
import 'package:boxing/features/glossary/domain/technique_category_meta.dart';

/// Small tappable chip used inline for related technique cross-references.
///
/// Category-colored background, opens detail sheet on tap.
class TechniqueChip extends StatelessWidget {
  final String label;
  final TechniqueCategory category;
  final VoidCallback onTap;

  const TechniqueChip({
    super.key,
    required this.label,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final meta = TechniqueCategoryMeta.all[category]!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: meta.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: meta.color.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(meta.icon, size: 12, color: meta.color),
            const SizedBox(width: 5),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: meta.color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
