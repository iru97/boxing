import 'package:flutter/material.dart';

import 'package:boxing/features/combos/data/technique_library.dart';
import 'package:boxing/features/combos/domain/combo_model.dart';

/// Bottom sheet that shows all combos in the current pool.
///
/// Call [ComboPreviewSheet.show] from any widget that has a [BuildContext].
/// Combos are grouped by [ComboDifficulty] and each row shows:
///   - Display text (e.g. "1-2-3-LK")
///   - Difficulty badge (colored pill)
class ComboPreviewSheet extends StatelessWidget {
  final List<Combo> combos;

  const ComboPreviewSheet({
    super.key,
    required this.combos,
  });

  /// Opens the sheet as a modal bottom sheet.
  static void show(BuildContext context, List<Combo> combos) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ComboPreviewSheet(combos: combos),
    );
  }

  @override
  Widget build(BuildContext context) {
    final techniques = TechniqueLibrary.all;

    // Group by difficulty in display order
    final groups = <ComboDifficulty, List<Combo>>{
      ComboDifficulty.beginner: [],
      ComboDifficulty.intermediate: [],
      ComboDifficulty.advanced: [],
    };
    for (final combo in combos) {
      groups[combo.difficulty]!.add(combo);
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Drag handle
            _DragHandle(),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Text(
                    '${combos.length} combos',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Combo list grouped by difficulty
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  for (final difficulty in ComboDifficulty.values)
                    if (groups[difficulty]!.isNotEmpty) ...[
                      _DifficultyHeader(difficulty: difficulty),
                      for (final combo in groups[difficulty]!)
                        _ComboRow(
                          combo: combo,
                          displayText: combo.displayText(techniques),
                        ),
                    ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Drag handle
// ---------------------------------------------------------------------------

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(77),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Difficulty section header
// ---------------------------------------------------------------------------

class _DifficultyHeader extends StatelessWidget {
  final ComboDifficulty difficulty;

  const _DifficultyHeader({required this.difficulty});

  String _label() => switch (difficulty) {
        ComboDifficulty.beginner => 'Beginner',
        ComboDifficulty.intermediate => 'Intermediate',
        ComboDifficulty.advanced => 'Advanced',
      };

  Color _color() => switch (difficulty) {
        ComboDifficulty.beginner => const Color(0xFF1E88E5),   // blue
        ComboDifficulty.intermediate => const Color(0xFFFFB300), // amber
        ComboDifficulty.advanced => const Color(0xFFE53935),   // red
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        _label(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: _color(),
              letterSpacing: 1,
            ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single combo row
// ---------------------------------------------------------------------------

class _ComboRow extends StatelessWidget {
  final Combo combo;
  final String displayText;

  const _ComboRow({
    required this.combo,
    required this.displayText,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      minVerticalPadding: 10,
      title: Text(
        displayText,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
      ),
      subtitle: Text(
        '${combo.techniqueIds.length} techniques',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: _DifficultyBadge(difficulty: combo.difficulty),
    );
  }
}

// ---------------------------------------------------------------------------
// Difficulty badge pill
// ---------------------------------------------------------------------------

class _DifficultyBadge extends StatelessWidget {
  final ComboDifficulty difficulty;

  const _DifficultyBadge({required this.difficulty});

  String _label() => switch (difficulty) {
        ComboDifficulty.beginner => 'BEG',
        ComboDifficulty.intermediate => 'INT',
        ComboDifficulty.advanced => 'ADV',
      };

  Color _color() => switch (difficulty) {
        ComboDifficulty.beginner => const Color(0xFF1E88E5),
        ComboDifficulty.intermediate => const Color(0xFFFFB300),
        ComboDifficulty.advanced => const Color(0xFFE53935),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color().withAlpha(40),
        border: Border.all(color: _color().withAlpha(128)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _label(),
        style: TextStyle(
          color: _color(),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
