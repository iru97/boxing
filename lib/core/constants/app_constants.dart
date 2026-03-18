class AppConstants {
  AppConstants._();

  // Timer
  static const timerTickInterval = Duration(milliseconds: 50);
  static const timerTicksPerSecond = 20;

  // Session limits
  static const minRounds = 1;
  static const maxRounds = 30;
  static const minRoundDurationSec = 15;
  static const maxRoundDurationSec = 600;
  static const minRestDurationSec = 0;
  static const maxRestDurationSec = 300;

  // Warning time options (seconds)
  static const warningTimeOptions = [0, 5, 10, 15, 30];

  // Warmup options (seconds)
  static const warmupOptions = [0, 5, 10, 15, 30];

  // Segment limits
  static const minSegments = 1;
  static const maxSegments = 8;
  static const minSegmentDurationSec = 5;
  static const maxSegmentDurationSec = 300;
  static const minRepeatCount = 1;
  static const maxRepeatCount = 10;

  // Storage
  static const sessionsBoxName = 'sessions';
  static const settingsBoxName = 'settings';
  static const templatesBoxName = 'templates';
  static const historyBoxName = 'history';
  static const checkpointBoxName = 'checkpoint';

  // Display
  static const timerFontSize = 80.0;
  static const phaseLabelFontSize = 28.0;
  static const roundIndicatorFontSize = 22.0;
}
