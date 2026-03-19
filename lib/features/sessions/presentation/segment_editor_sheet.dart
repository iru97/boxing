import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'package:boxing/core/constants/app_constants.dart';
import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/core/utils/duration_formatter.dart';
import 'package:boxing/features/combos/domain/technique.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/l10n/app_localizations.dart';

/// Modal bottom sheet for building or editing a [RoundTemplate].
///
/// Returns the saved [RoundTemplate] via [Navigator.pop], or null on cancel.
///
/// Example usage:
/// ```dart
/// final result = await SegmentEditorSheet.show(context, template: existing);
/// if (result != null) { /* save template */ }
/// ```
class SegmentEditorSheet extends StatefulWidget {
  /// The template to edit. When null a new template is created.
  final RoundTemplate? template;

  const SegmentEditorSheet({super.key, this.template});

  /// Shows the sheet and returns the [RoundTemplate] produced, or null on
  /// cancel.
  static Future<RoundTemplate?> show(
    BuildContext context, {
    RoundTemplate? template,
  }) {
    return showModalBottomSheet<RoundTemplate>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SegmentEditorSheet(template: template),
    );
  }

  @override
  State<SegmentEditorSheet> createState() => _SegmentEditorSheetState();
}

class _SegmentEditorSheetState extends State<SegmentEditorSheet> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late List<RoundSegment> _segments;
  late int _repeatCount;

  @override
  void initState() {
    super.initState();
    final t = widget.template;
    _nameController.text = t?.name ?? '';
    _segments = t != null
        ? List<RoundSegment>.from(t.segments)
        : [_defaultSegment()];
    _repeatCount = t?.repeatCount ?? 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  RoundSegment _defaultSegment() => const RoundSegment(
        label: 'Bag Work',
        durationSec: 60,
        color: 'work',
      );

  int get _totalPerRoundSec =>
      _segments.fold(0, (acc, s) => acc + s.durationSec) * _repeatCount;

  void _addSegment() {
    if (_segments.length >= AppConstants.maxSegments) return;
    HapticFeedback.selectionClick();
    setState(() => _segments.add(_defaultSegment()));
  }

  void _removeSegment(int index) {
    if (_segments.length <= AppConstants.minSegments) return;
    HapticFeedback.selectionClick();
    setState(() => _segments.removeAt(index));
  }

  void _updateSegment(int index, RoundSegment updated) {
    setState(() => _segments[index] = updated);
  }

  void _reorderSegments(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _segments.removeAt(oldIndex);
      _segments.insert(newIndex, item);
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();
    final template = RoundTemplate(
      id: widget.template?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      segments: List.unmodifiable(_segments),
      repeatCount: _repeatCount,
      isPreset: false,
    );
    Navigator.of(context).pop(template);
  }

  void _cancel() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canAdd = _segments.length < AppConstants.maxSegments;
    // Use full height on small screens, 92% on normal screens.
    final maxHeight = MediaQuery.sizeOf(context).height *
        (MediaQuery.sizeOf(context).height < 600 ? 1.0 : 0.92);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag pill
            const _DragPill(),

            // Header row
            _SheetHeader(
              isEditing: widget.template != null,
              onClose: _cancel,
            ),

            // Scrollable body
            Flexible(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                children: [
                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: S.of(context).segmentEditorNameLabel,
                      hintText: S.of(context).segmentEditorNameHint,
                      border: const OutlineInputBorder(),
                    ),
                    maxLength: 50,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).segmentEditorNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Segments section label
                  Text(
                    S.of(context).segmentLabelField.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Reorderable list — shrinkWrapped so it sits inside ListView
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _segments.length,
                    onReorder: _reorderSegments,
                    proxyDecorator: _buildProxyDecorator,
                    itemBuilder: (ctx, index) => _SegmentRow(
                      key: ValueKey('seg_${_segments[index].hashCode}_$index'),
                      segment: _segments[index],
                      canDelete:
                          _segments.length > AppConstants.minSegments,
                      onChanged: (updated) => _updateSegment(index, updated),
                      onDelete: () => _removeSegment(index),
                    ),
                  ),

                  // Add segment button
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: canAdd ? _addSegment : null,
                      icon: const Icon(Icons.add),
                      label: Text(
                        canAdd
                            ? S.of(context).segmentAdd
                            : S.of(context).segmentMaxReached(AppConstants.maxSegments),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Repeat stepper
                  _RepeatStepper(
                    value: _repeatCount,
                    onChanged: (v) => setState(() => _repeatCount = v),
                  ),
                  const SizedBox(height: 16),

                  // Total per-round preview
                  _TotalPreview(totalSec: _totalPerRoundSec),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // Cancel / Save buttons
            _ActionBar(onCancel: _cancel, onSave: _save),
          ],
        ),
      ),
    );
  }

  Widget _buildProxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (ctx, _) => Material(
        color: Colors.transparent,
        elevation: 6,
        shadowColor: Colors.black54,
        borderRadius: BorderRadius.circular(10),
        child: child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Drag pill
// ---------------------------------------------------------------------------

class _DragPill extends StatelessWidget {
  const _DragPill();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(60),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _SheetHeader extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onClose;

  const _SheetHeader({required this.isEditing, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 4, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              S.of(context).segmentEditorTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          // 48dp touch target
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClose,
              tooltip: 'Close',
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Segment row
// ---------------------------------------------------------------------------

/// Labels surfaced in the dropdown. 'Custom...' shows a freeform text field.
const _kSegmentLabels = [
  'Bag Work',
  'Shadow Box',
  'Conditioning',
  'Sprint',
  'Jump Rope',
  'Footwork',
  'Defense',
  'Offense',
  'All-Out',
  'Custom...',
];

class _SegmentRow extends StatefulWidget {
  final RoundSegment segment;
  final bool canDelete;
  final ValueChanged<RoundSegment> onChanged;
  final VoidCallback onDelete;

  const _SegmentRow({
    super.key,
    required this.segment,
    required this.canDelete,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_SegmentRow> createState() => _SegmentRowState();
}

class _SegmentRowState extends State<_SegmentRow> {
  late bool _isCustomLabel;
  late TextEditingController _customLabelController;

  @override
  void initState() {
    super.initState();
    _isCustomLabel = !_kSegmentLabels
        .where((l) => l != 'Custom...')
        .contains(widget.segment.label);
    _customLabelController = TextEditingController(
      text: _isCustomLabel ? widget.segment.label : '',
    );
  }

  @override
  void dispose() {
    _customLabelController.dispose();
    super.dispose();
  }

  void _onDropdownChanged(String? value) {
    if (value == null) return;
    if (value == 'Custom...') {
      setState(() => _isCustomLabel = true);
    } else {
      setState(() => _isCustomLabel = false);
      widget.onChanged(widget.segment.copyWith(label: value));
    }
  }

  void _changeDuration(int delta) {
    final next = (widget.segment.durationSec + delta).clamp(
      AppConstants.minSegmentDurationSec,
      AppConstants.maxSegmentDurationSec,
    );
    if (next != widget.segment.durationSec) {
      HapticFeedback.selectionClick();
      widget.onChanged(widget.segment.copyWith(durationSec: next));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dropdownValue =
        _isCustomLabel ? 'Custom...' : widget.segment.label;

    final comboCategories = widget.segment.comboCategories ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppColors.raisedSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Drag handle — 48dp
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(
                    Icons.drag_handle,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

                // Label column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Color dot (tap to pick)
                          _ColorChip(
                            colorKey: widget.segment.color,
                            onChanged: (c) => widget.onChanged(
                              widget.segment.copyWith(color: c),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Label dropdown
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                isExpanded: true,
                                isDense: true,
                                style: theme.textTheme.bodyMedium,
                                dropdownColor: AppColors.raisedSurface,
                                items: _kSegmentLabels
                                    .map(
                                      (l) => DropdownMenuItem(
                                        value: l,
                                        child: Text(l),
                                      ),
                                    )
                                    .toList(),
                                onChanged: _onDropdownChanged,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Freeform text field shown only for custom labels
                      if (_isCustomLabel) ...[
                        const SizedBox(height: 6),
                        TextField(
                          controller: _customLabelController,
                          decoration: const InputDecoration(
                            hintText: 'Enter label',
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                          textCapitalization: TextCapitalization.words,
                          onChanged: (v) {
                            if (v.trim().isNotEmpty) {
                              widget.onChanged(
                                widget.segment.copyWith(label: v.trim()),
                              );
                            }
                          },
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 4),

                // Duration stepper (±5s)
                _DurationStepper(
                  durationSec: widget.segment.durationSec,
                  onDecrement: () => _changeDuration(-5),
                  onIncrement: () => _changeDuration(5),
                ),

                // Delete button — 48dp, disabled when only 1 segment
                SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.close,
                      color: widget.canDelete
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurface.withAlpha(50),
                    ),
                    onPressed: widget.canDelete ? widget.onDelete : null,
                    tooltip: 'Remove segment',
                  ),
                ),
              ],
            ),

            // Technique category filter
            Padding(
              padding: const EdgeInsets.only(left: 48, right: 4),
              child: _TechniqueCategoryFilter(
                selected: comboCategories,
                onChanged: (categories) {
                  widget.onChanged(widget.segment.copyWith(
                    comboCategories: categories.isEmpty ? null : categories,
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Technique category filter
// ---------------------------------------------------------------------------

/// Categories available for filtering. We exclude [TechniqueCategory.other]
/// because it has no meaningful training purpose.
const _kFilterableCategories = [
  TechniqueCategory.punch,
  TechniqueCategory.defense,
  TechniqueCategory.footwork,
  TechniqueCategory.kick,
  TechniqueCategory.elbow,
  TechniqueCategory.knee,
  TechniqueCategory.grappling,
];

class _TechniqueCategoryFilter extends StatelessWidget {
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const _TechniqueCategoryFilter({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = selected.isEmpty
        ? 'All techniques'
        : '${selected.length} ${selected.length == 1 ? 'category' : 'categories'}';

    return ExpansionTile(
      title: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 8),
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(
        Icons.filter_list,
        size: 16,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: _kFilterableCategories.map((category) {
            final name = category.name;
            final isSelected = selected.contains(name);
            return FilterChip(
              label: Text(name),
              selected: isSelected,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onSelected: (toggled) {
                final updated = List<String>.from(selected);
                if (toggled) {
                  updated.add(name);
                } else {
                  updated.remove(name);
                }
                onChanged(updated);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Color chip
// ---------------------------------------------------------------------------

/// Maps segment color keys to their display colors.
const _kColorMap = {
  'work': TimerColors.work,
  'warning': TimerColors.warning,
  'rest': TimerColors.rest,
  'warmup': TimerColors.warmup,
};

class _ColorChip extends StatelessWidget {
  final String colorKey;
  final ValueChanged<String> onChanged;

  const _ColorChip({required this.colorKey, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final color = _kColorMap[colorKey] ?? TimerColors.work;
    return Tooltip(
      message: 'Change color',
      child: GestureDetector(
        onTap: () => _showPicker(context),
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              color: Colors.white.withAlpha(70),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.raisedSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(ctx).segmentLabelField,
              style: Theme.of(ctx).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _kColorMap.entries.map((entry) {
                final isSelected = entry.key == colorKey;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onChanged(entry.key);
                    Navigator.of(ctx).pop();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: entry.value,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: entry.value.withAlpha(120),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Inline duration stepper
// ---------------------------------------------------------------------------

class _DurationStepper extends StatelessWidget {
  final int durationSec;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _DurationStepper({
    required this.durationSec,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final atMin = durationSec <= AppConstants.minSegmentDurationSec;
    final atMax = durationSec >= AppConstants.maxSegmentDurationSec;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 20,
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: atMin ? null : onDecrement,
            tooltip: '-5s',
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(
            DurationFormatter.formatSeconds(durationSec),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        ),
        SizedBox(
          width: 40,
          height: 40,
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 20,
            icon: const Icon(Icons.add_circle_outline),
            onPressed: atMax ? null : onIncrement,
            tooltip: '+5s',
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Repeat stepper
// ---------------------------------------------------------------------------

class _RepeatStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _RepeatStepper({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final atMin = value <= AppConstants.minRepeatCount;
    final atMax = value >= AppConstants.maxRepeatCount;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S.of(context).repeatCountLabel, style: theme.textTheme.titleMedium),
              Text(
                S.of(context).segmentDurationField,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        // 64dp touch targets for glove use
        SizedBox(
          width: 64,
          height: 64,
          child: IconButton(
            iconSize: 28,
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: atMin
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onChanged(value - 1);
                  },
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        SizedBox(
          width: 64,
          height: 64,
          child: IconButton(
            iconSize: 28,
            icon: const Icon(Icons.add_circle_outline),
            onPressed: atMax
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onChanged(value + 1);
                  },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Total per-round preview
// ---------------------------------------------------------------------------

class _TotalPreview extends StatelessWidget {
  final int totalSec;

  const _TotalPreview({required this.totalSec});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.raisedSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(
        S.of(context).totalPerRound(DurationFormatter.formatSeconds(totalSec)),
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action bar
// ---------------------------------------------------------------------------

class _ActionBar extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _ActionBar({required this.onCancel, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 64,
                child: OutlinedButton(
                  onPressed: onCancel,
                  child: Text(S.of(context).buttonCancel),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 64,
                child: FilledButton(
                  onPressed: onSave,
                  child: Text(S.of(context).buttonSave),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
