import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Boxing Timer'**
  String get appTitle;

  /// No description provided for @appBrandName.
  ///
  /// In en, this message translates to:
  /// **'BOXING'**
  String get appBrandName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'TRAIN LIKE YOU FIGHT'**
  String get appTagline;

  /// No description provided for @sectionMySessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Sessions'**
  String get sectionMySessionsTitle;

  /// No description provided for @sectionQuickStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get sectionQuickStartTitle;

  /// No description provided for @sectionPresetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Presets'**
  String get sectionPresetsTitle;

  /// No description provided for @categoryBoxing.
  ///
  /// In en, this message translates to:
  /// **'Boxing'**
  String get categoryBoxing;

  /// No description provided for @categoryBagWork.
  ///
  /// In en, this message translates to:
  /// **'Bag Work'**
  String get categoryBagWork;

  /// No description provided for @categoryConditioning.
  ///
  /// In en, this message translates to:
  /// **'Conditioning'**
  String get categoryConditioning;

  /// No description provided for @categoryCombatSport.
  ///
  /// In en, this message translates to:
  /// **'Combat Sport'**
  String get categoryCombatSport;

  /// No description provided for @categoryBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get categoryBeginner;

  /// No description provided for @categoryCompound.
  ///
  /// In en, this message translates to:
  /// **'Compound'**
  String get categoryCompound;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get actionDuplicate;

  /// No description provided for @actionDuplicateAsCustom.
  ///
  /// In en, this message translates to:
  /// **'Duplicate as Custom'**
  String get actionDuplicateAsCustom;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @buttonCancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get buttonCancel;

  /// No description provided for @buttonEnd.
  ///
  /// In en, this message translates to:
  /// **'END'**
  String get buttonEnd;

  /// No description provided for @buttonStart.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get buttonStart;

  /// No description provided for @buttonSave.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get buttonSave;

  /// No description provided for @buttonRepeat.
  ///
  /// In en, this message translates to:
  /// **'REPEAT'**
  String get buttonRepeat;

  /// No description provided for @buttonDone.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get buttonDone;

  /// No description provided for @buttonSaveExit.
  ///
  /// In en, this message translates to:
  /// **'SAVE & EXIT'**
  String get buttonSaveExit;

  /// No description provided for @deleteSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Session?'**
  String get deleteSessionTitle;

  /// No description provided for @deleteSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This cannot be undone.'**
  String deleteSessionMessage(String name);

  /// No description provided for @snackbarSessionCreated.
  ///
  /// In en, this message translates to:
  /// **'Created \"{name}\"'**
  String snackbarSessionCreated(String name);

  /// No description provided for @snackbarSessionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted \"{name}\"'**
  String snackbarSessionDeleted(String name);

  /// No description provided for @snackbarSessionSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved \"{name}\"'**
  String snackbarSessionSaved(String name);

  /// No description provided for @sessionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Session not found'**
  String get sessionNotFound;

  /// No description provided for @sessionCardRoundsFormat.
  ///
  /// In en, this message translates to:
  /// **'{rounds}R'**
  String sessionCardRoundsFormat(int rounds);

  /// No description provided for @sessionCardQuickFormat.
  ///
  /// In en, this message translates to:
  /// **'{rounds}R  {minutes} min'**
  String sessionCardQuickFormat(int rounds, int minutes);

  /// No description provided for @sessionCardWorkRest.
  ///
  /// In en, this message translates to:
  /// **'{work} work · {rest} rest · {minutes} min'**
  String sessionCardWorkRest(String work, String rest, int minutes);

  /// No description provided for @sessionCardWorkOnly.
  ///
  /// In en, this message translates to:
  /// **'{work} work · {minutes} min'**
  String sessionCardWorkOnly(String work, int minutes);

  /// No description provided for @editSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Session'**
  String get editSessionTitle;

  /// No description provided for @customizePresetTitle.
  ///
  /// In en, this message translates to:
  /// **'Customize Preset'**
  String get customizePresetTitle;

  /// No description provided for @newSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'New Session'**
  String get newSessionTitle;

  /// No description provided for @labelSessionName.
  ///
  /// In en, this message translates to:
  /// **'Session Name'**
  String get labelSessionName;

  /// No description provided for @hintSessionName.
  ///
  /// In en, this message translates to:
  /// **'e.g. Heavy Bag Work'**
  String get hintSessionName;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get validationNameRequired;

  /// No description provided for @labelRounds.
  ///
  /// In en, this message translates to:
  /// **'Rounds'**
  String get labelRounds;

  /// No description provided for @labelRoundDuration.
  ///
  /// In en, this message translates to:
  /// **'Round Duration'**
  String get labelRoundDuration;

  /// No description provided for @labelRestDuration.
  ///
  /// In en, this message translates to:
  /// **'Rest Duration'**
  String get labelRestDuration;

  /// No description provided for @labelRoundStructure.
  ///
  /// In en, this message translates to:
  /// **'Round Structure'**
  String get labelRoundStructure;

  /// No description provided for @labelWarningTime.
  ///
  /// In en, this message translates to:
  /// **'Warning Time'**
  String get labelWarningTime;

  /// No description provided for @labelWarmup.
  ///
  /// In en, this message translates to:
  /// **'Warmup'**
  String get labelWarmup;

  /// No description provided for @valueOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get valueOff;

  /// No description provided for @valueSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String valueSeconds(int seconds);

  /// No description provided for @roundStructureSimple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get roundStructureSimple;

  /// No description provided for @labelAutoAdvance.
  ///
  /// In en, this message translates to:
  /// **'Auto-advance'**
  String get labelAutoAdvance;

  /// No description provided for @descriptionAutoAdvance.
  ///
  /// In en, this message translates to:
  /// **'Automatically start next round after rest'**
  String get descriptionAutoAdvance;

  /// No description provided for @labelKeepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Keep Screen On'**
  String get labelKeepScreenOn;

  /// No description provided for @descriptionKeepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Prevent screen from sleeping during workout'**
  String get descriptionKeepScreenOn;

  /// No description provided for @sessionSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Summary'**
  String get sessionSummaryTitle;

  /// No description provided for @sessionSummaryRounds.
  ///
  /// In en, this message translates to:
  /// **'{rounds} rounds × {duration}'**
  String sessionSummaryRounds(int rounds, String duration);

  /// No description provided for @sessionSummaryRest.
  ///
  /// In en, this message translates to:
  /// **' / {duration} rest'**
  String sessionSummaryRest(String duration);

  /// No description provided for @sessionSummaryTotal.
  ///
  /// In en, this message translates to:
  /// **'Total: {duration}'**
  String sessionSummaryTotal(String duration);

  /// No description provided for @templateRepeatCount.
  ///
  /// In en, this message translates to:
  /// **'× {count} = {duration} total'**
  String templateRepeatCount(int count, String duration);

  /// No description provided for @timerScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timerScreenTitle;

  /// No description provided for @timerEndWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'End Workout?'**
  String get timerEndWorkoutTitle;

  /// No description provided for @timerEndWorkoutMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re on round {current} of {total}.'**
  String timerEndWorkoutMessage(int current, int total);

  /// No description provided for @timerStopConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to stop?'**
  String get timerStopConfirmation;

  /// No description provided for @labelWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get labelWarning;

  /// No description provided for @warningBeforeEnd.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s before end'**
  String warningBeforeEnd(int seconds);

  /// No description provided for @labelTotalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get labelTotalTime;

  /// No description provided for @labelSegmentsPerRound.
  ///
  /// In en, this message translates to:
  /// **'Segments per Round'**
  String get labelSegmentsPerRound;

  /// No description provided for @totalElapsedFormat.
  ///
  /// In en, this message translates to:
  /// **'Total: {duration}'**
  String totalElapsedFormat(String duration);

  /// No description provided for @phaseLabelReady.
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get phaseLabelReady;

  /// No description provided for @phaseLabelWarmup.
  ///
  /// In en, this message translates to:
  /// **'WARMUP'**
  String get phaseLabelWarmup;

  /// No description provided for @phaseLabelWork.
  ///
  /// In en, this message translates to:
  /// **'WORK'**
  String get phaseLabelWork;

  /// No description provided for @phaseLabelRest.
  ///
  /// In en, this message translates to:
  /// **'REST'**
  String get phaseLabelRest;

  /// No description provided for @phaseLabelPaused.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get phaseLabelPaused;

  /// No description provided for @phaseLabelComplete.
  ///
  /// In en, this message translates to:
  /// **'COMPLETE'**
  String get phaseLabelComplete;

  /// No description provided for @sessionCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'SESSION COMPLETE'**
  String get sessionCompleteTitle;

  /// No description provided for @sessionCompleteRounds.
  ///
  /// In en, this message translates to:
  /// **'{rounds} rounds completed'**
  String sessionCompleteRounds(int rounds);

  /// No description provided for @sessionCompleteTotalTime.
  ///
  /// In en, this message translates to:
  /// **'Total time: {duration}'**
  String sessionCompleteTotalTime(String duration);

  /// No description provided for @roundIndicatorFormat.
  ///
  /// In en, this message translates to:
  /// **'ROUND {current} / {total}'**
  String roundIndicatorFormat(int current, int total);

  /// No description provided for @a11yPreviousRound.
  ///
  /// In en, this message translates to:
  /// **'Previous round'**
  String get a11yPreviousRound;

  /// No description provided for @a11yResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get a11yResume;

  /// No description provided for @a11yPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get a11yPause;

  /// No description provided for @a11yNextRound.
  ///
  /// In en, this message translates to:
  /// **'Next round'**
  String get a11yNextRound;

  /// No description provided for @a11yCountdownRemaining.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes {seconds} seconds remaining'**
  String a11yCountdownRemaining(int minutes, int seconds);

  /// No description provided for @settingsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsScreenTitle;

  /// No description provided for @sectionTimerDefaults.
  ///
  /// In en, this message translates to:
  /// **'Timer Defaults'**
  String get sectionTimerDefaults;

  /// No description provided for @labelDefaultWarmup.
  ///
  /// In en, this message translates to:
  /// **'Default Warmup'**
  String get labelDefaultWarmup;

  /// No description provided for @labelDefaultWarning.
  ///
  /// In en, this message translates to:
  /// **'Default Warning'**
  String get labelDefaultWarning;

  /// No description provided for @descriptionAutoAdvanceSettings.
  ///
  /// In en, this message translates to:
  /// **'Start next round after rest automatically'**
  String get descriptionAutoAdvanceSettings;

  /// No description provided for @descriptionKeepScreenOnSettings.
  ///
  /// In en, this message translates to:
  /// **'Prevent screen sleep during workout'**
  String get descriptionKeepScreenOnSettings;

  /// No description provided for @labelResumeCountdown.
  ///
  /// In en, this message translates to:
  /// **'Resume Countdown'**
  String get labelResumeCountdown;

  /// No description provided for @descriptionResumeCountdown.
  ///
  /// In en, this message translates to:
  /// **'Show 3-2-1 countdown when resuming'**
  String get descriptionResumeCountdown;

  /// No description provided for @sectionAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get sectionAudio;

  /// No description provided for @labelDefaultSoundPack.
  ///
  /// In en, this message translates to:
  /// **'Default Sound Pack'**
  String get labelDefaultSoundPack;

  /// No description provided for @labelVolumeOverride.
  ///
  /// In en, this message translates to:
  /// **'Volume Override'**
  String get labelVolumeOverride;

  /// No description provided for @descriptionVolumeOverride.
  ///
  /// In en, this message translates to:
  /// **'Use alarm channel for louder alerts'**
  String get descriptionVolumeOverride;

  /// No description provided for @labelHapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get labelHapticFeedback;

  /// No description provided for @descriptionHapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Vibrate on round start/end'**
  String get descriptionHapticFeedback;

  /// No description provided for @sectionDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get sectionDisplay;

  /// No description provided for @labelTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get labelTheme;

  /// No description provided for @labelLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get labelLanguage;

  /// No description provided for @languagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languagePickerTitle;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @labelTapToPause.
  ///
  /// In en, this message translates to:
  /// **'Tap to Pause'**
  String get labelTapToPause;

  /// No description provided for @descriptionTapToPause.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere on timer to pause/resume'**
  String get descriptionTapToPause;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// No description provided for @labelVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get labelVersion;

  /// No description provided for @labelLicenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get labelLicenses;

  /// No description provided for @soundPackClassicBell.
  ///
  /// In en, this message translates to:
  /// **'Classic Bell'**
  String get soundPackClassicBell;

  /// No description provided for @soundPackDigitalBuzzer.
  ///
  /// In en, this message translates to:
  /// **'Digital Buzzer'**
  String get soundPackDigitalBuzzer;

  /// No description provided for @soundPackMinimalBeep.
  ///
  /// In en, this message translates to:
  /// **'Minimal Beep'**
  String get soundPackMinimalBeep;

  /// No description provided for @soundPackPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound Pack'**
  String get soundPackPickerTitle;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themePickerTitle;

  /// No description provided for @presetProBoxingMen.
  ///
  /// In en, this message translates to:
  /// **'Pro Boxing (Men)'**
  String get presetProBoxingMen;

  /// No description provided for @presetProBoxingWomen.
  ///
  /// In en, this message translates to:
  /// **'Pro Boxing (Women)'**
  String get presetProBoxingWomen;

  /// No description provided for @presetAmateurBoxing.
  ///
  /// In en, this message translates to:
  /// **'Amateur Boxing'**
  String get presetAmateurBoxing;

  /// No description provided for @presetAmateurWomen.
  ///
  /// In en, this message translates to:
  /// **'Amateur Women'**
  String get presetAmateurWomen;

  /// No description provided for @presetShadowBoxing.
  ///
  /// In en, this message translates to:
  /// **'Shadow Boxing'**
  String get presetShadowBoxing;

  /// No description provided for @presetHeavyBag.
  ///
  /// In en, this message translates to:
  /// **'Heavy Bag'**
  String get presetHeavyBag;

  /// No description provided for @presetSpeedBag.
  ///
  /// In en, this message translates to:
  /// **'Speed Bag'**
  String get presetSpeedBag;

  /// No description provided for @presetSparring.
  ///
  /// In en, this message translates to:
  /// **'Sparring'**
  String get presetSparring;

  /// No description provided for @presetPadWork.
  ///
  /// In en, this message translates to:
  /// **'Pad Work'**
  String get presetPadWork;

  /// No description provided for @presetConditioning.
  ///
  /// In en, this message translates to:
  /// **'Conditioning'**
  String get presetConditioning;

  /// No description provided for @presetTabata.
  ///
  /// In en, this message translates to:
  /// **'Tabata'**
  String get presetTabata;

  /// No description provided for @presetEmom.
  ///
  /// In en, this message translates to:
  /// **'EMOM'**
  String get presetEmom;

  /// No description provided for @presetBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get presetBeginner;

  /// No description provided for @presetYouthBoxing.
  ///
  /// In en, this message translates to:
  /// **'Youth Boxing'**
  String get presetYouthBoxing;

  /// No description provided for @presetMuayThai.
  ///
  /// In en, this message translates to:
  /// **'Muay Thai'**
  String get presetMuayThai;

  /// No description provided for @presetMma.
  ///
  /// In en, this message translates to:
  /// **'MMA'**
  String get presetMma;

  /// No description provided for @presetKickboxing.
  ///
  /// In en, this message translates to:
  /// **'Kickboxing'**
  String get presetKickboxing;

  /// No description provided for @presetOffenseDefense.
  ///
  /// In en, this message translates to:
  /// **'Offense / Defense'**
  String get presetOffenseDefense;

  /// No description provided for @presetBagConditioning.
  ///
  /// In en, this message translates to:
  /// **'Bag + Conditioning'**
  String get presetBagConditioning;

  /// No description provided for @presetBurnoutRounds.
  ///
  /// In en, this message translates to:
  /// **'Burnout Rounds'**
  String get presetBurnoutRounds;

  /// No description provided for @templateOffenseDefense.
  ///
  /// In en, this message translates to:
  /// **'Offense / Defense'**
  String get templateOffenseDefense;

  /// No description provided for @segmentOffense.
  ///
  /// In en, this message translates to:
  /// **'Offense'**
  String get segmentOffense;

  /// No description provided for @segmentDefense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get segmentDefense;

  /// No description provided for @templateBagConditioning.
  ///
  /// In en, this message translates to:
  /// **'Bag + Conditioning'**
  String get templateBagConditioning;

  /// No description provided for @segmentBagWork.
  ///
  /// In en, this message translates to:
  /// **'Bag Work'**
  String get segmentBagWork;

  /// No description provided for @segmentConditioning.
  ///
  /// In en, this message translates to:
  /// **'Conditioning'**
  String get segmentConditioning;

  /// No description provided for @templateBurnoutFinisher.
  ///
  /// In en, this message translates to:
  /// **'Burnout Finisher'**
  String get templateBurnoutFinisher;

  /// No description provided for @segmentNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get segmentNormal;

  /// No description provided for @segmentHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get segmentHard;

  /// No description provided for @segmentAllOut.
  ///
  /// In en, this message translates to:
  /// **'All-Out'**
  String get segmentAllOut;

  /// No description provided for @templatePyramid.
  ///
  /// In en, this message translates to:
  /// **'Pyramid'**
  String get templatePyramid;

  /// No description provided for @segmentBuild.
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get segmentBuild;

  /// No description provided for @segmentPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak'**
  String get segmentPeak;

  /// No description provided for @segmentTaper.
  ///
  /// In en, this message translates to:
  /// **'Taper'**
  String get segmentTaper;

  /// No description provided for @templateStationRotation.
  ///
  /// In en, this message translates to:
  /// **'Station Rotation'**
  String get templateStationRotation;

  /// No description provided for @segmentJumpRope.
  ///
  /// In en, this message translates to:
  /// **'Jump Rope'**
  String get segmentJumpRope;

  /// No description provided for @segmentShadowBox.
  ///
  /// In en, this message translates to:
  /// **'Shadow Box'**
  String get segmentShadowBox;

  /// No description provided for @templateModeAll.
  ///
  /// In en, this message translates to:
  /// **'Same for all rounds'**
  String get templateModeAll;

  /// No description provided for @templateModePerRound.
  ///
  /// In en, this message translates to:
  /// **'Customize per round'**
  String get templateModePerRound;

  /// No description provided for @templateCreateCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get templateCreateCustom;

  /// No description provided for @templateEditCopy.
  ///
  /// In en, this message translates to:
  /// **'Edit Copy'**
  String get templateEditCopy;

  /// No description provided for @templateSimple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get templateSimple;

  /// No description provided for @segmentEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Round Structure'**
  String get segmentEditorTitle;

  /// No description provided for @segmentEditorNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Structure Name'**
  String get segmentEditorNameLabel;

  /// No description provided for @segmentEditorNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Bag Combo'**
  String get segmentEditorNameHint;

  /// No description provided for @segmentEditorNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get segmentEditorNameRequired;

  /// No description provided for @segmentAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Segment'**
  String get segmentAdd;

  /// No description provided for @segmentLabelField.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get segmentLabelField;

  /// No description provided for @segmentDurationField.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get segmentDurationField;

  /// No description provided for @segmentMaxReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum {max} segments'**
  String segmentMaxReached(int max);

  /// No description provided for @segmentMinRequired.
  ///
  /// In en, this message translates to:
  /// **'At least 1 segment required'**
  String get segmentMinRequired;

  /// No description provided for @repeatCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeatCountLabel;

  /// No description provided for @totalPerRound.
  ///
  /// In en, this message translates to:
  /// **'Total per round: {duration}'**
  String totalPerRound(String duration);

  /// No description provided for @roundNLabel.
  ///
  /// In en, this message translates to:
  /// **'Round {n}'**
  String roundNLabel(int n);

  /// No description provided for @applyToAllRounds.
  ///
  /// In en, this message translates to:
  /// **'Apply to all rounds'**
  String get applyToAllRounds;

  /// No description provided for @templateSaved.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" saved'**
  String templateSaved(String name);

  /// No description provided for @changeTemplate.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeTemplate;

  /// No description provided for @historyScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Training History'**
  String get historyScreenTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No training records yet'**
  String get historyEmpty;

  /// No description provided for @historyEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete a session to see it here'**
  String get historyEmptySubtitle;

  /// No description provided for @historyToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get historyToday;

  /// No description provided for @historyYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get historyYesterday;

  /// No description provided for @historyRecordRounds.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} rounds'**
  String historyRecordRounds(int completed, int total);

  /// No description provided for @historyRecordCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get historyRecordCompleted;

  /// No description provided for @historyRecordStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped early'**
  String get historyRecordStopped;

  /// No description provided for @historyDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Record?'**
  String get historyDeleteTitle;

  /// No description provided for @historyDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove this training record?'**
  String get historyDeleteMessage;

  /// No description provided for @historyClearAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear All History?'**
  String get historyClearAllTitle;

  /// No description provided for @historyClearAllMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove all training records. This cannot be undone.'**
  String get historyClearAllMessage;

  /// No description provided for @historyClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get historyClearAll;

  /// No description provided for @historyRecordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Record deleted'**
  String get historyRecordDeleted;

  /// No description provided for @historyAllCleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared'**
  String get historyAllCleared;

  /// No description provided for @settingsTrainingHistory.
  ///
  /// In en, this message translates to:
  /// **'Training History'**
  String get settingsTrainingHistory;

  /// No description provided for @sectionData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get sectionData;

  /// No description provided for @inProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'IN PROGRESS'**
  String get inProgressTitle;

  /// No description provided for @inProgressRoundFormat.
  ///
  /// In en, this message translates to:
  /// **'Round {current}/{total}'**
  String inProgressRoundFormat(int current, int total);

  /// No description provided for @inProgressTimeLeft.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get inProgressTimeLeft;

  /// No description provided for @buttonResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get buttonResume;

  /// No description provided for @buttonDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get buttonDiscard;

  /// No description provided for @discardSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard Session?'**
  String get discardSessionTitle;

  /// No description provided for @discardSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'Discard the in-progress session \"{name}\"? Your progress will be lost.'**
  String discardSessionMessage(String name);

  /// No description provided for @sectionSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get sectionSubscription;

  /// No description provided for @removeAdsTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get removeAdsTitle;

  /// No description provided for @removeAdsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase to remove all ads'**
  String get removeAdsSubtitle;

  /// No description provided for @removeAdsPrice.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads - {price}'**
  String removeAdsPrice(String price);

  /// No description provided for @adFreeStatus.
  ///
  /// In en, this message translates to:
  /// **'Ad-Free'**
  String get adFreeStatus;

  /// No description provided for @adFreeDescription.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your purchase!'**
  String get adFreeDescription;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @restorePurchasesDescription.
  ///
  /// In en, this message translates to:
  /// **'Restore a previous ad removal purchase'**
  String get restorePurchasesDescription;

  /// No description provided for @purchaseRestored.
  ///
  /// In en, this message translates to:
  /// **'Purchase restored successfully'**
  String get purchaseRestored;

  /// No description provided for @purchaseRestoredNone.
  ///
  /// In en, this message translates to:
  /// **'No previous purchases found'**
  String get purchaseRestoredNone;

  /// No description provided for @purchaseError.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get purchaseError;

  /// No description provided for @purchasePending.
  ///
  /// In en, this message translates to:
  /// **'Purchase pending...'**
  String get purchasePending;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'es':
      return SEs();
    case 'pt':
      return SPt();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
