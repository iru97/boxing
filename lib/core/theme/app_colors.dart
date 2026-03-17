import 'dart:ui';

/// Brand and neutral color palette.
///
/// True black layered system optimized for OLED displays.
/// Timer apps don't scroll — OLED smearing is irrelevant.
/// True black saves battery on Samsung and maximizes contrast.
class AppColors {
  AppColors._();

  // Brand
  static const brandRed = Color(0xFFE53935);
  static const brandRedDark = Color(0xFFC62828);
  static const brandRedLight = Color(0xFFEF5350);
  static const brandGold = Color(0xFFFFB300);

  // True Black Layered Surface System
  static const background = Color(0xFF000000);
  static const cardSurface = Color(0xFF111111);
  static const raisedSurface = Color(0xFF1A1A1A);
  static const divider = Color(0xFF2A2A2A);
  static const ringTrack = Color(0xFF222222);

  // Legacy aliases (for backward compatibility during migration)
  static const darkBackground = background;
  static const darkSurface = cardSurface;
  static const darkSurfaceElevated = raisedSurface;
  static const darkBorder = divider;
}

/// Phase colors — semantic colors tied to timer state.
/// These are NOT brand colors. They communicate workout phase at a glance.
///
/// Calibrated for a #000000 background with sufficient contrast while
/// avoiding eye strain. Based on the traffic-light mental model used
/// universally across competing boxing timer apps.
class TimerColors {
  TimerColors._();

  // Phase colors (full saturation — progress ring and labels)
  static const work = Color(0xFF00C853);       // Green A700
  static const warning = Color(0xFFFFB300);     // Amber 700
  static const rest = Color(0xFFE53935);        // Red 600
  static const warmup = Color(0xFF1E88E5);      // Blue 600
  static const complete = Color(0xFFB0BEC5);    // Blue-grey 300
  static const idle = Color(0xFF9E9E9E);
  static const paused = Color(0xFF757575);

  // Phase tints (10% opacity overlays for background wash)
  static const tintWork = Color(0x1A00C853);
  static const tintWarning = Color(0x1AFFB300);
  static const tintRest = Color(0x1AE53935);
  static const tintWarmup = Color(0x1A1E88E5);
}

/// Session category accent colors for card dots.
class CategoryColors {
  CategoryColors._();

  static const boxing = Color(0xFF00C853);      // Pro, Amateur, Sparring, Pad Work
  static const bagWork = Color(0xFFFF6D00);     // Heavy Bag, Speed Bag
  static const conditioning = Color(0xFFE53935); // Conditioning, Tabata, EMOM
  static const combatSport = Color(0xFF7E57C2); // Muay Thai, MMA, Kickboxing
  static const beginner = Color(0xFF1E88E5);    // Beginner, Youth, Shadow Boxing
  static const custom = Color(0xFFFFB300);      // User-created sessions
}
