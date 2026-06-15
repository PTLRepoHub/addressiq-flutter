import 'package:flutter/material.dart';
import '../theme.dart';
import '../components/addressiq_button.dart';
import 'map_webview.dart';

/// §6.6 step 6 — Street View pin-confirm (numbered stage 2/4). Shown only when
/// Street View metadata coverage exists at the picked point. The panorama
/// renders in a WebView (no native Google Maps SDK).
class StreetViewScreen extends StatelessWidget {
  final AddressIQTheme theme;
  final String apiKey;
  final double lat;
  final double lon;
  final VoidCallback onConfirm;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  const StreetViewScreen({
    super.key,
    required this.theme,
    required this.apiKey,
    required this.lat,
    required this.lon,
    required this.onConfirm,
    required this.onBack,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final t = theme;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: onCancel),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Confirm your building', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: t.textColor)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: StreetViewWebView(apiKey: apiKey, lat: lat, lon: lon),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: onBack, child: const Text('Back'))),
                const SizedBox(width: 12),
                Expanded(child: AddressIQButton(title: 'Confirm', onPressed: onConfirm, theme: t)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
