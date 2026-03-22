import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boxing/features/combos/data/technique_library.dart';
import 'package:boxing/features/combos/domain/combo_model.dart';
import 'package:boxing/features/combos/presentation/combo_callout_provider.dart';

/// Displays the current combo callout as a two-line stacked display:
///   Line 1: notation at 28sp bold monospace ("1 - 2 - 3"), white
///   Line 2: full technique names at 14sp, muted white (60% opacity)
///
/// Positioned below the phase label on the timer screen. When no combo is
/// active (or during rest) the widget collapses to nothing so it has zero
/// layout impact. Transitions use a combined scale+fade animation.
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
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
      child: callout == null
          ? const SizedBox.shrink(key: ValueKey('empty'))
          : _ComboStackedDisplay(
              key: ValueKey(callout.combo.id),
              combo: callout.combo,
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Two-line stacked display
// ---------------------------------------------------------------------------

class _ComboStackedDisplay extends StatelessWidget {
  final Combo combo;

  const _ComboStackedDisplay({
    required this.combo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final techniques = TechniqueLibrary.all;

    // Line 1: notation — punch IDs as digits, others as displayText, joined by " - "
    final notation = combo.techniqueIds
        .map((id) => techniques[id]?.displayText ?? id)
        .join(' - ');

    // Line 2: full technique names from ttsText['en'] or displayText fallback
    final names = combo.techniqueIds.map((id) {
      final t = techniques[id];
      if (t == null) return id;
      // Use English TTS text for readable names; fall back to displayText
      return t.ttsText['en'] ?? t.displayText;
    }).join(', ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            notation,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            names,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
