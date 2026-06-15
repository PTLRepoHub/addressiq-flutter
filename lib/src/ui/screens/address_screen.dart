import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../api/models.dart';
import '../../maps/maps_client.dart';
import '../theme.dart';
import '../components/addressiq_button.dart';
import 'map_webview.dart';

/// §6.6 step 5 — "Your location". Current Location / Search Address → interactive
/// Google map (centre pin) → auto-derived (read-only) formatted address. On
/// Continue, checks Street View coverage: routes to the `streetview` stage via
/// [onStreetView] when a panorama exists, else straight to details via [onNext].
/// Falls back to GPS + manual entry when no Google Maps key is configured.
class AddressScreen extends StatefulWidget {
  final AddressIQTheme theme;
  final AddressData address;
  final String? googleMapsApiKey;
  final void Function(AddressData) onNext;
  final void Function(AddressData) onStreetView;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  const AddressScreen({
    super.key,
    required this.theme,
    required this.address,
    this.googleMapsApiKey,
    required this.onNext,
    required this.onStreetView,
    required this.onBack,
    required this.onCancel,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late TextEditingController _searchCtrl;
  double? _lat;
  double? _lon;
  String _formatted = '';
  String? _placeId;
  bool _loading = false;
  bool _resolving = false;
  // §6.6 step 5: "Current Location | Search Address" input tabs.
  String _mode = 'current';
  List<PlaceSuggestion> _suggestions = [];
  Timer? _debounce;
  final String _sessionToken = DateTime.now().microsecondsSinceEpoch.toString();

  String? get _key {
    final k = widget.googleMapsApiKey;
    return (k == null || k.isEmpty) ? null : k;
  }

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.address.formattedAddress ?? '');
    _lat = widget.address.lat;
    _lon = widget.address.lon;
    _placeId = widget.address.placeId;
    _formatted = widget.address.formattedAddress ?? '';
    if (_lat == null || _lon == null) _useCurrentLocation();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _onSearchChanged(String text) async {
    final key = _key;
    if (key == null || text.trim().length < 3) {
      setState(() => _suggestions = []);
      return;
    }
    final out = await MapsClient(key).autocomplete(text, sessionToken: _sessionToken);
    if (mounted) setState(() => _suggestions = out);
  }

  Future<void> _pickSuggestion(PlaceSuggestion s) async {
    final key = _key;
    setState(() => _suggestions = []);
    if (key == null) return;
    final place = await MapsClient(key).placeDetails(s.placeId, sessionToken: _sessionToken);
    if (!mounted || place == null) return;
    setState(() {
      _lat = place.lat;
      _lon = place.lon;
      _placeId = s.placeId;
      _formatted = place.formattedAddress;
      _searchCtrl.text = place.formattedAddress;
    });
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _loading = true);
    try {
      final pos = await Geolocator.getCurrentPosition();
      String addr = _formatted;
      final key = _key;
      if (key != null) {
        final r = await MapsClient(key).reverseGeocode(pos.latitude, pos.longitude);
        if (r != null) addr = r;
      }
      if (!mounted) return;
      setState(() {
        _lat = pos.latitude;
        _lon = pos.longitude;
        _placeId = null;
        _formatted = addr;
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not get location: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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

  AddressData _patch() {
    widget.address.lat = _lat;
    widget.address.lon = _lon;
    widget.address.placeId = _placeId;
    widget.address.formattedAddress = _formatted.trim();
    return widget.address;
  }

  Future<void> _onContinue() async {
    if (_lat == null || _lon == null) return;
    final key = _key;
    // §6.6 step 6 is coverage-gated: route to Street View when a panorama
    // exists near the point, else advance straight to details.
    if (key != null) {
      setState(() => _resolving = true);
      final cov = await MapsClient(key).streetViewCoverage(_lat!, _lon!);
      if (!mounted) return;
      setState(() => _resolving = false);
      if (cov.available) {
        widget.onStreetView(_patch());
        return;
      }
    }
    widget.onNext(_patch());
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final hasLocation = _lat != null && _lon != null;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: widget.onCancel),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Your location', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: t.textColor)),
                const SizedBox(height: 6),
                Text('Search your address or drop a pin on the map.', style: TextStyle(fontSize: 15, color: t.textSecondary)),
                const SizedBox(height: 16),
                if (_key != null)
                  Row(
                    children: [
                      for (final m in const ['current', 'search'])
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: m == 'current' ? 8 : 0),
                            child: OutlinedButton(
                              onPressed: () => setState(() => _mode = m),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: _mode == m ? t.surface : null,
                                side: BorderSide(color: _mode == m ? t.primary : t.border),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(m == 'current' ? 'Current Location' : 'Search Address',
                                  style: TextStyle(color: _mode == m ? t.primary : t.textSecondary, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                    ],
                  ),
                if (_key != null) const SizedBox(height: 12),
                if (_key != null && _mode == 'search') ...[
                  TextField(
                    controller: _searchCtrl,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search your address…',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  if (_suggestions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(color: t.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: t.border)),
                      child: Column(
                        children: _suggestions
                            .map((s) => ListTile(
                                  title: Text(s.primaryText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: t.textColor)),
                                  subtitle: s.secondaryText != null ? Text(s.secondaryText!, style: TextStyle(fontSize: 12, color: t.textSecondary)) : null,
                                  onTap: () => _pickSuggestion(s),
                                ))
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
                if (_mode == 'current' || _key == null)
                  OutlinedButton.icon(
                    onPressed: _loading ? null : _useCurrentLocation,
                    icon: const Icon(Icons.my_location),
                    label: Text(_loading ? 'Getting location…' : 'Use current location'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(color: t.primary),
                    ),
                  ),
                const SizedBox(height: 14),
                if (_key != null && hasLocation)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      height: 240,
                      child: MapWebView(apiKey: _key!, lat: _lat!, lon: _lon!, onCenterChanged: _onCenterChanged),
                    ),
                  ),
                const SizedBox(height: 14),
                Text('Formatted address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: t.textColor)),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: t.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: t.border)),
                  child: _resolving
                      ? Row(children: [SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: t.primary)), const SizedBox(width: 10), Text('Resolving address…', style: TextStyle(color: t.textSecondary))])
                      : Text(_formatted.isEmpty ? 'Move the map or search to set your address.' : _formatted, style: TextStyle(fontSize: 15, color: t.textColor)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: AddressIQButton(
              title: _resolving ? 'Loading…' : 'Continue',
              onPressed: _onContinue,
              theme: t,
              disabled: !hasLocation || _resolving,
            ),
          ),
        ],
      ),
    );
  }
}
