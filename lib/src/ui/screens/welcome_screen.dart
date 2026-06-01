import 'package:flutter/material.dart';
import '../theme.dart';
import '../components/addressiq_button.dart';

class WelcomeScreen extends StatelessWidget {
  final AddressIQTheme theme;
  final VoidCallback onNext;
  final VoidCallback onCancel;

  const WelcomeScreen({super.key, required this.theme, required this.onNext, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Item('\u{1F4CD}', 'Your address location', 'Search or pin your exact address on the map'),
      _Item('\u{1F3E0}', 'Property details', 'Property number, street name, and building color'),
      _Item('\u{1F4F7}', 'Photo of your entrance', 'Take a photo of your gate or front door'),
      _Item('\u{1F4E1}', 'Background verification', 'We\u2019ll verify your presence over 2\u20137 days'),
    ];

    return SafeArea(
      child: Column(
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(icon: const Icon(Icons.close), onPressed: onCancel),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(color: theme.primaryLight, shape: BoxShape.circle),
                    child: const Center(child: Text('\u{1F512}', style: TextStyle(fontSize: 32))),
                  ),
                  const SizedBox(height: 16),
                  Text('Address Verification', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: theme.textColor)),
                  const SizedBox(height: 8),
                  Text(
                    'We need to verify that you live at the address you provide. Here\'s what we\'ll need:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: theme.textSecondary, height: 1.4),
                  ),
                  const SizedBox(height: 28),
                  ...items.map((item) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: theme.border),
                    ),
                    child: Row(
                      children: [
                        Text(item.icon, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: theme.textColor)),
                              const SizedBox(height: 2),
                              Text(item.desc, style: TextStyle(fontSize: 13, color: theme.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: AddressIQButton(title: 'Get Started', onPressed: onNext, theme: theme),
          ),
        ],
      ),
    );
  }
}

class _Item {
  final String icon, title, desc;
  const _Item(this.icon, this.title, this.desc);
}
