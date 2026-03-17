import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Boxing app typography system.
///
/// Three font roles (all bundled in assets/fonts/ for instant rendering):
/// - **Roboto Condensed** (Display): Timer countdown digits — working tabular figures
/// - **Teko** (Heading): Phase labels, round indicators — scoreboard feel
/// - **Barlow Condensed** (Body): Session names, settings, forms — functional
///
/// Note: Bebas Neue is NOT used for countdown because the free version lacks
/// the `tnum` OpenType table. FontFeature.tabularFigures() silently does nothing
/// on Bebas Neue, causing layout shift between digits at 96sp.
class AppTypography {
  AppTypography._();

  // ---------------------------------------------------------------------------
  // Timer-specific styles (not part of TextTheme — used directly in widgets)
  // ---------------------------------------------------------------------------

  /// Main countdown display: 96sp Roboto Condensed Bold with tabular figures.
  /// The ONLY free font where FontFeature.tabularFigures() actually works.
  static TextStyle countdown(Color color) => GoogleFonts.robotoCondensed(
        fontSize: 96,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 2,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Phase label: 32sp Teko SemiBold, uppercase tracking.
  static TextStyle phaseLabel(Color color) => GoogleFonts.teko(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 3,
      );

  /// Round indicator: 24sp Teko Medium.
  static TextStyle roundIndicator(Color color) => GoogleFonts.teko(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 2,
      );

  // ---------------------------------------------------------------------------
  // Material TextTheme (applied to AppTheme)
  // ---------------------------------------------------------------------------

  static TextTheme get textTheme => TextTheme(
        // Display — Roboto Condensed for large hero text (working tnum)
        displayLarge: GoogleFonts.robotoCondensed(
          fontSize: 96,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.robotoCondensed(
          fontSize: 64,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        displaySmall: GoogleFonts.robotoCondensed(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),

        // Headline — Teko for section headers and labels
        headlineLarge: GoogleFonts.teko(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 3,
        ),
        headlineMedium: GoogleFonts.teko(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          letterSpacing: 2,
        ),
        headlineSmall: GoogleFonts.teko(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),

        // Title — Barlow Condensed for navigation and card titles
        titleLarge: GoogleFonts.barlowCondensed(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        titleMedium: GoogleFonts.barlowCondensed(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: GoogleFonts.barlowCondensed(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),

        // Body — Barlow Condensed for readable content
        bodyLarge: GoogleFonts.barlowCondensed(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.barlowCondensed(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.barlowCondensed(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),

        // Label — Barlow Condensed for buttons and chips
        labelLarge: GoogleFonts.barlowCondensed(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        labelMedium: GoogleFonts.barlowCondensed(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.barlowCondensed(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      );
}
