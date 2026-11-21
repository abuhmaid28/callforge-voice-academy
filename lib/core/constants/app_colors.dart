import 'package:flutter/material.dart';

/// Premium dark design palette for CALLFORGE.
/// Optimized for call center workstation conditions with high contrast and eye comfort.
abstract class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0A0F1D);
  static const Color surface = Color(0xFF131D31);
  static const Color surfaceElevated = Color(0xFF1B2844);
  static const Color card = Color(0xFF17233B);

  // Brand Accents (AT&T Inspired Electric Blues)
  static const Color primary = Color(0xFF00A8E8);
  static const Color primaryDark = Color(0xFF006699);
  static const Color primaryLight = Color(0xFF38BDF8);

  // Status & Pedagogical Colors
  static const Color success = Color(
    0xFF10B981,
  ); // Emerald for passed / verified
  static const Color warning = Color(
    0xFFF59E0B,
  ); // Amber for coaching & P/B flags
  static const Color error = Color(
    0xFFEF4444,
  ); // Rose for missed anchors / errors
  static const Color info = Color(0xFF6366F1); // Indigo for general info

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Accent Glows
  static const Color micListeningGlow = Color(0xFFEF4444);
  static const Color ttsSpeakingGlow = Color(0xFF00A8E8);
}
