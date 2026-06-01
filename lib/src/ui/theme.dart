import 'package:flutter/material.dart';

class AddressIQTheme {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color background;
  final Color surface;
  final Color textColor;
  final Color textSecondary;
  final Color border;
  final Color error;
  final Color success;

  const AddressIQTheme({
    this.primary = const Color(0xFF4F46E5),
    this.primaryDark = const Color(0xFF4338CA),
    this.primaryLight = const Color(0xFFEEF2FF),
    this.background = const Color(0xFFF9FAFB),
    this.surface = Colors.white,
    this.textColor = const Color(0xFF1F2937),
    this.textSecondary = const Color(0xFF6B7280),
    this.border = const Color(0xFFE5E7EB),
    this.error = const Color(0xFFDC2626),
    this.success = const Color(0xFF16A34A),
  });
}
