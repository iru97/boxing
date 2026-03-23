import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:boxing/l10n/app_localizations.dart';
import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/features/combos/domain/technique.dart';
import 'package:boxing/features/combos/data/technique_library.dart';
import 'package:boxing/features/glossary/domain/technique_category_meta.dart';
import 'package:boxing/features/glossary/domain/technique_guide.dart';
import 'package:boxing/features/glossary/presentation/glossary_providers.dart';
import 'package:boxing/features/glossary/presentation/technique_detail_sheet.dart';
import 'package:boxing/features/glossary/presentation/widgets/category_filter_bar.dart';
import 'package:boxing/features/glossary/presentation/widgets/technique_card.dart';

/// Full-screen browse page for the Technique Glossary.
///
/// - AppBar with title and search toggle.
/// - Category filter bar (horizontal scrollable chips).
/// - ListView of technique cards grouped by category.
/// - Empty state when no results match.
class GlossaryScreen extends ConsumerStatefulWidget {
  const GlossaryScreen({super.key});

  @override
  ConsumerState<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends ConsumerState<GlossaryScreen> {
  bool _searchActive = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _searchActive = !_searchActive;
      if (!_searchActive) {
        _searchController.clear();
        ref.read(glossaryFilterProvider.notifier).setSearch('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(glossaryFilterProvider);
    final guides = ref.watch(filteredTechniqueGuidesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(
              searchActive: _searchActive,
              searchController: _searchController,
              onSearchToggle: _toggleSearch,
              onSearchChanged: (query) {
                ref
                    .read(glossaryFilterProvider.notifier)
                    .setSearch(query);
              },
            ),

            // Category filter bar
            const SizedBox(height: 8),
            CategoryFilterBar(
              selectedCategory: filterState.selectedCategory,
              onSelected: (category) {
                ref
                    .read(glossaryFilterProvider.notifier)
                    .setCategory(category);
              },
            ),
            const SizedBox(height: 8),

            // Technique list
            Expanded(
              child: guides.isEmpty
                  ? _EmptyState(
                      query: filterState.searchQuery,
                    )
                  : _TechniqueList(
                      guides: guides,
                      currentLocale:
                          Localizations.localeOf(context).languageCode,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// App bar (with collapsible search bar)
// ---------------------------------------------------------------------------

class _AppBar extends StatelessWidget {
  final bool searchActive;
  final TextEditingController searchController;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchChanged;

  const _AppBar({
    required this.searchActive,
    required this.searchController,
    required this.onSearchToggle,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: Icon(Icons.arrow_back,
                color: Colors.white.withValues(alpha: 0.7)),
            onPressed: () => Navigator.of(context).maybePop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
          ),
          const SizedBox(width: 4),

          // Title or search field
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: searchActive
                  ? TextField(
                      key: const ValueKey('search'),
                      controller: searchController,
                      autofocus: true,
                      onChanged: onSearchChanged,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: S.of(context).glossarySearchHint,
                        hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 4),
                      ),
                    )
                  : Align(
                      key: const ValueKey('title'),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).glossaryTitle,
                        style: GoogleFonts.teko(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          height: 1.1,
                        ),
                      ),
                    ),
            ),
          ),

          // Search toggle icon
          IconButton(
            icon: Icon(
              searchActive ? Icons.close : Icons.search,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            onPressed: onSearchToggle,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Technique list grouped by category
// ---------------------------------------------------------------------------

class _TechniqueList extends StatelessWidget {
  final List<TechniqueGuide> guides;
  final String currentLocale;

  const _TechniqueList({
    required this.guides,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    // Group guides by category for section headers.
    final grouped = <TechniqueCategory, List<TechniqueGuide>>{};
    for (final guide in guides) {
      final technique = TechniqueLibrary.byId(guide.techniqueId);
      if (technique == null) continue;
      grouped.putIfAbsent(technique.category, () => []).add(guide);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        for (final entry in grouped.entries) ...[
          _CategoryHeader(category: entry.key),
          const SizedBox(height: 8),
          for (final guide in entry.value)
            _GlossaryCard(
              guide: guide,
              currentLocale: currentLocale,
            ),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
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
    final label = _localizedCategoryHeader(context, meta.labelKey);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2),
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
// Individual glossary card (wraps TechniqueCard with data extraction)
// ---------------------------------------------------------------------------

class _GlossaryCard extends StatelessWidget {
  final TechniqueGuide guide;
  final String currentLocale;

  const _GlossaryCard({
    required this.guide,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final technique = TechniqueLibrary.byId(guide.techniqueId);
    if (technique == null) return const SizedBox.shrink();

    final displayName = technique.ttsText[currentLocale] ??
        technique.ttsText['en'] ??
        technique.id;
    final fullDescription =
        guide.description[currentLocale] ?? guide.description['en'] ?? '';
    final preview = _firstSentence(fullDescription);

    return TechniqueCard(
      techniqueId: guide.techniqueId,
      displayName: displayName,
      category: technique.category,
      descriptionPreview: preview,
      onTap: () => TechniqueDetailSheet.show(context, guide.techniqueId),
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
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off,
                size: 48, color: Colors.white.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text(
              query.isNotEmpty
                  ? S.of(context).glossaryEmptySearchQuery(query)
                  : S.of(context).glossaryEmptySearch,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
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

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Maps a category [labelKey] to its localized uppercase section header.
String _localizedCategoryHeader(BuildContext context, String labelKey) {
  final s = S.of(context);
  return switch (labelKey) {
    'punch' => s.glossaryCategoryPunchHeader,
    'defense' => s.glossaryCategoryDefenseHeader,
    'footwork' => s.glossaryCategoryFootworkHeader,
    'kick' => s.glossaryCategoryKickHeader,
    'elbow' => s.glossaryCategoryElbowHeader,
    'knee' => s.glossaryCategoryKneeHeader,
    'grappling' => s.glossaryCategoryGrapplingHeader,
    _ => s.glossaryCategoryOtherHeader,
  };
}

/// Maps a category [labelKey] to its localized chip label.
String localizedCategoryLabel(BuildContext context, String labelKey) {
  final s = S.of(context);
  return switch (labelKey) {
    'punch' => s.glossaryCategoryPunch,
    'defense' => s.glossaryCategoryDefense,
    'footwork' => s.glossaryCategoryFootwork,
    'kick' => s.glossaryCategoryKick,
    'elbow' => s.glossaryCategoryElbow,
    'knee' => s.glossaryCategoryKnee,
    'grappling' => s.glossaryCategoryGrappling,
    _ => s.glossaryCategoryOther,
  };
}
