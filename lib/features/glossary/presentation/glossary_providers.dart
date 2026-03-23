import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boxing/features/combos/domain/combo_model.dart';
import 'package:boxing/features/combos/domain/technique.dart';
import 'package:boxing/features/combos/data/combo_library.dart';
import 'package:boxing/features/combos/data/technique_library.dart';
import 'package:boxing/features/glossary/data/technique_guide_library.dart';
import 'package:boxing/features/glossary/domain/technique_guide.dart';

// ---------------------------------------------------------------------------
// Filter state
// ---------------------------------------------------------------------------

/// Immutable filter state for the glossary screen.
class GlossaryFilterState {
  /// Currently selected technique categories (empty = all).
  final Set<TechniqueCategory> selectedCategories;

  /// Sport filter — only show techniques used in combos for this sport.
  /// Uses [ComboSport.name] values: 'boxing', 'muayThai', 'mma', etc.
  /// null = show all techniques regardless of sport.
  final String? selectedSport;

  /// Free-text search — matched against TTS text, descriptions, and IDs.
  final String searchQuery;

  const GlossaryFilterState({
    this.selectedCategories = const {},
    this.selectedSport,
    this.searchQuery = '',
  });

  GlossaryFilterState copyWith({
    Set<TechniqueCategory>? selectedCategories,
    String? Function()? selectedSport,
    String? searchQuery,
  }) {
    return GlossaryFilterState(
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedSport:
          selectedSport != null ? selectedSport() : this.selectedSport,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Single selected category (for filter bar UI). Null means "All".
  TechniqueCategory? get selectedCategory =>
      selectedCategories.length == 1 ? selectedCategories.first : null;

  bool get hasActiveFilters =>
      selectedCategories.isNotEmpty ||
      selectedSport != null ||
      searchQuery.isNotEmpty;
}

// ---------------------------------------------------------------------------
// Filter notifier
// ---------------------------------------------------------------------------

/// Manages glossary filter state mutations.
class GlossaryFilterNotifier extends StateNotifier<GlossaryFilterState> {
  GlossaryFilterNotifier() : super(const GlossaryFilterState());

  /// Toggle a category in/out of the selected set.
  void toggleCategory(TechniqueCategory category) {
    final updated = Set<TechniqueCategory>.from(state.selectedCategories);
    if (updated.contains(category)) {
      updated.remove(category);
    } else {
      updated.add(category);
    }
    state = state.copyWith(selectedCategories: updated);
  }

  /// Set a single category (replaces any previous selection).
  void setCategory(TechniqueCategory? category) {
    state = state.copyWith(
      selectedCategories:
          category != null ? {category} : <TechniqueCategory>{},
    );
  }

  /// Filter by sport. Pass null to clear the sport filter.
  void setSport(String? sport) {
    state = state.copyWith(selectedSport: () => sport);
  }

  /// Update the search query.
  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Reset all filters to defaults.
  void clearAll() {
    state = const GlossaryFilterState();
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// Manages filter state (categories + sport + search query).
final glossaryFilterProvider =
    StateNotifierProvider<GlossaryFilterNotifier, GlossaryFilterState>(
  (ref) => GlossaryFilterNotifier(),
);

/// Set of technique IDs used by combos for the currently selected sport.
/// Returns null when no sport filter is active (= show all techniques).
final _sportTechniqueIdsProvider = Provider<Set<String>?>((ref) {
  final sport = ref.watch(glossaryFilterProvider).selectedSport;
  if (sport == null) return null;

  final comboSport = ComboSport.values.cast<ComboSport?>().firstWhere(
        (s) => s!.name == sport,
        orElse: () => null,
      );
  if (comboSport == null) return null;

  final combos = ComboLibrary.forSport(comboSport);
  final ids = <String>{};
  for (final combo in combos) {
    ids.addAll(combo.techniqueIds);
  }
  return ids;
});

/// Filtered and sorted technique guides based on the current filter state.
///
/// Filtering:
/// 1. **Category** — if any categories selected, only matching techniques.
/// 2. **Sport** — if a sport selected, only techniques used in that sport's combos.
/// 3. **Search** — case-insensitive match against TTS text (all locales),
///    guide description (all locales), and technique ID.
///
/// Sorting: by category order first, then alphabetically by English name.
final filteredTechniqueGuidesProvider = Provider<List<TechniqueGuide>>((ref) {
  final filter = ref.watch(glossaryFilterProvider);
  final sportTechniqueIds = ref.watch(_sportTechniqueIdsProvider);

  final allGuides = TechniqueGuideLibrary.all;
  final allTechniques = TechniqueLibrary.all;

  final results = <TechniqueGuide>[];

  for (final entry in allGuides.entries) {
    final guide = entry.value;
    final technique = allTechniques[guide.techniqueId];
    if (technique == null) continue;

    // 1. Category filter
    if (filter.selectedCategories.isNotEmpty &&
        !filter.selectedCategories.contains(technique.category)) {
      continue;
    }

    // 2. Sport filter
    if (sportTechniqueIds != null &&
        !sportTechniqueIds.contains(guide.techniqueId)) {
      continue;
    }

    // 3. Search filter
    if (filter.searchQuery.isNotEmpty) {
      final query = filter.searchQuery.toLowerCase();
      final matchesTts = technique.ttsText.values
          .any((text) => text.toLowerCase().contains(query));
      final matchesDescription = guide.description.values
          .any((text) => text.toLowerCase().contains(query));
      final matchesId = guide.techniqueId.toLowerCase().contains(query);
      if (!matchesTts && !matchesDescription && !matchesId) {
        continue;
      }
    }

    results.add(guide);
  }

  // Sort: by category order, then alphabetically within category.
  results.sort((a, b) {
    final ta = allTechniques[a.techniqueId];
    final tb = allTechniques[b.techniqueId];
    if (ta == null || tb == null) return 0;
    final catCmp = ta.category.index.compareTo(tb.category.index);
    if (catCmp != 0) return catCmp;
    return (ta.ttsText['en'] ?? ta.id).compareTo(tb.ttsText['en'] ?? tb.id);
  });

  return results;
});

/// Lookup a single technique guide by ID.
final techniqueGuideProvider =
    Provider.family<TechniqueGuide?, String>((ref, techniqueId) {
  return TechniqueGuideLibrary.byId(techniqueId);
});

/// Resolve unique technique guides for every technique in a combo.
final techniquesForComboProvider =
    Provider.family<List<TechniqueGuide>, String>((ref, comboId) {
  final combo = ComboLibrary.all.where((c) => c.id == comboId).firstOrNull;
  if (combo == null) return const [];

  final guides = <TechniqueGuide>[];
  final seen = <String>{};
  for (final techId in combo.techniqueIds) {
    if (seen.contains(techId)) continue;
    seen.add(techId);
    final guide = TechniqueGuideLibrary.byId(techId);
    if (guide != null) guides.add(guide);
  }
  return guides;
});
