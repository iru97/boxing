import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';

import 'package:boxing/core/constants/app_constants.dart';
import 'package:boxing/core/constants/sport.dart';
import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/core/utils/duration_formatter.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/sessions/presentation/segment_editor_sheet.dart';
import 'package:boxing/features/sessions/presentation/sessions_controller.dart';
import 'package:boxing/features/sessions/presentation/template_controller.dart';
import 'package:boxing/features/settings/presentation/settings_controller.dart';
import 'package:boxing/features/combos/domain/combo_callout_config.dart';
import 'package:boxing/features/combos/presentation/combo_settings_section.dart';
import 'package:boxing/features/entitlements/presentation/entitlement_provider.dart';
import 'package:boxing/l10n/app_localizations.dart';

class SessionEditorScreen extends ConsumerStatefulWidget {
  final String? sessionId;

  const SessionEditorScreen({super.key, this.sessionId});

  @override
  ConsumerState<SessionEditorScreen> createState() =>
      _SessionEditorScreenState();
}

class _SessionEditorScreenState extends ConsumerState<SessionEditorScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _rounds = 3;
  int _roundDurationSec = 180;
  int _restDurationSec = 60;
  int _warningTimeSec = 10;
  int _warmupDurationSec = 0;
  bool _autoAdvance = true;
  bool _keepScreenOn = true;
  bool _voiceAnnounce = false;
  bool _volumeOverride = false;
  String? _sport;
  String? _category;
  String _soundPack = 'classic_bell';
  RoundTemplate? _roundTemplate;
  Map<int, RoundTemplate> _roundTemplateOverrides = {};
  bool _perRoundMode = false;
  ComboCalloutConfig _comboConfig = const ComboCalloutConfig();
  String? _editingId;
  bool _defaultsApplied = false;
  bool _isPresetCustomize = false;

  @override
  void initState() {
    super.initState();
    if (widget.sessionId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadSession();
      });
    }
  }

  void _applySettingsDefaults() {
    if (_defaultsApplied || widget.sessionId != null) return;
    _defaultsApplied = true;
    final settings = ref.read(appSettingsProvider);
    _warningTimeSec = settings.defaultWarningSec;
    _warmupDurationSec = settings.defaultWarmupSec;
    _autoAdvance = settings.defaultAutoAdvance;
    _keepScreenOn = settings.defaultKeepScreenOn;
    _soundPack = settings.defaultSoundPack;
  }

  void _loadSession() {
    final session = ref.read(sessionByIdProvider(widget.sessionId!));
    if (session != null) {
      setState(() {
        _isPresetCustomize = session.isPreset;
        _editingId = session.isPreset ? null : session.id;
        _nameController.text = session.name;
        _rounds = session.rounds;
        _roundDurationSec = session.roundDurationSec;
        _restDurationSec = session.restDurationSec;
        _warningTimeSec = session.warningTimeSec;
        _warmupDurationSec = session.warmupDurationSec;
        _autoAdvance = session.autoAdvance;
        _keepScreenOn = session.keepScreenOn;
        _voiceAnnounce = session.voiceAnnounce;
        _volumeOverride = session.volumeOverride;
        _sport = session.sport;
        _category = session.category;
        _soundPack = session.soundPack;
        _roundTemplate = session.roundTemplate;
        _roundTemplateOverrides = Map.of(session.roundTemplateOverrides);
        _perRoundMode = session.roundTemplateOverrides.isNotEmpty;
        _comboConfig = session.comboConfig ?? const ComboCalloutConfig();
      });
    } else {
      // Session not found (deleted or invalid ID)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).sessionNotFound)),
        );
        context.go('/');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _persistTemplateIfNeeded(RoundTemplate template) {
    if (!template.isPreset) {
      ref.read(templatesControllerProvider).saveTemplate(template);
    }
  }

  int get _totalDurationSec {
    var total = _warmupDurationSec;
    if (_perRoundMode) {
      for (var i = 1; i <= _rounds; i++) {
        final tpl = _roundTemplateOverrides[i];
        total += tpl != null ? tpl.totalDurationSec : _roundDurationSec;
        if (i < _rounds) total += _restDurationSec;
      }
    } else {
      final tpl = _roundTemplate;
      final roundSec =
          tpl != null ? tpl.totalDurationSec : _roundDurationSec;
      total += _rounds * roundSec;
      if (_rounds > 1) total += (_rounds - 1) * _restDurationSec;
    }
    return total;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final session = SessionModel(
      id: _editingId ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      rounds: _rounds,
      roundDurationSec: _roundDurationSec,
      restDurationSec: _restDurationSec,
      warningTimeSec: _warningTimeSec,
      warmupDurationSec: _warmupDurationSec,
      autoAdvance: _autoAdvance,
      keepScreenOn: _keepScreenOn,
      voiceAnnounce: _voiceAnnounce,
      volumeOverride: _volumeOverride,
      sport: _sport,
      category: _category,
      soundPack: _soundPack,
      roundTemplate: _perRoundMode ? null : _roundTemplate,
      roundTemplateOverrides: _perRoundMode ? _roundTemplateOverrides : {},
      comboConfig: _comboConfig.enabled ? _comboConfig : null,
      isPreset: false,
    );

    await ref.read(sessionsControllerProvider).saveSession(session);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(S.of(context).snackbarSessionSaved(session.name))),
      );
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    _applySettingsDefaults();
    final isEditing = _editingId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing
            ? S.of(context).editSessionTitle
            : _isPresetCustomize
                ? S.of(context).customizePresetTitle
                : S.of(context).newSessionTitle),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(S.of(context).buttonSave),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: S.of(context).labelSessionName,
                hintText: S.of(context).hintSessionName,
                border: const OutlineInputBorder(),
              ),
              maxLength: 50,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return S.of(context).validationNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Sport / Category selector
            _SportCategorySelector(
              sport: _sport,
              category: _category,
              onSportChanged: (value) => setState(() {
                _sport = value;
                // Clear category when sport changes
                _category = null;
              }),
              onCategoryChanged: (value) =>
                  setState(() => _category = value),
            ),
            const SizedBox(height: 16),

            // Rounds stepper
            _StepperField(
              label: S.of(context).labelRounds,
              value: _rounds,
              min: AppConstants.minRounds,
              max: AppConstants.maxRounds,
              onChanged: (v) => setState(() {
                _rounds = v;
                // Trim overrides that are beyond the new round count
                _roundTemplateOverrides
                    .removeWhere((round, _) => round > v);
              }),
            ),
            const SizedBox(height: 16),

            // Round duration slider (hidden in per-round mode only when all
            // rounds have overrides — still useful as the default fallback)
            _DurationSlider(
              label: S.of(context).labelRoundDuration,
              valueSec: _roundDurationSec,
              minSec: AppConstants.minRoundDurationSec,
              maxSec: AppConstants.maxRoundDurationSec,
              onChanged: (v) => setState(() => _roundDurationSec = v),
            ),
            const SizedBox(height: 16),

            // Round structure section — replaces old _TemplateSelector
            _RoundStructureSection(
              rounds: _rounds,
              perRoundMode: _perRoundMode,
              selectedTemplate: _roundTemplate,
              roundOverrides: _roundTemplateOverrides,
              defaultDurationSec: _roundDurationSec,
              onModeChanged: (perRound) => setState(() {
                _perRoundMode = perRound;
                if (!perRound) _roundTemplateOverrides = {};
              }),
              onTemplateChanged: (template) => setState(() {
                _roundTemplate = template;
                if (template != null) {
                  _roundDurationSec = template.totalDurationSec;
                  _persistTemplateIfNeeded(template);
                }
              }),
              onOverrideChanged: (round, template) => setState(() {
                if (template == null) {
                  _roundTemplateOverrides.remove(round);
                } else {
                  _roundTemplateOverrides = {
                    ..._roundTemplateOverrides,
                    round: template,
                  };
                  _persistTemplateIfNeeded(template);
                }
              }),
              onApplyTemplateToAll: (template) => setState(() {
                _roundTemplate = template;
                _roundTemplateOverrides = {};
                _perRoundMode = false;
                if (template != null) {
                  _roundDurationSec = template.totalDurationSec;
                }
              }),
            ),
            const SizedBox(height: 16),

            // Rest duration slider
            _DurationSlider(
              label: S.of(context).labelRestDuration,
              valueSec: _restDurationSec,
              minSec: AppConstants.minRestDurationSec,
              maxSec: AppConstants.maxRestDurationSec,
              onChanged: (v) => setState(() => _restDurationSec = v),
            ),
            const SizedBox(height: 16),

            // Combo callout settings — placed directly after rest so users
            // see it before the less-used timing/audio options below
            ComboSettingsSection(
              config: _comboConfig,
              onChanged: (config) => setState(() => _comboConfig = config),
              hasComboAccess:
                  ref.watch(entitlementStatusProvider).hasComboAccess,
            ),
            const SizedBox(height: 16),

            // Warning time chips
            _ChipSelector(
              label: S.of(context).labelWarningTime,
              options: AppConstants.warningTimeOptions,
              selectedValue: _warningTimeSec,
              onSelected: (v) => setState(() => _warningTimeSec = v),
              formatValue: (v) => v == 0
                  ? S.of(context).valueOff
                  : S.of(context).valueSeconds(v),
            ),
            const SizedBox(height: 16),

            // Warmup chips
            _ChipSelector(
              label: S.of(context).labelWarmup,
              options: AppConstants.warmupOptions,
              selectedValue: _warmupDurationSec,
              onSelected: (v) => setState(() => _warmupDurationSec = v),
              formatValue: (v) => v == 0
                  ? S.of(context).valueOff
                  : S.of(context).valueSeconds(v),
            ),
            const SizedBox(height: 16),

            // Sound pack picker
            _SoundPackSelector(
              selectedPack: _soundPack,
              onChanged: (pack) => setState(() => _soundPack = pack),
            ),
            const SizedBox(height: 16),

            // Switches
            SwitchListTile(
              title: Text(S.of(context).labelAutoAdvance),
              subtitle: Text(S.of(context).descriptionAutoAdvance),
              value: _autoAdvance,
              onChanged: (v) => setState(() => _autoAdvance = v),
            ),
            SwitchListTile(
              title: Text(S.of(context).labelKeepScreenOn),
              subtitle: Text(S.of(context).descriptionKeepScreenOn),
              value: _keepScreenOn,
              onChanged: (v) => setState(() => _keepScreenOn = v),
            ),
            SwitchListTile(
              title: const Text('Voice Announcements'),
              subtitle: const Text('Announce round numbers by voice'),
              value: _voiceAnnounce,
              onChanged: (v) => setState(() => _voiceAnnounce = v),
            ),
            SwitchListTile(
              title: const Text('Volume Override'),
              subtitle: const Text(
                  'Use alarm channel for louder audio (ignores silent mode)'),
              value: _volumeOverride,
              onChanged: (v) => setState(() => _volumeOverride = v),
            ),

            const SizedBox(height: 24),

            // Session summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).sessionSummaryTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).sessionSummaryRounds(
                              _rounds,
                              DurationFormatter.formatSeconds(
                                  _roundDurationSec)) +
                          (_restDurationSec > 0
                              ? S.of(context).sessionSummaryRest(
                                  DurationFormatter.formatSeconds(
                                      _restDurationSec))
                              : ''),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.of(context).sessionSummaryTotal(
                          DurationFormatter.format(
                              Duration(seconds: _totalDurationSec))),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Round Structure Section
// ---------------------------------------------------------------------------

/// Encapsulates the "Round Structure" section of the session editor.
///
/// Supports two modes:
/// - **Same for all rounds** — one optional [RoundTemplate] applied globally.
/// - **Per round** — each round 1..N can have its own [RoundTemplate] or fall
///   back to "Simple" (plain countdown).
class _RoundStructureSection extends ConsumerWidget {
  final int rounds;
  final bool perRoundMode;
  final RoundTemplate? selectedTemplate;
  final Map<int, RoundTemplate> roundOverrides;
  final int defaultDurationSec;

  final ValueChanged<bool> onModeChanged;
  final ValueChanged<RoundTemplate?> onTemplateChanged;
  final void Function(int round, RoundTemplate? template) onOverrideChanged;
  final ValueChanged<RoundTemplate?> onApplyTemplateToAll;

  const _RoundStructureSection({
    required this.rounds,
    required this.perRoundMode,
    required this.selectedTemplate,
    required this.roundOverrides,
    required this.defaultDurationSec,
    required this.onModeChanged,
    required this.onTemplateChanged,
    required this.onOverrideChanged,
    required this.onApplyTemplateToAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTemplates = ref.watch(allTemplatesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text(
          S.of(context).labelRoundStructure,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        // Mode toggle — full width so it never overflows
        SizedBox(
          width: double.infinity,
          child: _ModeToggle(
            perRoundMode: perRoundMode,
            onChanged: onModeChanged,
          ),
        ),
        const SizedBox(height: 12),

        if (perRoundMode)
          _PerRoundList(
            rounds: rounds,
            roundOverrides: roundOverrides,
            allTemplates: allTemplates,
            defaultDurationSec: defaultDurationSec,
            onOverrideChanged: onOverrideChanged,
            onApplyTemplateToAll: onApplyTemplateToAll,
          )
        else
          _SameForAllPanel(
            selectedTemplate: selectedTemplate,
            allTemplates: allTemplates,
            onTemplateChanged: onTemplateChanged,
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Mode toggle
// ---------------------------------------------------------------------------

class _ModeToggle extends StatelessWidget {
  final bool perRoundMode;
  final ValueChanged<bool> onChanged;

  const _ModeToggle({
    required this.perRoundMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<bool>(
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      segments: [
        ButtonSegment(
          value: false,
          label: Text(S.of(context).templateModeAll),
        ),
        ButtonSegment(
          value: true,
          label: Text(S.of(context).templateModePerRound),
        ),
      ],
      selected: {perRoundMode},
      onSelectionChanged: (sel) => onChanged(sel.first),
      showSelectedIcon: false,
    );
  }
}

// ---------------------------------------------------------------------------
// Same-for-all panel
// ---------------------------------------------------------------------------

class _SameForAllPanel extends StatelessWidget {
  final RoundTemplate? selectedTemplate;
  final List<RoundTemplate> allTemplates;
  final ValueChanged<RoundTemplate?> onTemplateChanged;

  const _SameForAllPanel({
    required this.selectedTemplate,
    required this.allTemplates,
    required this.onTemplateChanged,
  });

  Future<void> _openCustomEditor(BuildContext context) async {
    final result = await SegmentEditorSheet.show(context);
    if (result != null) onTemplateChanged(result);
  }

  Future<void> _openEditCopy(BuildContext context) async {
    final result = await SegmentEditorSheet.show(
      context,
      template: selectedTemplate!.copyWith(
        id: const Uuid().v4(),
        isPreset: false,
      ),
    );
    if (result != null) onTemplateChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Template chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // "Simple" chip — no template
            ChoiceChip(
              label: Text(S.of(context).roundStructureSimple),
              selected: selectedTemplate == null,
              onSelected: (_) => onTemplateChanged(null),
            ),
            // Preset + custom template chips
            ...allTemplates.map((tpl) {
              final isSelected = selectedTemplate?.id == tpl.id;
              return ChoiceChip(
                label: Text(tpl.name),
                selected: isSelected,
                onSelected: (_) => onTemplateChanged(tpl),
              );
            }),
            // "+ Custom" chip
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: Text(S.of(context).templateCreateCustom),
              onPressed: () => _openCustomEditor(context),
            ),
          ],
        ),

        // Preview card for the selected template
        if (selectedTemplate != null) ...[
          const SizedBox(height: 12),
          _TemplatePreviewCard(
            template: selectedTemplate!,
            trailing: TextButton.icon(
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: Text(S.of(context).templateEditCopy),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
              onPressed: () => _openEditCopy(context),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Per-round list
// ---------------------------------------------------------------------------

class _PerRoundList extends StatelessWidget {
  final int rounds;
  final Map<int, RoundTemplate> roundOverrides;
  final List<RoundTemplate> allTemplates;
  final int defaultDurationSec;
  final void Function(int round, RoundTemplate? template) onOverrideChanged;
  final ValueChanged<RoundTemplate?> onApplyTemplateToAll;

  const _PerRoundList({
    required this.rounds,
    required this.roundOverrides,
    required this.allTemplates,
    required this.defaultDurationSec,
    required this.onOverrideChanged,
    required this.onApplyTemplateToAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Round rows
        for (int i = 1; i <= rounds; i++)
          _RoundRow(
            round: i,
            template: roundOverrides[i],
            allTemplates: allTemplates,
            defaultDurationSec: defaultDurationSec,
            onChanged: (tpl) => onOverrideChanged(i, tpl),
          ),

        const SizedBox(height: 12),

        // "Apply template to all rounds" convenience button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.copy_all_outlined, size: 18),
            label: Text(S.of(context).applyToAllRounds),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 48),
            ),
            onPressed: () => _showApplyToAllPicker(context),
          ),
        ),
      ],
    );
  }

  Future<void> _showApplyToAllPicker(BuildContext context) async {
    final picked = await _showTemplatePicker(
      context,
      allTemplates: allTemplates,
      current: null,
      title: S.of(context).applyToAllRounds,
    );
    if (picked == _kCustomSentinel) {
      if (!context.mounted) return;
      final result = await SegmentEditorSheet.show(context);
      if (result != null) onApplyTemplateToAll(result);
    } else if (picked == _kSimpleSentinel) {
      onApplyTemplateToAll(null);
    } else if (picked != null) {
      onApplyTemplateToAll(picked);
    }
  }
}

class _RoundRow extends StatelessWidget {
  final int round;
  final RoundTemplate? template;
  final List<RoundTemplate> allTemplates;
  final int defaultDurationSec;
  final ValueChanged<RoundTemplate?> onChanged;

  const _RoundRow({
    required this.round,
    required this.template,
    required this.allTemplates,
    required this.defaultDurationSec,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final label = template?.name ?? S.of(context).templateSimple;
    final durSec =
        template?.totalDurationSec ?? defaultDurationSec;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Round number badge
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.raisedSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$round',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const SizedBox(width: 12),

          // Template name + duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  DurationFormatter.formatSeconds(durSec),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                      ),
                ),
              ],
            ),
          ),

          // "Change" button — 64dp minimum tap target
          SizedBox(
            height: 48,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(48, 48),
              ),
              onPressed: () => _pickTemplate(context),
              child: Text(S.of(context).changeTemplate),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTemplate(BuildContext context) async {
    final picked = await _showTemplatePicker(
      context,
      allTemplates: allTemplates,
      current: template,
      title: S.of(context).roundNLabel(round),
    );
    if (picked == _kCustomSentinel) {
      if (!context.mounted) return;
      final result = await SegmentEditorSheet.show(context);
      if (result != null) onChanged(result);
    } else if (picked == _kSimpleSentinel) {
      onChanged(null);
    } else if (picked != null) {
      onChanged(picked);
    }
  }
}

// ---------------------------------------------------------------------------
// Template picker dialog
// ---------------------------------------------------------------------------

/// Sentinel value returned from the picker to indicate "Simple" (no template).
final _kSimpleSentinel = RoundTemplate(
  id: '__simple__',
  name: 'Simple',
  segments: const [],
);

/// Sentinel value returned from the picker to indicate "+ Custom" was tapped.
/// The caller is responsible for opening the segment editor.
final _kCustomSentinel = RoundTemplate(
  id: '__custom__',
  name: 'Custom',
  segments: const [],
);

/// Shows a dialog to pick a template (including Simple and + Custom options).
/// Returns the selected template, [_kSimpleSentinel] for "Simple", or null if
/// the user dismissed without choosing.
Future<RoundTemplate?> _showTemplatePicker(
  BuildContext context, {
  required List<RoundTemplate> allTemplates,
  required RoundTemplate? current,
  required String title,
}) {
  return showDialog<RoundTemplate>(
    context: context,
    builder: (ctx) => _TemplatePickerDialog(
      title: title,
      allTemplates: allTemplates,
      current: current,
    ),
  );
}

class _TemplatePickerDialog extends StatelessWidget {
  final String title;
  final List<RoundTemplate> allTemplates;
  final RoundTemplate? current;

  const _TemplatePickerDialog({
    required this.title,
    required this.allTemplates,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            // Simple option
            _PickerTile(
              label: S.of(context).roundStructureSimple,
              subtitle: S.of(context).roundStructureSimple,
              isSelected: current == null,
              onTap: () => Navigator.of(context).pop(_kSimpleSentinel),
            ),
            const Divider(height: 1),
            // All templates
            ...allTemplates.map((tpl) => _PickerTile(
                  label: tpl.name,
                  subtitle: DurationFormatter.formatSeconds(
                      tpl.totalDurationSec),
                  isSelected: current?.id == tpl.id,
                  onTap: () => Navigator.of(context).pop(tpl),
                )),
            // + Custom entry — pops with sentinel; caller opens segment editor
            _PickerTile(
              label: '+ ${S.of(context).templateCreateCustom}',
              subtitle: S.of(context).segmentEditorTitle,
              isSelected: false,
              onTap: () => Navigator.of(context).pop(_kCustomSentinel),
              leadingIcon: Icons.add,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.of(context).buttonCancel),
        ),
      ],
    );
  }
}

class _PickerTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? leadingIcon;

  const _PickerTile({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      minVerticalPadding: 12,
      leading: leadingIcon != null
          ? Icon(leadingIcon, size: 20)
          : isSelected
              ? const Icon(Icons.check_circle, size: 20)
              : const SizedBox(width: 20),
      title: Text(label),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}

// ---------------------------------------------------------------------------
// Template preview card (shared)
// ---------------------------------------------------------------------------

class _TemplatePreviewCard extends StatelessWidget {
  final RoundTemplate template;
  final Widget? trailing;

  const _TemplatePreviewCard({
    required this.template,
    this.trailing,
  });

  Color _colorForSegment(String color) {
    return switch (color) {
      'warning' => TimerColors.warning,
      'rest' => TimerColors.rest,
      'warmup' => TimerColors.warmup,
      _ => TimerColors.work,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Segment rows
            for (final seg in template.segments)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _colorForSegment(seg.color),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(seg.label),
                    const Spacer(),
                    Text(
                      DurationFormatter.formatSeconds(seg.durationSec),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

            // Repeat count + total
            if (template.repeatCount > 1) ...[
              const Divider(height: 16),
              Text(
                S.of(context).templateRepeatCount(
                    template.repeatCount,
                    DurationFormatter.formatSeconds(
                        template.totalDurationSec)),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],

            // Optional trailing widget (e.g. "Edit Copy" button)
            if (trailing != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: trailing!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sport / Category Selector
// ---------------------------------------------------------------------------

/// Chip-based selector for sport and training category.
///
/// Displays all [Sport] enum values as [ChoiceChip]s plus a "None" chip to
/// clear the selection. When a sport is active, a second row of category chips
/// appears below.
class _SportCategorySelector extends StatelessWidget {
  final String? sport;
  final String? category;
  final ValueChanged<String?> onSportChanged;
  final ValueChanged<String?> onCategoryChanged;

  const _SportCategorySelector({
    required this.sport,
    required this.category,
    required this.onSportChanged,
    required this.onCategoryChanged,
  });

  static const _categories = [
    ('competition', 'Competition'),
    ('training', 'Training'),
    ('drills', 'Drills'),
    ('conditioning', 'Conditioning'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeSport = Sport.fromId(sport);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sport', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),

        // Sport chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // None chip
            ChoiceChip(
              label: const Text('None'),
              selected: sport == null,
              onSelected: (_) => onSportChanged(null),
            ),
            // One chip per sport
            ...Sport.values.map((s) {
              final isSelected = sport == s.id;
              return ChoiceChip(
                avatar: Icon(
                  s.icon,
                  size: 16,
                  color: isSelected ? Colors.black : s.color,
                ),
                label: Text(s.label),
                selected: isSelected,
                selectedColor: s.color,
                onSelected: (_) => onSportChanged(s.id),
              );
            }),
          ],
        ),

        // Category chips — only shown when a sport is selected
        if (activeSport != null) ...[
          const SizedBox(height: 12),
          Text('Category', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((entry) {
              final (id, label) = entry;
              final isSelected = category == id;
              return ChoiceChip(
                label: Text(label),
                selected: isSelected,
                selectedColor: activeSport.color.withAlpha(204),
                onSelected: (_) =>
                    onCategoryChanged(isSelected ? null : id),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sound Pack Selector
// ---------------------------------------------------------------------------

/// Chip-based selector for sound pack with an inline preview button.
///
/// Three packs are available. The preview button plays `round_start.wav` from
/// the selected pack so the user can audition sounds without leaving the editor.
class _SoundPackSelector extends StatelessWidget {
  final String selectedPack;
  final ValueChanged<String> onChanged;

  const _SoundPackSelector({
    required this.selectedPack,
    required this.onChanged,
  });

  static const _packs = [
    ('classic_bell', 'Classic Bell'),
    ('digital_buzzer', 'Digital Buzzer'),
    ('minimal_beep', 'Minimal Beep'),
  ];

  Future<void> _preview() async {
    final player = AudioPlayer();
    try {
      await player.setAsset(
          'assets/sounds/$selectedPack/round_start.wav');
      await player.play();
    } finally {
      await player.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sound Pack', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Pack chips — scrollable if needed
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _packs.map((entry) {
                  final (id, label) = entry;
                  return ChoiceChip(
                    label: Text(label),
                    selected: selectedPack == id,
                    onSelected: (_) => onChanged(id),
                  );
                }).toList(),
              ),
            ),

            // Preview button — 64dp touch target
            SizedBox(
              width: 64,
              height: 64,
              child: IconButton(
                icon: const Icon(Icons.play_arrow),
                tooltip: 'Preview sound',
                iconSize: 28,
                onPressed: _preview,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared sub-widgets (unchanged from original)
// ---------------------------------------------------------------------------

/// Stepper for integer values (rounds).
class _StepperField extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _StepperField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: value > min ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 48,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}

/// Slider for duration values with 15-second increments.
class _DurationSlider extends StatelessWidget {
  final String label;
  final int valueSec;
  final int minSec;
  final int maxSec;
  final ValueChanged<int> onChanged;

  const _DurationSlider({
    required this.label,
    required this.valueSec,
    required this.minSec,
    required this.maxSec,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            Text(
              DurationFormatter.formatSeconds(valueSec),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        Slider(
          value: valueSec.toDouble(),
          min: minSec.toDouble(),
          max: maxSec.toDouble(),
          divisions: (maxSec - minSec) ~/ 15,
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }
}

/// Chip selector for predefined values.
class _ChipSelector extends StatelessWidget {
  final String label;
  final List<int> options;
  final int selectedValue;
  final ValueChanged<int> onSelected;
  final String Function(int) formatValue;

  const _ChipSelector({
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    required this.formatValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((option) {
            final isSelected = option == selectedValue;
            return ChoiceChip(
              label: Text(formatValue(option)),
              selected: isSelected,
              onSelected: (_) => onSelected(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
