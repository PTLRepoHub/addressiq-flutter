import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../api/models.dart';
import '../theme.dart';
import '../components/addressiq_button.dart';
import '../components/step_indicator.dart';

class AddressSearchScreen extends StatefulWidget {
  final AddressIQTheme theme;
  final AddressData address;
  final void Function(AddressData) onNext;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  const AddressSearchScreen({super.key, required this.theme, required this.address, required this.onNext, required this.onBack, required this.onCancel});

  @override
  State<AddressSearchScreen> createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  late TextEditingController _searchCtrl;
  bool _loading = false;
  double? _lat;
  double? _lon;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.address.formattedAddress ?? '');
    _lat = widget.address.lat;
    _lon = widget.address.lon;
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _loading = true);
    try {
      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        _lat = pos.latitude;
        _lon = pos.longitude;
        _searchCtrl.text = '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not get location: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _parseCoords() {
    final parts = _searchCtrl.text.split(',');
    if (parts.length == 2) {
      final lat = double.tryParse(parts[0].trim());
      final lon = double.tryParse(parts[1].trim());
      if (lat != null && lon != null) setState(() { _lat = lat; _lon = lon; });
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
                  // Search
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => _parseCoords(),
                    onSubmitted: (_) => _parseCoords(),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Enter address or coordinates...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Current location
                  OutlinedButton.icon(
                    onPressed: _loading ? null : _useCurrentLocation,
                    icon: const Icon(Icons.my_location),
                    label: Text(_loading ? 'Getting location...' : 'Use current location'),
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
                        border: Border.all(color: t.primary.withOpacity(0.3)),
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
