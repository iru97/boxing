import 'package:flutter/material.dart';

/// Consistent spacing and dimension tokens for the Boxing app.
class AppSpacing {
  AppSpacing._();

  // ---------------------------------------------------------------------------
  // Spacing scale (4px base unit)
  // ---------------------------------------------------------------------------

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // ---------------------------------------------------------------------------
  // Screen padding presets
  // ---------------------------------------------------------------------------

  static const EdgeInsets screenPadding = EdgeInsets.all(md);
  static const EdgeInsets screenPaddingLarge = EdgeInsets.all(lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets listPadding = EdgeInsets.all(md);
}

/// Component dimensions — sizes for interactive and display elements.
class AppDimensions {
  AppDimensions._();

  // ---------------------------------------------------------------------------
  // Timer display
  // ---------------------------------------------------------------------------

  static const double progressRingSize = 280;
  static const double progressRingStroke = 12;
  static const double timerFontSize = 96;
  static const double phaseLabelFontSize = 32;
  static const double roundIndicatorFontSize = 24;

  // ---------------------------------------------------------------------------
  // Touch targets (glove-friendly)
  // ---------------------------------------------------------------------------

  static const double pauseButtonSize = 80;
  static const double skipButtonSize = 64;
  static const double startButtonHeight = 80;
  static const double actionButtonHeight = 64;
  static const double minTouchTarget = 48;

  // ---------------------------------------------------------------------------
  // Cards and surfaces
  // ---------------------------------------------------------------------------

  static const double cardRadius = 12;
  static const double cardElevation = 2;
  static const double cardMarginBottom = 8;

  // ---------------------------------------------------------------------------
  // Icons
  // ---------------------------------------------------------------------------

  static const double iconLarge = 96; // Completion check
  static const double iconMedium = 28; // Close button
  static const double iconSmall = 24; // Navigation, actions
  static const double iconTiny = 20; // Badges
}
