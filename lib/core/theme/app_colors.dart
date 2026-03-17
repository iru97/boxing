import 'dart:ui';

/// Brand and neutral color palette.
class AppColors {
  AppColors._();

  // Brand
  static const brandRed = Color(0xFFE53935);
  static const brandRedDark = Color(0xFFC62828);
  static const brandRedLight = Color(0xFFEF5350);
  static const brandGold = Color(0xFFFFC107);

  // Neutrals
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkSurfaceElevated = Color(0xFF2C2C2C);
  static const darkBorder = Color(0xFF333333);
}

/// Phase colors — semantic colors tied to timer state.
/// These are NOT brand colors. They communicate workout phase at a glance.
class TimerColors {
  TimerColors._();

  static const work = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const rest = Color(0xFFF44336);
  static const warmup = Color(0xFF2196F3);
  static const complete = Color(0xFFFFFFFF);
  static const idle = Color(0xFF9E9E9E);
  static const paused = Color(0xFF757575);
}
