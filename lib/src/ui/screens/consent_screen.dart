import 'package:flutter/material.dart';
import '../../api/models.dart';
import '../theme.dart';
import '../components/addressiq_button.dart';
import '../components/step_indicator.dart';

class ConsentScreen extends StatefulWidget {
  final AddressIQTheme theme;
  final AddressData address;
  final VoidCallback onSubmit;
  final VoidCallback onBack;
  final VoidCallback onCancel;
  final bool submitting;

  const ConsentScreen({super.key, required this.theme, required this.address, required this.onSubmit, required this.onBack, required this.onCancel, this.submitting = false});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _consented = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final a = widget.address;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
                Expanded(child: StepIndicator(totalSteps: 5, currentStep: 4, theme: t)),
                IconButton(icon: const Icon(Icons.close), onPressed: widget.onCancel),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Review & confirm', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: t.textColor)),
                  const SizedBox(height: 20),
                  // Address summary
                  _card(t, 'ADDRESS', [
                    Text([a.propertyNumber, a.streetName].where((s) => s.isNotEmpty).join(' '),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: t.textColor)),
                    if (a.propertyName != null) Text(a.propertyName!, style: TextStyle(fontSize: 13, color: t.textSecondary)),
                    const SizedBox(height: 4),
                    Text('${a.lat?.toStringAsFixed(6)}, ${a.lon?.toStringAsFixed(6)}',
                      style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: t.textSecondary)),
                  ]),
                  // Property
                  _card(t, 'PROPERTY', [
                    _detailRow('Building Color', a.buildingColor, t),
                    if (a.directions != null) _detailRow('Directions', a.directions!, t),
                  ]),
                  // Notice
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('\u{1F4E1}', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Background Verification', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF92400E))),
                              const SizedBox(height: 4),
                              const Text('We will collect your location in the background for 2-7 days to verify you reside at this address. Your data is encrypted.',
                                style: TextStyle(fontSize: 13, color: Color(0xFF78350F), height: 1.4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Consent checkbox
                  GestureDetector(
                    onTap: () => setState(() => _consented = !_consented),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: _consented ? t.primary : t.border, width: 2),
                            color: _consented ? t.primary : Colors.transparent,
                          ),
                          child: _consented ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('I consent to background location collection for address verification. I understand I can opt out at any time.',
                            style: TextStyle(fontSize: 14, color: t.textColor, height: 1.4)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: AddressIQButton(title: 'Start Verification', onPressed: widget.onSubmit, theme: t, disabled: !_consented, loading: widget.submitting),
          ),
        ],
      ),
    );
  }

  Widget _card(AddressIQTheme t, String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: t.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: t.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: t.textSecondary, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        ...children,
      ]),
    );
  }

  Widget _detailRow(String label, String value, AddressIQTheme t) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: 13, color: t.textSecondary)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: t.textColor)),
      ]),
    );
  }
}
