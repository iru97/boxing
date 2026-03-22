// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Boxing Timer';

  @override
  String get appBrandName => 'BOXING';

  @override
  String get appTagline => 'TRAIN LIKE YOU FIGHT';

  @override
  String get sectionMySessionsTitle => 'My Sessions';

  @override
  String get sectionQuickStartTitle => 'Quick Start';

  @override
  String get sectionPresetsTitle => 'Presets';

  @override
  String get categoryBoxing => 'Boxing';

  @override
  String get categoryBagWork => 'Bag Work';

  @override
  String get categoryConditioning => 'Conditioning';

  @override
  String get categoryCombatSport => 'Combat Sport';

  @override
  String get categoryBeginner => 'Beginner';

  @override
  String get categoryCompound => 'Compound';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionDuplicate => 'Duplicate';

  @override
  String get actionDuplicateAsCustom => 'Duplicate as Custom';

  @override
  String get actionDelete => 'Delete';

  @override
  String get buttonCancel => 'CANCEL';

  @override
  String get buttonEnd => 'END';

  @override
  String get buttonStart => 'START';

  @override
  String get buttonSave => 'SAVE';

  @override
  String get buttonRepeat => 'REPEAT';

  @override
  String get buttonDone => 'DONE';

  @override
  String get buttonSaveExit => 'SAVE & EXIT';

  @override
  String get deleteSessionTitle => 'Delete Session?';

  @override
  String deleteSessionMessage(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String snackbarSessionCreated(String name) {
    return 'Created \"$name\"';
  }

  @override
  String snackbarSessionDeleted(String name) {
    return 'Deleted \"$name\"';
  }

  @override
  String snackbarSessionSaved(String name) {
    return 'Saved \"$name\"';
  }

  @override
  String get sessionNotFound => 'Session not found';

  @override
  String sessionCardRoundsFormat(int rounds) {
    return '${rounds}R';
  }

  @override
  String sessionCardQuickFormat(int rounds, int minutes) {
    return '${rounds}R  $minutes min';
  }

  @override
  String sessionCardWorkRest(String work, String rest, int minutes) {
    return '$work work · $rest rest · $minutes min';
  }

  @override
  String sessionCardWorkOnly(String work, int minutes) {
    return '$work work · $minutes min';
  }

  @override
  String get editSessionTitle => 'Edit Session';

  @override
  String get customizePresetTitle => 'Customize Preset';

  @override
  String get newSessionTitle => 'New Session';

  @override
  String get labelSessionName => 'Session Name';

  @override
  String get hintSessionName => 'e.g. Heavy Bag Work';

  @override
  String get validationNameRequired => 'Name is required';

  @override
  String get labelRounds => 'Rounds';

  @override
  String get labelRoundDuration => 'Round Duration';

  @override
  String get labelRestDuration => 'Rest Duration';

  @override
  String get labelRoundStructure => 'Round Structure';

  @override
  String get labelWarningTime => 'Warning Time';

  @override
  String get labelWarmup => 'Warmup';

  @override
  String get valueOff => 'Off';

  @override
  String valueSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get roundStructureSimple => 'Simple';

  @override
  String get labelAutoAdvance => 'Auto-advance';

  @override
  String get descriptionAutoAdvance =>
      'Automatically start next round after rest';

  @override
  String get labelKeepScreenOn => 'Keep Screen On';

  @override
  String get descriptionKeepScreenOn =>
      'Prevent screen from sleeping during workout';

  @override
  String get sessionSummaryTitle => 'Session Summary';

  @override
  String sessionSummaryRounds(int rounds, String duration) {
    return '$rounds rounds × $duration';
  }

  @override
  String sessionSummaryRest(String duration) {
    return ' / $duration rest';
  }

  @override
  String sessionSummaryTotal(String duration) {
    return 'Total: $duration';
  }

  @override
  String templateRepeatCount(int count, String duration) {
    return '× $count = $duration total';
  }

  @override
  String get timerScreenTitle => 'Timer';

  @override
  String get timerEndWorkoutTitle => 'End Workout?';

  @override
  String timerEndWorkoutMessage(int current, int total) {
    return 'You\'re on round $current of $total.';
  }

  @override
  String get timerStopConfirmation => 'Are you sure you want to stop?';

  @override
  String get labelWarning => 'Warning';

  @override
  String warningBeforeEnd(int seconds) {
    return '${seconds}s before end';
  }

  @override
  String get labelTotalTime => 'Total Time';

  @override
  String get labelSegmentsPerRound => 'Segments per Round';

  @override
  String totalElapsedFormat(String duration) {
    return 'Total: $duration';
  }

  @override
  String get phaseLabelReady => 'READY';

  @override
  String get phaseLabelWarmup => 'WARMUP';

  @override
  String get phaseLabelWork => 'WORK';

  @override
  String get phaseLabelRest => 'REST';

  @override
  String get phaseLabelPaused => 'PAUSED';

  @override
  String get phaseLabelComplete => 'COMPLETE';

  @override
  String get sessionCompleteTitle => 'SESSION COMPLETE';

  @override
  String sessionCompleteRounds(int rounds) {
    return '$rounds rounds completed';
  }

  @override
  String sessionCompleteTotalTime(String duration) {
    return 'Total time: $duration';
  }

  @override
  String roundIndicatorFormat(int current, int total) {
    return 'ROUND $current / $total';
  }

  @override
  String get a11yPreviousRound => 'Previous round';

  @override
  String get a11yResume => 'Resume';

  @override
  String get a11yPause => 'Pause';

  @override
  String get a11yNextRound => 'Next round';

  @override
  String a11yCountdownRemaining(int minutes, int seconds) {
    return '$minutes minutes $seconds seconds remaining';
  }

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get sectionTimerDefaults => 'Timer Defaults';

  @override
  String get labelDefaultWarmup => 'Default Warmup';

  @override
  String get labelDefaultWarning => 'Default Warning';

  @override
  String get descriptionAutoAdvanceSettings =>
      'Start next round after rest automatically';

  @override
  String get descriptionKeepScreenOnSettings =>
      'Prevent screen sleep during workout';

  @override
  String get labelResumeCountdown => 'Resume Countdown';

  @override
  String get descriptionResumeCountdown => 'Show 3-2-1 countdown when resuming';

  @override
  String get sectionAudio => 'Audio';

  @override
  String get labelDefaultSoundPack => 'Default Sound Pack';

  @override
  String get labelVolumeOverride => 'Volume Override';

  @override
  String get descriptionVolumeOverride => 'Use alarm channel for louder alerts';

  @override
  String get labelHapticFeedback => 'Haptic Feedback';

  @override
  String get descriptionHapticFeedback => 'Vibrate on round start/end';

  @override
  String get sectionDisplay => 'Display';

  @override
  String get labelTheme => 'Theme';

  @override
  String get labelLanguage => 'Language';

  @override
  String get languagePickerTitle => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get labelTapToPause => 'Tap to Pause';

  @override
  String get descriptionTapToPause => 'Tap anywhere on timer to pause/resume';

  @override
  String get sectionAbout => 'About';

  @override
  String get labelVersion => 'Version';

  @override
  String get labelLicenses => 'Licenses';

  @override
  String get soundPackClassicBell => 'Classic Bell';

  @override
  String get soundPackDigitalBuzzer => 'Digital Buzzer';

  @override
  String get soundPackMinimalBeep => 'Minimal Beep';

  @override
  String get soundPackPickerTitle => 'Sound Pack';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System';

  @override
  String get themePickerTitle => 'Theme';

  @override
  String get presetProBoxingMen => 'Pro Boxing (Men)';

  @override
  String get presetProBoxingWomen => 'Pro Boxing (Women)';

  @override
  String get presetAmateurBoxing => 'Amateur Boxing';

  @override
  String get presetAmateurWomen => 'Amateur Women';

  @override
  String get presetShadowBoxing => 'Shadow Boxing';

  @override
  String get presetHeavyBag => 'Heavy Bag';

  @override
  String get presetSpeedBag => 'Speed Bag';

  @override
  String get presetSparring => 'Sparring';

  @override
  String get presetPadWork => 'Pad Work';

  @override
  String get presetConditioning => 'Conditioning';

  @override
  String get presetTabata => 'Tabata';

  @override
  String get presetEmom => 'EMOM';

  @override
  String get presetBeginner => 'Beginner';

  @override
  String get presetYouthBoxing => 'Youth Boxing';

  @override
  String get presetMuayThai => 'Muay Thai';

  @override
  String get presetMma => 'MMA';

  @override
  String get presetKickboxing => 'Kickboxing';

  @override
  String get presetOffenseDefense => 'Offense / Defense';

  @override
  String get presetBagConditioning => 'Bag + Conditioning';

  @override
  String get presetBurnoutRounds => 'Burnout Rounds';

  @override
  String get templateOffenseDefense => 'Offense / Defense';

  @override
  String get segmentOffense => 'Offense';

  @override
  String get segmentDefense => 'Defense';

  @override
  String get templateBagConditioning => 'Bag + Conditioning';

  @override
  String get segmentBagWork => 'Bag Work';

  @override
  String get segmentConditioning => 'Conditioning';

  @override
  String get templateBurnoutFinisher => 'Burnout Finisher';

  @override
  String get segmentNormal => 'Normal';

  @override
  String get segmentHard => 'Hard';

  @override
  String get segmentAllOut => 'All-Out';

  @override
  String get templatePyramid => 'Pyramid';

  @override
  String get segmentBuild => 'Build';

  @override
  String get segmentPeak => 'Peak';

  @override
  String get segmentTaper => 'Taper';

  @override
  String get templateStationRotation => 'Station Rotation';

  @override
  String get segmentJumpRope => 'Jump Rope';

  @override
  String get segmentShadowBox => 'Shadow Box';

  @override
  String get templateModeAll => 'Same for all rounds';

  @override
  String get templateModePerRound => 'Customize per round';

  @override
  String get templateCreateCustom => 'Custom';

  @override
  String get templateEditCopy => 'Edit Copy';

  @override
  String get templateSimple => 'Simple';

  @override
  String get segmentEditorTitle => 'Round Structure';

  @override
  String get segmentEditorNameLabel => 'Structure Name';

  @override
  String get segmentEditorNameHint => 'e.g. Bag Combo';

  @override
  String get segmentEditorNameRequired => 'Name is required';

  @override
  String get segmentAdd => 'Add Segment';

  @override
  String get segmentLabelField => 'Activity';

  @override
  String get segmentDurationField => 'Duration';

  @override
  String segmentMaxReached(int max) {
    return 'Maximum $max segments';
  }

  @override
  String get segmentMinRequired => 'At least 1 segment required';

  @override
  String get repeatCountLabel => 'Repeat';

  @override
  String totalPerRound(String duration) {
    return 'Total per round: $duration';
  }

  @override
  String roundNLabel(int n) {
    return 'Round $n';
  }

  @override
  String get applyToAllRounds => 'Apply to all rounds';

  @override
  String templateSaved(String name) {
    return '\"$name\" saved';
  }

  @override
  String get changeTemplate => 'Change';

  @override
  String get historyScreenTitle => 'Training History';

  @override
  String get historyEmpty => 'No training records yet';

  @override
  String get historyEmptySubtitle => 'Complete a session to see it here';

  @override
  String get historyToday => 'Today';

  @override
  String get historyYesterday => 'Yesterday';

  @override
  String historyRecordRounds(int completed, int total) {
    return '$completed/$total rounds';
  }

  @override
  String get historyRecordCompleted => 'Completed';

  @override
  String get historyRecordStopped => 'Stopped early';

  @override
  String get historyDeleteTitle => 'Delete Record?';

  @override
  String get historyDeleteMessage => 'Remove this training record?';

  @override
  String get historyClearAllTitle => 'Clear All History?';

  @override
  String get historyClearAllMessage =>
      'This will remove all training records. This cannot be undone.';

  @override
  String get historyClearAll => 'Clear All';

  @override
  String get historyRecordDeleted => 'Record deleted';

  @override
  String get historyAllCleared => 'History cleared';

  @override
  String get settingsTrainingHistory => 'Training History';

  @override
  String get sectionData => 'Data';

  @override
  String get inProgressTitle => 'IN PROGRESS';

  @override
  String inProgressRoundFormat(int current, int total) {
    return 'Round $current/$total';
  }

  @override
  String get inProgressTimeLeft => 'left';

  @override
  String get buttonResume => 'Resume';

  @override
  String get buttonDiscard => 'Discard';

  @override
  String get discardSessionTitle => 'Discard Session?';

  @override
  String discardSessionMessage(String name) {
    return 'Discard the in-progress session \"$name\"? Your progress will be lost.';
  }

  @override
  String get sectionSubscription => 'Subscription';

  @override
  String get removeAdsTitle => 'Remove Ads';

  @override
  String get removeAdsSubtitle => 'One-time purchase to remove all ads';

  @override
  String removeAdsPrice(String price) {
    return 'Remove Ads - $price';
  }

  @override
  String get adFreeStatus => 'Ad-Free';

  @override
  String get adFreeDescription => 'Thank you for your purchase!';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get restorePurchasesDescription =>
      'Restore a previous ad removal purchase';

  @override
  String get purchaseRestored => 'Purchase restored successfully';

  @override
  String get purchaseRestoredNone => 'No previous purchases found';

  @override
  String get purchaseError => 'Purchase failed. Please try again.';

  @override
  String get purchasePending => 'Purchase pending...';

  @override
  String get sportFilterAll => 'All';

  @override
  String get sportBoxing => 'Boxing';

  @override
  String get sportMuayThai => 'Muay Thai';

  @override
  String get sportMma => 'MMA';

  @override
  String get sportBjj => 'BJJ';

  @override
  String get sportKickboxing => 'Kickboxing';

  @override
  String get sportWrestling => 'Wrestling';

  @override
  String get subcategoryCompetition => 'Competition';

  @override
  String get subcategoryTraining => 'Training';

  @override
  String get subcategoryDrills => 'Drills';

  @override
  String get subcategoryConditioning => 'Conditioning';

  @override
  String get comboSectionTitle => 'Combo Callouts';

  @override
  String get comboEnable => 'Enable combo callouts';

  @override
  String get comboEnableDescription =>
      'Coach calls out punch combinations during work phases';

  @override
  String get comboSport => 'Sport';

  @override
  String get comboSportBoxing => 'Boxing';

  @override
  String get comboSportMuayThai => 'Muay Thai';

  @override
  String get comboSportMMA => 'MMA';

  @override
  String get comboSportKickboxing => 'Kickboxing';

  @override
  String get comboDifficulty => 'Difficulty';

  @override
  String get comboDifficultyBeginner => 'Beginner';

  @override
  String get comboDifficultyIntermediate => 'Intermediate';

  @override
  String get comboDifficultyAdvanced => 'Advanced';

  @override
  String get comboIntensity => 'Intensity';

  @override
  String get comboIntensityRelaxed => 'Relaxed';

  @override
  String get comboIntensityModerate => 'Moderate';

  @override
  String get comboIntensityIntense => 'Intense';

  @override
  String get comboIntensityHurricane => 'Hurricane';

  @override
  String get comboIntensityDescription => 'How often combos are called';

  @override
  String get comboCalloutStyle => 'Callout Style';

  @override
  String get comboCalloutStyleDescription => 'How combos are spoken aloud';

  @override
  String get comboCalloutNumbers => 'Numbers';

  @override
  String get comboCalloutNames => 'Names';

  @override
  String get comboCalloutNumbersHint =>
      'Fast — \"1 2 3\" (how coaches call combos)';

  @override
  String get comboCalloutNamesHint => 'Beginner — \"Jab, Cross, Hook\"';

  @override
  String get comboIncludeDefense => 'Include defense cues';

  @override
  String get comboDefenseDescription => 'Slip, roll, block callouts';

  @override
  String get comboIncludeFootwork => 'Include footwork cues';

  @override
  String get comboFootworkDescription => 'Pivot, angle, cut the ring';

  @override
  String get comboCoachEncouragement => 'Coach encouragement';

  @override
  String get comboEncouragementDescription =>
      'Motivational cues between combos';

  @override
  String comboPoolSize(int count) {
    return '$count combos in pool';
  }

  @override
  String get comboPreviewTitle => 'Combo Pool Preview';

  @override
  String get comboSummaryLabel => 'Combo Callouts';

  @override
  String get comboPreviewButton => 'Preview Combos';

  @override
  String get comboPreviewPlaying => 'Playing...';

  @override
  String sessionCompleteCombos(int count) {
    return '$count combos';
  }

  @override
  String historyRecordCombos(int count) {
    return '$count combos';
  }

  @override
  String get progressionNudgeTitle => 'Level up?';

  @override
  String progressionNudgeMessage(int count, String level, String next) {
    return 'You\'ve completed $count sessions at $level. Ready to try $next?';
  }

  @override
  String progressionNudgeCta(String next) {
    return 'Try $next';
  }

  @override
  String get progressionNudgeDismiss => 'Not yet';
}
