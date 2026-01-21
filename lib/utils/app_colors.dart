import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2E86DE);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF64B5F6);

  // Secondary Colors
  static const Color secondary = Color(0xFF26C281);
  static const Color secondaryDark = Color(0xFF1E8E63);
  static const Color secondaryLight = Color(0xFF4CD494);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color scaffold = Color(0xFFFAFAFA);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textWhite = Colors.white;

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Appointment Status Colors
  static const Color pending = Color(0xFFFF9800);      // Orange
  static const Color confirmed = Color(0xFF4CAF50);    // ✅ Green (changed from 'approved')
  static const Color rejected = Color(0xFFF44336);     // Red
  static const Color completed = Color(0xFF2196F3);    // Blue
  static const Color cancelled = Color(0xFF757575);    // Grey

  // ✅ Deprecated - kept for backward compatibility
  @Deprecated('Use confirmed instead')
  static const Color approved = Color(0xFF4CAF50);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Other Colors
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}