import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../theme.dart';
import '../components/addressiq_button.dart';

/// §6.6 step 4 — Enable Location. Requests foreground location permission, then
/// advances to the address step. Not a numbered step in the indicator.
class PermissionScreen extends StatefulWidget {
  final AddressIQTheme theme;
  final VoidCallback onGranted;
  final VoidCallback onCancel;

  const PermissionScreen({super.key, required this.theme, required this.onGranted, required this.onCancel});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _requesting = false;

  Future<void> _request() async {
    setState(() => _requesting = true);
    try {
      var p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
      if (p == LocationPermission.always || p == LocationPermission.whileInUse) {
        widget.onGranted();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required to verify your address.')),
        );
      }
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(icon: const Icon(Icons.close), onPressed: widget.onCancel),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(color: t.primaryLight, shape: BoxShape.circle),
                    child: Icon(Icons.location_on, color: t.primary, size: 36),
                  ),
                  const SizedBox(height: 20),
                  Text('Enable Location', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: t.textColor)),
                  const SizedBox(height: 8),
                  Text(
                    'We use your location to confirm where you live. It is only collected during verification.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: t.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: AddressIQButton(
              title: _requesting ? 'Requesting…' : 'Enable Location',
              onPressed: _request,
              theme: t,
              disabled: _requesting,
            ),
          ),
        ],
      ),
    );
  }
}
