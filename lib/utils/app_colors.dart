import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Modern Blue
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primaryLight = Color(0xFF93C5FD);

  // Secondary Colors - Modern Emerald
  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryDark = Color(0xFF047857);
  static const Color secondaryLight = Color(0xFF6EE7B7);

  // Background Colors - Subtle Gray
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBackground = Colors.white;
  static const Color scaffold = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textWhite = Colors.white;

  // Status Colors - Modern Palette
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color danger = Color(0xFFEF4444); // Alias for error
  static const Color info = Color(0xFF3B82F6);

  // Appointment Status Colors
  static const Color pending = Color(0xFFF59E0B); // Amber
  static const Color confirmed = Color(0xFF22C55E); // Green
  static const Color rejected = Color(0xFFEF4444); // Red
  static const Color completed = Color(0xFF8B5CF6); // Purple
  static const Color cancelled = Color(0xFF6B7280); // Gray

  // ✅ Deprecated - kept for backward compatibility
  @Deprecated('Use confirmed instead')
  static const Color approved = Color(0xFF22C55E);

  // Border Colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Other Colors
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);

  // Sidebar Colors
  static const Color sidebarBg = Color(0xFF0F172A);
  static const Color sidebarHover = Color(0xFF1E293B);
  static const Color sidebarActive = Color(0xFF3B82F6);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
