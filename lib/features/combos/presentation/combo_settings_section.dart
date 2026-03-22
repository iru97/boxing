import 'package:flutter/material.dart';

import 'package:boxing/features/combos/data/combo_library.dart';
import 'package:boxing/features/combos/domain/combo_callout_config.dart';
import 'package:boxing/features/combos/domain/combo_model.dart';
import 'package:boxing/l10n/app_localizations.dart';

/// A section for the session editor that configures combo callouts.
///
/// Follows the same visual style as other session editor sections:
/// section title (titleMedium) + content below — no wrapping Card,
/// the surrounding ListView padding provides the spacing.
/// Collapses to a single toggle when disabled.
class ComboSettingsSection extends StatelessWidget {
  final ComboCalloutConfig config;
  final ValueChanged<ComboCalloutConfig> onChanged;

  const ComboSettingsSection({
    super.key,
    required this.config,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title — matches other sections in session_editor_screen
        Text(
          s.comboSectionTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),

        // Enable toggle
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(s.comboEnable),
          subtitle: Text(s.comboEnableDescription),
          value: config.enabled,
          onChanged: (v) => onChanged(config.copyWith(enabled: v)),
        ),

        // Expanded settings — visible only when enabled
        if (config.enabled) ...[
          const SizedBox(height: 12),
          _SportSelector(
            selected: config.sport,
            onChanged: (v) => onChanged(config.copyWith(sport: v)),
          ),
          const SizedBox(height: 16),
          _DifficultySelector(
            selected: config.difficulty,
            onChanged: (v) => onChanged(config.copyWith(difficulty: v)),
          ),
          const SizedBox(height: 16),
          _IntensitySelector(
            selected: config.intensity,
            onChanged: (v) => onChanged(config.copyWith(intensity: v)),
          ),
          const SizedBox(height: 16),
          _CalloutStyleSelector(
            selected: config.calloutStyle,
            onChanged: (v) => onChanged(config.copyWith(calloutStyle: v)),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(s.comboIncludeDefense),
            subtitle: Text(s.comboDefenseDescription),
            value: config.includeDefense,
            onChanged: (v) => onChanged(config.copyWith(includeDefense: v)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(s.comboIncludeFootwork),
            subtitle: Text(s.comboFootworkDescription),
            value: config.includeFootwork,
            onChanged: (v) => onChanged(config.copyWith(includeFootwork: v)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(s.comboCoachEncouragement),
            subtitle: Text(s.comboEncouragementDescription),
            value: config.enableCoachEncouragement,
            onChanged: (v) =>
                onChanged(config.copyWith(enableCoachEncouragement: v)),
          ),
          const SizedBox(height: 4),
          _PoolSizeIndicator(config: config),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sport selector — SegmentedButton matching _ModeToggle style in editor
// ---------------------------------------------------------------------------

class _SportSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _SportSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.comboSport, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: 'boxing', label: Text(s.comboSportBoxing)),
              ButtonSegment(value: 'muayThai', label: Text(s.comboSportMuayThai)),
              ButtonSegment(value: 'mma', label: Text(s.comboSportMMA)),
              ButtonSegment(value: 'kickboxing', label: Text(s.comboSportKickboxing)),
            ],
            selected: {selected},
            onSelectionChanged: (sel) => onChanged(sel.first),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Difficulty selector
// ---------------------------------------------------------------------------

class _DifficultySelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _DifficultySelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.comboDifficulty, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: 'beginner', label: Text(s.comboDifficultyBeginner)),
              ButtonSegment(value: 'intermediate', label: Text(s.comboDifficultyIntermediate)),
              ButtonSegment(value: 'advanced', label: Text(s.comboDifficultyAdvanced)),
            ],
            selected: {selected},
            onSelectionChanged: (sel) => onChanged(sel.first),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Intensity selector — ChoiceChips because 4 options with subtitle labels
// ---------------------------------------------------------------------------

class _IntensitySelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _IntensitySelector({
    required this.selected,
    required this.onChanged,
  });

  // Interval hints are numeric ranges — no translation needed.
  static const _intervals = {
    'relaxed': '8-12s',
    'moderate': '5-8s',
    'intense': '3-5s',
    'hurricane': '2-3s',
  };

  List<({String value, String label, String interval})> _options(S s) => [
        (value: 'relaxed', label: s.comboIntensityRelaxed, interval: _intervals['relaxed']!),
        (value: 'moderate', label: s.comboIntensityModerate, interval: _intervals['moderate']!),
        (value: 'intense', label: s.comboIntensityIntense, interval: _intervals['intense']!),
        (value: 'hurricane', label: s.comboIntensityHurricane, interval: _intervals['hurricane']!),
      ];

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.comboIntensity, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(
          s.comboIntensityDescription,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha(153),
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _options(s)
              .map(
                (opt) => ChoiceChip(
                  label: Text('${opt.label} (${opt.interval})'),
                  selected: selected == opt.value,
                  onSelected: (_) => onChanged(opt.value),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Callout style selector — numbers (fast) vs names (beginner-friendly)
// ---------------------------------------------------------------------------

class _CalloutStyleSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _CalloutStyleSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.comboCalloutStyle, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(
          s.comboCalloutStyleDescription,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha(153),
              ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: 'numbers',
                label: Text(s.comboCalloutNumbers),
                icon: const Icon(Icons.tag, size: 16),
              ),
              ButtonSegment(
                value: 'names',
                label: Text(s.comboCalloutNames),
                icon: const Icon(Icons.abc, size: 16),
              ),
            ],
            selected: {selected},
            onSelectionChanged: (sel) => onChanged(sel.first),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          selected == 'numbers'
              ? s.comboCalloutNumbersHint
              : s.comboCalloutNamesHint,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary.withAlpha(179),
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pool size indicator — shows how many combos match the current config
// ---------------------------------------------------------------------------

class _PoolSizeIndicator extends StatelessWidget {
  final ComboCalloutConfig config;

  const _PoolSizeIndicator({required this.config});

  int _poolSize() {
    final sport = ComboSport.values.firstWhere(
      (e) => e.name == config.sport,
      orElse: () => ComboSport.boxing,
    );
    final difficulty = ComboDifficulty.values.firstWhere(
      (e) => e.name == config.difficulty,
      orElse: () => ComboDifficulty.beginner,
    );

    var combos = ComboLibrary.filtered(sport: sport, difficulty: difficulty);

    if (config.includeDefense) {
      combos = [
        ...combos,
        ...ComboLibrary.forSport(ComboSport.defense),
      ];
    }
    if (config.includeFootwork) {
      combos = [
        ...combos,
        ...ComboLibrary.forSport(ComboSport.footwork),
      ];
    }

    return combos.length;
  }

  @override
  Widget build(BuildContext context) {
    final count = _poolSize();
    final hasEnough = count >= 3;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        S.of(context).comboPoolSize(count),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: hasEnough
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }
}
