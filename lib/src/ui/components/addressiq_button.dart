import 'package:flutter/material.dart';
import '../theme.dart';

class AddressIQButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final AddressIQTheme theme;
  final bool isPrimary;
  final bool isOutline;
  final bool disabled;
  final bool loading;

  const AddressIQButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.theme,
    this.isPrimary = true,
    this.isOutline = false,
    this.disabled = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (disabled || loading) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? theme.primary : (isOutline ? Colors.transparent : theme.surface),
          foregroundColor: isPrimary ? Colors.white : theme.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: isOutline ? BorderSide(color: theme.primary, width: 1.5) : BorderSide.none,
          ),
          disabledBackgroundColor: isPrimary ? theme.primary.withOpacity(0.5) : null,
        ),
        child: loading
            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: isPrimary ? Colors.white : theme.primary))
            : Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
