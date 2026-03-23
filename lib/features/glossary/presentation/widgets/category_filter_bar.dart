import 'package:flutter/material.dart';

import 'package:boxing/features/combos/domain/technique.dart';
import 'package:boxing/features/glossary/domain/technique_category_meta.dart';
import 'package:boxing/core/theme/app_colors.dart';

/// Horizontal scrollable filter chips for technique categories.
///
/// Shows one chip per [TechniqueCategory] plus an "All" chip to clear filters.
/// Handles its own visual state based on [selectedCategory].
class CategoryFilterBar extends StatelessWidget {
  final TechniqueCategory? selectedCategory;
  final ValueChanged<TechniqueCategory?> onSelected;

  // TODO(i18n): replace hardcoded strings with S.of(context).glossaryAllCategories
  // when ARB keys are added.
  const CategoryFilterBar({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "All" chip
          _CategoryChip(
            label: 'All', // TODO(i18n): glossaryAllCategories
            color: AppColors.brandRed,
            icon: Icons.grid_view,
            isSelected: selectedCategory == null,
            onSelected: () => onSelected(null),
          ),
          const SizedBox(width: 8),

          // One chip per category
          for (final entry in TechniqueCategoryMeta.all.entries) ...[
            _CategoryChip(
              label: _categoryLabel(entry.key),
              color: entry.value.color,
              icon: entry.value.icon,
              isSelected: selectedCategory == entry.key,
              onSelected: () => onSelected(
                selectedCategory == entry.key ? null : entry.key,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  static String _categoryLabel(TechniqueCategory category) =>
      switch (category) {
        TechniqueCategory.punch => 'Punch',
        TechniqueCategory.defense => 'Defense',
        TechniqueCategory.footwork => 'Footwork',
        TechniqueCategory.kick => 'Kick',
        TechniqueCategory.elbow => 'Elbow',
        TechniqueCategory.knee => 'Knee',
        TechniqueCategory.grappling => 'Grappling',
        TechniqueCategory.other => 'Other',
      };
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onSelected;

  const _CategoryChip({
    required this.label,
    required this.color,
    required this.icon,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: Icon(icon, size: 14, color: isSelected ? color : color.withValues(alpha: 0.6)),
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: color.withValues(alpha: 0.2),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.white.withValues(alpha: 0.6),
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      backgroundColor: AppColors.cardSurface,
      side: BorderSide(
        color: isSelected
            ? color.withValues(alpha: 0.6)
            : AppColors.divider,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}
