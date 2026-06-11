import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../api/models.dart';
import '../../maps/maps_client.dart';
import '../theme.dart';
import '../components/addressiq_button.dart';
import '../components/step_indicator.dart';

class AddressSearchScreen extends StatefulWidget {
  final AddressIQTheme theme;
  final AddressData address;
  final String? googleMapsApiKey;
  final void Function(AddressData) onNext;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  const AddressSearchScreen({
    super.key,
    required this.theme,
    required this.address,
    this.googleMapsApiKey,
    required this.onNext,
    required this.onBack,
    required this.onCancel,
  });

  @override
  State<AddressSearchScreen> createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  late TextEditingController _searchCtrl;
  bool _loading = false;
  double? _lat;
  double? _lon;
  String? _placeId;
  List<PlaceSuggestion> _suggestions = [];
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
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
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
      _searchCtrl.text = place.formattedAddress;
    });
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _loading = true);
    try {
      final pos = await Geolocator.getCurrentPosition();
      String label = '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
      final key = _key;
      if (key != null) {
        final addr = await MapsClient(key).reverseGeocode(pos.latitude, pos.longitude);
        if (addr != null) label = addr;
      }
      setState(() {
        _lat = pos.latitude;
        _lon = pos.longitude;
        _placeId = null;
        _searchCtrl.text = label;
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not get location: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final hasLocation = _lat != null && _lon != null;

    return SafeArea(
      child: Column(
        children: [
          _buildHeader(t),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Find your address', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: t.textColor)),
                  const SizedBox(height: 6),
                  Text('Search or use your current location', style: TextStyle(fontSize: 15, color: t.textSecondary)),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: _loading ? null : _useCurrentLocation,
                    icon: const Icon(Icons.my_location),
                    label: Text(_loading ? 'Getting location…' : 'Use current location'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(color: t.primary),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (hasLocation)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: t.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: t.primary.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Text('Selected Location', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: t.primary)),
                          const SizedBox(height: 6),
                          Text('${_lat!.toStringAsFixed(6)}, ${_lon!.toStringAsFixed(6)}',
                              style: TextStyle(fontSize: 14, fontFamily: 'monospace', color: t.textSecondary)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: AddressIQButton(
              title: 'Continue',
              onPressed: () {
                widget.address.lat = _lat;
                widget.address.lon = _lon;
                widget.address.placeId = _placeId;
                widget.address.formattedAddress = _searchCtrl.text;
                widget.onNext(widget.address);
              },
              theme: t,
              disabled: !hasLocation,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AddressIQTheme t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
          Expanded(child: StepIndicator(totalSteps: 5, currentStep: 0, theme: t)),
          IconButton(icon: const Icon(Icons.close), onPressed: widget.onCancel),
        ],
      ),
    );
  }
}
