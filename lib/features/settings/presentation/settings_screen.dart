import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boxing/core/constants/app_constants.dart';
import 'package:boxing/features/settings/presentation/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _SectionHeader('Timer Defaults'),

          _ChipSetting(
            title: 'Default Warmup',
            options: AppConstants.warmupOptions,
            selectedValue: settings.defaultWarmupSec,
            formatValue: (v) => v == 0 ? 'Off' : '${v}s',
            onSelected: (v) => notifier.updateField(
                (s) => s.copyWith(defaultWarmupSec: v)),
          ),

          _ChipSetting(
            title: 'Default Warning',
            options: AppConstants.warningTimeOptions,
            selectedValue: settings.defaultWarningSec,
            formatValue: (v) => v == 0 ? 'Off' : '${v}s',
            onSelected: (v) => notifier.updateField(
                (s) => s.copyWith(defaultWarningSec: v)),
          ),

          SwitchListTile(
            title: const Text('Auto-advance'),
            subtitle: const Text('Start next round after rest automatically'),
            value: settings.defaultAutoAdvance,
            onChanged: (v) => notifier.updateField(
                (s) => s.copyWith(defaultAutoAdvance: v)),
          ),

          SwitchListTile(
            title: const Text('Keep Screen On'),
            subtitle: const Text('Prevent screen sleep during workout'),
            value: settings.defaultKeepScreenOn,
            onChanged: (v) => notifier.updateField(
                (s) => s.copyWith(defaultKeepScreenOn: v)),
          ),

          SwitchListTile(
            title: const Text('Resume Countdown'),
            subtitle: const Text('Show 3-2-1 countdown when resuming'),
            value: settings.resumeCountdown,
            onChanged: (v) => notifier.updateField(
                (s) => s.copyWith(resumeCountdown: v)),
          ),

          _SectionHeader('Audio'),

          ListTile(
            title: const Text('Default Sound Pack'),
            subtitle: Text(_soundPackLabel(settings.defaultSoundPack)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSoundPackPicker(context, ref),
          ),

          SwitchListTile(
            title: const Text('Volume Override'),
            subtitle: const Text('Use alarm channel for louder alerts'),
            value: settings.volumeOverride,
            onChanged: (v) => notifier.updateField(
                (s) => s.copyWith(volumeOverride: v)),
          ),

          SwitchListTile(
            title: const Text('Haptic Feedback'),
            subtitle: const Text('Vibrate on round start/end'),
            value: settings.hapticFeedback,
            onChanged: (v) => notifier.updateField(
                (s) => s.copyWith(hapticFeedback: v)),
          ),

          _SectionHeader('Display'),

          ListTile(
            title: const Text('Theme'),
            subtitle: Text(_themeLabel(settings.themeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemePicker(context, ref),
          ),

          SwitchListTile(
            title: const Text('Tap to Pause'),
            subtitle: const Text('Tap anywhere on timer to pause/resume'),
            value: settings.tapToPause,
            onChanged: (v) => notifier.updateField(
                (s) => s.copyWith(tapToPause: v)),
          ),

          _SectionHeader('About'),

          const ListTile(
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),

          ListTile(
            title: const Text('Licenses'),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'Boxing',
              applicationVersion: '1.0.0',
            ),
          ),
        ],
      ),
    );
  }

  String _soundPackLabel(String pack) {
    return switch (pack) {
      'classic_bell' => 'Classic Bell',
      'digital_buzzer' => 'Digital Buzzer',
      'minimal_beep' => 'Minimal Beep',
      _ => pack,
    };
  }

  String _themeLabel(String mode) {
    return switch (mode) {
      'dark' => 'Dark',
      'light' => 'Light',
      'system' => 'System',
      _ => mode,
    };
  }

  void _showSoundPackPicker(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(appSettingsProvider.notifier);
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Sound Pack'),
        children: [
          for (final pack in ['classic_bell', 'digital_buzzer', 'minimal_beep'])
            SimpleDialogOption(
              onPressed: () {
                notifier.updateField(
                    (s) => s.copyWith(defaultSoundPack: pack));
                Navigator.of(ctx).pop();
              },
              child: Text(_soundPackLabel(pack)),
            ),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(appSettingsProvider.notifier);
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Theme'),
        children: [
          for (final mode in ['dark', 'light', 'system'])
            SimpleDialogOption(
              onPressed: () {
                notifier.updateField(
                    (s) => s.copyWith(themeMode: mode));
                Navigator.of(ctx).pop();
              },
              child: Text(_themeLabel(mode)),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

class _ChipSetting extends StatelessWidget {
  final String title;
  final List<int> options;
  final int selectedValue;
  final String Function(int) formatValue;
  final ValueChanged<int> onSelected;

  const _ChipSetting({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.formatValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Wrap(
          spacing: 8,
          children: options.map((option) {
            return ChoiceChip(
              label: Text(formatValue(option)),
              selected: option == selectedValue,
              onSelected: (_) => onSelected(option),
            );
          }).toList(),
        ),
      ),
    );
  }
}
