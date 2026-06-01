import 'package:flutter/material.dart';
import '../theme.dart';

class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final AddressIQTheme theme;

  const StepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (i) {
        final isActive = i <= currentStep;
        final isCurrent = i == currentStep;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isCurrent ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? theme.primary : theme.border,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
