import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boxing/features/combos/data/technique_library.dart';
import 'package:boxing/features/combos/domain/combo_model.dart';
import 'package:boxing/features/combos/domain/technique.dart';
import 'package:boxing/features/combos/presentation/combo_callout_provider.dart';

/// Displays the current combo callout as a row of technique badges.
///
/// Positioned below the phase label on the timer screen. When no combo is
/// active (or during rest) the widget collapses to nothing so it has zero
/// layout impact.
///
/// Badge color is driven by [TechniqueCategory]:
///   punch    → green  (work phase color — offensive power)
///   defense  → amber  (warning color — reactive move)
///   footwork → blue   (movement cue)
///   kick / elbow / knee → deep orange (power strike)
///   other    → grey
class ComboDisplayWidget extends ConsumerWidget {
  const ComboDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calloutAsync = ref.watch(activeComboProvider);

    final callout = calloutAsync.when(
      data: (c) => c,
      loading: () => null,
      error: (_, __) => null,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: callout == null
          ? const SizedBox.shrink(key: ValueKey('empty'))
          : _ComboBadgeRow(
              key: ValueKey(callout.combo.id),
              combo: callout.combo,
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Badge row — resolves technique categories from the static library
// ---------------------------------------------------------------------------

class _ComboBadgeRow extends StatelessWidget {
  final Combo combo;

  const _ComboBadgeRow({
    required this.combo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final techniques = TechniqueLibrary.all;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 4,
          children: [
            for (final id in combo.techniqueIds)
              _TechniqueBadge(
                label: techniques[id]?.displayText ?? id,
                category: techniques[id]?.category ?? TechniqueCategory.other,
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single technique badge
// ---------------------------------------------------------------------------

class _TechniqueBadge extends StatelessWidget {
  final String label;
  final TechniqueCategory category;

  const _TechniqueBadge({
    required this.label,
    required this.category,
  });

  Color _badgeColor() {
    return switch (category) {
      TechniqueCategory.punch => const Color(0xFF00C853),    // green — work
      TechniqueCategory.defense => const Color(0xFFFFB300),  // amber — warning
      TechniqueCategory.footwork => const Color(0xFF1E88E5), // blue — movement
      TechniqueCategory.kick ||
      TechniqueCategory.elbow ||
      TechniqueCategory.knee => const Color(0xFFFF5722),     // deep orange
      TechniqueCategory.other => const Color(0xFF757575),    // grey
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 36, minWidth: 36),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _badgeColor(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          height: 1.1,
        ),
      ),
    );
  }
}
