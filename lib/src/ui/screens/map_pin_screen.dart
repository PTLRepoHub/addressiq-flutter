import 'package:flutter/material.dart';
import '../../api/models.dart';
import '../theme.dart';
import '../components/addressiq_button.dart';
import '../components/step_indicator.dart';

class MapPinScreen extends StatefulWidget {
  final AddressIQTheme theme;
  final AddressData address;
  final String? mapboxToken;
  final void Function(AddressData) onNext;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  const MapPinScreen({super.key, required this.theme, required this.address, this.mapboxToken, required this.onNext, required this.onBack, required this.onCancel});

  @override
  State<MapPinScreen> createState() => _MapPinScreenState();
}

class _MapPinScreenState extends State<MapPinScreen> {
  late double _lat;
  late double _lon;

  @override
  void initState() {
    super.initState();
    _lat = widget.address.lat ?? 0;
    _lon = widget.address.lon ?? 0;
  }

  void _handleConfirm() {
    widget.address.lat = _lat;
    widget.address.lon = _lon;
    widget.onNext(widget.address);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    // Fallback: show coordinates without map
    // Mapbox Flutter integration requires native setup.
    // This screen shows a coordinate display with the pin location.
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
                Expanded(child: StepIndicator(totalSteps: 5, currentStep: 1, theme: t)),
                IconButton(icon: const Icon(Icons.close), onPressed: widget.onCancel),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(color: t.primary, shape: BoxShape.circle),
                      child: const Center(child: Icon(Icons.location_on, color: Colors.white, size: 32)),
                    ),
                    const SizedBox(height: 20),
                    Text('Confirm Location', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: t.textColor)),
                    const SizedBox(height: 8),
                    Text('Your address has been pinned at:', style: TextStyle(fontSize: 15, color: t.textSecondary)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: t.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: t.border),
                      ),
                      child: Column(
                        children: [
                          Text('${_lat.toStringAsFixed(6)}, ${_lon.toStringAsFixed(6)}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'monospace', color: t.textColor)),
                          if (widget.address.formattedAddress != null) ...[
                            const SizedBox(height: 8),
                            Text(widget.address.formattedAddress!, textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, color: t.textSecondary)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('For a full interactive map, configure Mapbox in the host app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: t.textSecondary)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: AddressIQButton(title: 'Confirm Location', onPressed: _handleConfirm, theme: t),
          ),
        ],
      ),
    );
  }
}
