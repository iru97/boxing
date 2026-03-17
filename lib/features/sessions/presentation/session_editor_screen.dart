import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:boxing/core/constants/app_constants.dart';
import 'package:boxing/core/utils/duration_formatter.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/sessions/presentation/sessions_controller.dart';

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
  String? _editingId;

  @override
  void initState() {
    super.initState();
    if (widget.sessionId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadSession();
      });
    }
  }

  void _loadSession() {
    final session = ref.read(sessionByIdProvider(widget.sessionId!));
    if (session != null) {
      setState(() {
        _editingId = session.isPreset ? null : session.id;
        _nameController.text = session.name;
        _rounds = session.rounds;
        _roundDurationSec = session.roundDurationSec;
        _restDurationSec = session.restDurationSec;
        _warningTimeSec = session.warningTimeSec;
        _warmupDurationSec = session.warmupDurationSec;
        _autoAdvance = session.autoAdvance;
        _keepScreenOn = session.keepScreenOn;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  int get _totalDurationSec {
    var total = _warmupDurationSec;
    total += _rounds * _roundDurationSec;
    if (_rounds > 1) total += (_rounds - 1) * _restDurationSec;
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
      isPreset: false,
    );

    await ref.read(sessionsControllerProvider).saveSession(session);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Session' : 'New Session'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('SAVE'),
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
              decoration: const InputDecoration(
                labelText: 'Session Name',
                hintText: 'e.g. Heavy Bag Work',
                border: OutlineInputBorder(),
              ),
              maxLength: 50,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Rounds stepper
            _StepperField(
              label: 'Rounds',
              value: _rounds,
              min: AppConstants.minRounds,
              max: AppConstants.maxRounds,
              onChanged: (v) => setState(() => _rounds = v),
            ),
            const SizedBox(height: 16),

            // Round duration slider
            _DurationSlider(
              label: 'Round Duration',
              valueSec: _roundDurationSec,
              minSec: AppConstants.minRoundDurationSec,
              maxSec: AppConstants.maxRoundDurationSec,
              onChanged: (v) => setState(() => _roundDurationSec = v),
            ),
            const SizedBox(height: 16),

            // Rest duration slider
            _DurationSlider(
              label: 'Rest Duration',
              valueSec: _restDurationSec,
              minSec: AppConstants.minRestDurationSec,
              maxSec: AppConstants.maxRestDurationSec,
              onChanged: (v) => setState(() => _restDurationSec = v),
            ),
            const SizedBox(height: 16),

            // Warning time chips
            _ChipSelector(
              label: 'Warning Time',
              options: AppConstants.warningTimeOptions,
              selectedValue: _warningTimeSec,
              onSelected: (v) => setState(() => _warningTimeSec = v),
              formatValue: (v) =>
                  v == 0 ? 'Off' : '${v}s',
            ),
            const SizedBox(height: 16),

            // Warmup chips
            _ChipSelector(
              label: 'Warmup',
              options: AppConstants.warmupOptions,
              selectedValue: _warmupDurationSec,
              onSelected: (v) => setState(() => _warmupDurationSec = v),
              formatValue: (v) =>
                  v == 0 ? 'Off' : '${v}s',
            ),
            const SizedBox(height: 16),

            // Switches
            SwitchListTile(
              title: const Text('Auto-advance'),
              subtitle: const Text('Automatically start next round after rest'),
              value: _autoAdvance,
              onChanged: (v) => setState(() => _autoAdvance = v),
            ),
            SwitchListTile(
              title: const Text('Keep Screen On'),
              subtitle: const Text('Prevent screen from sleeping during workout'),
              value: _keepScreenOn,
              onChanged: (v) => setState(() => _keepScreenOn = v),
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
                      'Session Summary',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_rounds rounds × ${DurationFormatter.formatSeconds(_roundDurationSec)}'
                      '${_restDurationSec > 0 ? ' / ${DurationFormatter.formatSeconds(_restDurationSec)} rest' : ''}',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total: ${DurationFormatter.format(Duration(seconds: _totalDurationSec))}',
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
