import 'package:flutter/material.dart';
import '../api/addressiq_api.dart';
import '../api/models.dart';
import 'theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/address_search_screen.dart';
import 'screens/map_pin_screen.dart';
import 'screens/property_details_screen.dart';
import 'screens/photo_capture_screen.dart';
import 'screens/consent_screen.dart';
import 'screens/verifying_screen.dart';

enum _Screen { welcome, addressSearch, mapPin, propertyDetails, photoCapture, consent, verifying }

/// Full-screen address verification flow.
///
/// Usage:
/// ```dart
/// AddressIQVerify(
///   config: AddressIQConfig(
///     apiKey: 'fsp_...',
///     apiUrl: 'https://api.addressiq.io',
///     sessionToken: '...',
///   ),
///   onComplete: (result) { },
///   onCancel: () { },
/// )
/// ```
class AddressIQVerify extends StatefulWidget {
  final AddressIQConfig config;
  final AddressIQTheme theme;
  /// Called when the address is **collected**. The widget does NOT start a
  /// verification — call `AddressIQ.instance.startVerification(...)` here.
  final void Function(CollectResult result)? onComplete;
  final VoidCallback? onCancel;
  final void Function(Object error)? onError;
  final AddressData? initialAddress;

  const AddressIQVerify({
    super.key,
    required this.config,
    this.theme = const AddressIQTheme(),
    this.onComplete,
    this.onCancel,
    this.onError,
    this.initialAddress,
  });

  @override
  State<AddressIQVerify> createState() => _AddressIQVerifyState();
}

class _AddressIQVerifyState extends State<AddressIQVerify> {
  _Screen _screen = _Screen.welcome;
  late AddressData _address;
  late AddressIQApi _api;
  bool _submitting = false;
  CollectResult? _result;

  @override
  void initState() {
    super.initState();
    _address = widget.initialAddress ?? AddressData();
    _api = AddressIQApi(
      apiUrl: widget.config.apiUrl,
      apiKey: widget.config.apiKey,
      sessionToken: widget.config.sessionToken,
    );
  }

  void _go(_Screen s) => setState(() => _screen = s);

  Future<void> _handleSubmit() async {
    setState(() => _submitting = true);
    try {
      // 1. Init session
      await _api.initSession();

      // 2. Collect the address (collect-only — no verification started here).
      //    The host owns verification: it calls startVerification(locationCode)
      //    from onComplete. Collection (geofence + background) wires on verify.
      final result = await _api.collectAddress(_address);
      _result = result;

      setState(() => _screen = _Screen.verifying);
    } catch (e) {
      widget.onError?.call(e);
    } finally {
      setState(() => _submitting = false);
    }
  }

  void _handleDone() {
    if (_result != null) widget.onComplete?.call(_result!);
  }

  void _handleCancel() {
    widget.onCancel?.call();
  }

  /// Ordered user-facing capture steps used by the step indicator (P1-2).
  /// `welcome` and `verifying` are not numbered steps.
  static const _stepStages = <_Screen>[
    _Screen.addressSearch,
    _Screen.mapPin,
    _Screen.propertyDetails,
    _Screen.photoCapture,
    _Screen.consent,
  ];

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    final screen = switch (_screen) {
      _Screen.welcome => WelcomeScreen(theme: t, onNext: () => _go(_Screen.addressSearch), onCancel: _handleCancel),
      _Screen.addressSearch => AddressSearchScreen(theme: t, address: _address, googleMapsApiKey: widget.config.googleMapsApiKey, onNext: (a) { _address = a; _go(_Screen.mapPin); }, onBack: () => _go(_Screen.welcome), onCancel: _handleCancel),
      _Screen.mapPin => MapPinScreen(theme: t, address: _address, googleMapsApiKey: widget.config.googleMapsApiKey, onNext: (a) { _address = a; _go(_Screen.propertyDetails); }, onBack: () => _go(_Screen.addressSearch), onCancel: _handleCancel),
      _Screen.propertyDetails => PropertyDetailsScreen(theme: t, address: _address, onNext: (a) { _address = a; _go(_Screen.photoCapture); }, onBack: () => _go(_Screen.mapPin), onCancel: _handleCancel),
      _Screen.photoCapture => PhotoCaptureScreen(theme: t, address: _address, onNext: (a) { _address = a; _go(_Screen.consent); }, onBack: () => _go(_Screen.propertyDetails), onCancel: _handleCancel),
      _Screen.consent => ConsentScreen(theme: t, address: _address, onSubmit: _handleSubmit, onBack: () => _go(_Screen.photoCapture), onCancel: _handleCancel, submitting: _submitting),
      _Screen.verifying => _result != null ? VerifyingScreen(theme: t, result: _result!, onDone: _handleDone) : const SizedBox.shrink(),
    };

    final stepIndex = _stepStages.indexOf(_screen);

    return Scaffold(
      backgroundColor: t.background,
      body: Column(
        children: [
          if (stepIndex >= 0)
            _StepIndicator(theme: t, current: stepIndex, total: _stepStages.length),
          Expanded(child: screen),
        ],
      ),
    );
  }
}

/// Slim progress indicator shown atop the Collect UI multi-step flow (P1-2).
/// A dot per step (active dot widens) plus a "Step X of N" label, themed via
/// [AddressIQTheme]. Mirrors the React Native `<IQLocationManager>` indicator.
class _StepIndicator extends StatelessWidget {
  final AddressIQTheme theme;
  final int current;
  final int total;

  const _StepIndicator({required this.theme, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              for (var i = 0; i < total; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 8,
                    width: i == current ? 20 : 8,
                    decoration: BoxDecoration(
                      color: i <= current ? theme.primary : theme.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
          Text(
            'Step ${current + 1} of $total',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.textSecondary),
          ),
        ],
      ),
    );
  }
}
