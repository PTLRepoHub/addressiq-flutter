import 'dart:async';
import 'package:flutter/material.dart';
import '../../api/models.dart';
import '../../maps/maps_client.dart';
import '../theme.dart';
import '../components/addressiq_button.dart';
import '../components/step_indicator.dart';
import 'map_webview.dart';

/// Pin-confirm step. With a Google Maps key it shows an interactive WebView map
/// (centre pin) that reverse-geocodes the point, then a Street View pin-confirm
/// where coverage exists. Without a key it falls back to a coordinate display.
class MapPinScreen extends StatefulWidget {
  final AddressIQTheme theme;
  final AddressData address;
  final String? googleMapsApiKey;
  final void Function(AddressData) onNext;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  const MapPinScreen({
    super.key,
    required this.theme,
    required this.address,
    this.googleMapsApiKey,
    required this.onNext,
    required this.onBack,
    required this.onCancel,
  });

  @override
  State<MapPinScreen> createState() => _MapPinScreenState();
}

class _MapPinScreenState extends State<MapPinScreen> {
  late double _lat;
  late double _lon;
  String _formatted = '';
  bool _resolving = false;
  bool _showStreetView = false;
  Timer? _debounce;

  String? get _key {
    final k = widget.googleMapsApiKey;
    return (k == null || k.isEmpty) ? null : k;
  }

  @override
  void initState() {
    super.initState();
    _lat = widget.address.lat ?? 6.5244;
    _lon = widget.address.lon ?? 3.3792;
    _formatted = widget.address.formattedAddress ?? '';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onCenterChanged(double lat, double lon) {
    _lat = lat;
    _lon = lon;
    final key = _key;
    if (key == null) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      setState(() => _resolving = true);
      final addr = await MapsClient(key).reverseGeocode(lat, lon);
      if (!mounted) return;
      setState(() {
        _resolving = false;
        if (addr != null) _formatted = addr;
      });
    });
  }

  Future<void> _onContinue() async {
    final key = _key;
    if (key != null) {
      setState(() => _resolving = true);
      final cov = await MapsClient(key).streetViewCoverage(_lat, _lon);
      if (!mounted) return;
      setState(() => _resolving = false);
      if (cov.available) {
        setState(() => _showStreetView = true);
        return;
      }
    }
    _finish();
  }

  void _finish() {
    widget.address.lat = _lat;
    widget.address.lon = _lon;
    widget.address.formattedAddress = _formatted.trim().isEmpty ? widget.address.formattedAddress : _formatted.trim();
    widget.onNext(widget.address);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    if (_showStreetView && _key != null) return _streetView(t);

    return SafeArea(
      child: Column(
        children: [
          _header(t, 1),
          Expanded(
            child: _key != null
                ? Column(
                    children: [
                      Expanded(child: MapWebView(apiKey: _key!, lat: _lat, lon: _lon, onCenterChanged: _onCenterChanged)),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: t.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: t.border)),
                          child: _resolving
                              ? Row(children: [SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: t.primary)), const SizedBox(width: 10), Text('Resolving address…', style: TextStyle(color: t.textSecondary))])
                              : Text(_formatted.isEmpty ? 'Move the map to set your address.' : _formatted, style: TextStyle(fontSize: 15, color: t.textColor)),
                        ),
                      ),
                    ],
                  )
                : _coordinateFallback(t),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: AddressIQButton(title: _resolving ? 'Loading…' : 'Confirm location', onPressed: _onContinue, theme: t, disabled: _resolving),
          ),
        ],
      ),
    );
  }

  Widget _streetView(AddressIQTheme t) {
    return SafeArea(
      child: Column(
        children: [
          _header(t, 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Confirm your building', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: t.textColor)),
          ),
          Expanded(child: Padding(padding: const EdgeInsets.all(16), child: ClipRRect(borderRadius: BorderRadius.circular(14), child: StreetViewWebView(apiKey: _key!, lat: _lat, lon: _lon)))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => setState(() => _showStreetView = false), child: const Text('Back'))),
                const SizedBox(width: 12),
                Expanded(child: AddressIQButton(title: 'Confirm', onPressed: _finish, theme: t)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _coordinateFallback(AddressIQTheme t) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 64, height: 64, decoration: BoxDecoration(color: t.primary, shape: BoxShape.circle), child: const Center(child: Icon(Icons.location_on, color: Colors.white, size: 32))),
            const SizedBox(height: 20),
            Text('Confirm Location', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: t.textColor)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: t.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: t.border)),
              child: Column(
                children: [
                  Text('${_lat.toStringAsFixed(6)}, ${_lon.toStringAsFixed(6)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'monospace', color: t.textColor)),
                  if (_formatted.isNotEmpty) ...[const SizedBox(height: 8), Text(_formatted, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: t.textSecondary))],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text('Set a Google Maps API key for the interactive map.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: t.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _header(AddressIQTheme t, int step) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
          Expanded(child: StepIndicator(totalSteps: 5, currentStep: step, theme: t)),
          IconButton(icon: const Icon(Icons.close), onPressed: widget.onCancel),
        ],
      ),
    );
  }
}
