import 'package:flutter/material.dart';
import '../../api/models.dart';
import '../theme.dart';
import '../components/addressiq_button.dart';

class VerifyingScreen extends StatefulWidget {
  final AddressIQTheme theme;
  final VerifyResult result;
  final VoidCallback onDone;

  const VerifyingScreen({super.key, required this.theme, required this.result, required this.onDone});

  @override
  State<VerifyingScreen> createState() => _VerifyingScreenState();
}

class _VerifyingScreenState extends State<VerifyingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final r = widget.result;

    final steps = [
      'Your location will be collected periodically in the background',
      'You can use your phone normally \u2014 no action needed',
      'You\u2019ll be notified when verification is complete',
      'You can opt out at any time from the app settings',
    ];

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  ScaleTransition(
                    scale: _scale,
                    child: Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(color: t.success, shape: BoxShape.circle),
                      child: const Center(child: Icon(Icons.check, color: Colors.white, size: 44)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Verification Started!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: t.textColor)),
                  const SizedBox(height: 8),
                  Text('We\u2019re now verifying your address in the background. This typically takes 2-7 days.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: t.textSecondary, height: 1.4)),
                  const SizedBox(height: 24),
                  // Info card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: t.primaryLight, borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      children: [
                        _infoRow('Verification ID', r.verificationId, t),
                        _infoRow('Location ID', r.locationId, t),
                        _infoRow('Status', 'Collecting data...', t, valueColor: t.success),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // What happens next
                  Align(alignment: Alignment.centerLeft, child: Text('What happens next?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: t.textColor))),
                  const SizedBox(height: 10),
                  ...steps.map((text) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 6, height: 6, margin: const EdgeInsets.only(top: 6, right: 10),
                          decoration: BoxDecoration(color: t.primary, shape: BoxShape.circle)),
                        Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: t.textSecondary, height: 1.4))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: AddressIQButton(title: 'Done', onPressed: widget.onDone, theme: t),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, AddressIQTheme t, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: 13, color: t.textSecondary)),
        Flexible(child: Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'monospace', color: valueColor ?? t.textColor), overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}
