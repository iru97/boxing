import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:boxing/core/constants/app_constants.dart';
import 'package:boxing/features/ads/presentation/ads_controller.dart';
import 'package:boxing/features/settings/presentation/settings_controller.dart';
import 'package:boxing/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(s.settingsScreenTitle)),
      body: ListView(
        children: [
          _SectionHeader(s.sectionTimerDefaults),

          _ChipSetting(
            title: s.labelDefaultWarmup,
            options: AppConstants.warmupOptions,
            selectedValue: settings.defaultWarmupSec,
            formatValue: (v) => v == 0 ? s.valueOff : s.valueSeconds(v),
            onSelected: (v) => notifier.updateField(
                (st) => st.copyWith(defaultWarmupSec: v)),
          ),

          _ChipSetting(
            title: s.labelDefaultWarning,
            options: AppConstants.warningTimeOptions,
            selectedValue: settings.defaultWarningSec,
            formatValue: (v) => v == 0 ? s.valueOff : s.valueSeconds(v),
            onSelected: (v) => notifier.updateField(
                (st) => st.copyWith(defaultWarningSec: v)),
          ),

          SwitchListTile(
            title: Text(s.labelAutoAdvance),
            subtitle: Text(s.descriptionAutoAdvanceSettings),
            value: settings.defaultAutoAdvance,
            onChanged: (v) => notifier.updateField(
                (st) => st.copyWith(defaultAutoAdvance: v)),
          ),

          SwitchListTile(
            title: Text(s.labelKeepScreenOn),
            subtitle: Text(s.descriptionKeepScreenOnSettings),
            value: settings.defaultKeepScreenOn,
            onChanged: (v) => notifier.updateField(
                (st) => st.copyWith(defaultKeepScreenOn: v)),
          ),

          SwitchListTile(
            title: Text(s.labelResumeCountdown),
            subtitle: Text(s.descriptionResumeCountdown),
            value: settings.resumeCountdown,
            onChanged: (v) => notifier.updateField(
                (st) => st.copyWith(resumeCountdown: v)),
          ),

          _SectionHeader(s.sectionAudio),

          ListTile(
            title: Text(s.labelDefaultSoundPack),
            subtitle: Text(_soundPackLabel(context, settings.defaultSoundPack)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSoundPackPicker(context, ref),
          ),

          SwitchListTile(
            title: Text(s.labelVolumeOverride),
            subtitle: Text(s.descriptionVolumeOverride),
            value: settings.volumeOverride,
            onChanged: (v) => notifier.updateField(
                (st) => st.copyWith(volumeOverride: v)),
          ),

          SwitchListTile(
            title: Text(s.labelHapticFeedback),
            subtitle: Text(s.descriptionHapticFeedback),
            value: settings.hapticFeedback,
            onChanged: (v) => notifier.updateField(
                (st) => st.copyWith(hapticFeedback: v)),
          ),

          _SectionHeader(s.sectionDisplay),

          ListTile(
            title: Text(s.labelTheme),
            subtitle: Text(_themeLabel(context, settings.themeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemePicker(context, ref),
          ),

          ListTile(
            title: Text(s.labelLanguage),
            subtitle: Text(_languageLabel(context, settings.locale)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguagePicker(context, ref),
          ),

          SwitchListTile(
            title: Text(s.labelTapToPause),
            subtitle: Text(s.descriptionTapToPause),
            value: settings.tapToPause,
            onChanged: (v) => notifier.updateField(
                (st) => st.copyWith(tapToPause: v)),
          ),

          _SectionHeader(s.sectionData),

          ListTile(
            leading: const Icon(Icons.history),
            title: Text(s.settingsTrainingHistory),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/history'),
          ),

          _SectionHeader(s.sectionAbout),

          ListTile(
            title: Text(s.labelVersion),
            subtitle: const Text('1.0.0'),
          ),

          ListTile(
            title: Text(s.labelLicenses),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'Boxing',
              applicationVersion: '1.0.0',
            ),
          ),

          _SectionHeader(s.sectionSubscription),

          if (!ref.watch(isAdFreeProvider))
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: Text(s.removeAdsTitle),
              subtitle: Text(s.removeAdsSubtitle),
              trailing: FilledButton(
                onPressed: () async {
                  final purchaseService = ref.read(purchaseServiceProvider);
                  await purchaseService.purchaseRemoveAds();
                },
                child: Text(
                  ref.read(purchaseServiceProvider).removeAdsProduct?.price ??
                      '\$2.99',
                ),
              ),
            )
          else
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(s.adFreeStatus),
              subtitle: Text(s.adFreeDescription),
            ),

          ListTile(
            leading: const Icon(Icons.restore),
            title: Text(s.restorePurchases),
            subtitle: Text(s.restorePurchasesDescription),
            onTap: () async {
              final purchaseService = ref.read(purchaseServiceProvider);
              await purchaseService.restorePurchases();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(s.purchaseRestored)),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String _soundPackLabel(BuildContext context, String pack) {
    final s = S.of(context);
    return switch (pack) {
      'classic_bell' => s.soundPackClassicBell,
      'digital_buzzer' => s.soundPackDigitalBuzzer,
      'minimal_beep' => s.soundPackMinimalBeep,
      _ => pack,
    };
  }

  String _themeLabel(BuildContext context, String mode) {
    final s = S.of(context);
    return switch (mode) {
      'dark' => s.themeDark,
      'light' => s.themeLight,
      'system' => s.themeSystem,
      _ => mode,
    };
  }

  String _languageLabel(BuildContext context, String locale) {
    final s = S.of(context);
    return switch (locale) {
      'en' => s.languageEnglish,
      'es' => s.languageSpanish,
      'pt' => s.languagePortuguese,
      'system' => s.languageSystem,
      _ => locale,
    };
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final notifier = ref.read(appSettingsProvider.notifier);
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(s.languagePickerTitle),
        children: [
          for (final locale in ['system', 'en', 'es', 'pt'])
            SimpleDialogOption(
              onPressed: () {
                notifier.updateField(
                    (st) => st.copyWith(locale: locale));
                Navigator.of(ctx).pop();
              },
              child: Text(_languageLabel(ctx, locale)),
            ),
        ],
      ),
    );
  }

  void _showSoundPackPicker(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final notifier = ref.read(appSettingsProvider.notifier);
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(s.soundPackPickerTitle),
        children: [
          for (final pack in ['classic_bell', 'digital_buzzer', 'minimal_beep'])
            SimpleDialogOption(
              onPressed: () {
                notifier.updateField(
                    (st) => st.copyWith(defaultSoundPack: pack));
                Navigator.of(ctx).pop();
              },
              child: Text(_soundPackLabel(ctx, pack)),
            ),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final notifier = ref.read(appSettingsProvider.notifier);
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(s.themePickerTitle),
        children: [
          for (final mode in ['dark', 'light', 'system'])
            SimpleDialogOption(
              onPressed: () {
                notifier.updateField(
                    (st) => st.copyWith(themeMode: mode));
                Navigator.of(ctx).pop();
              },
              child: Text(_themeLabel(ctx, mode)),
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
