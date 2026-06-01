import 'package:flutter/material.dart';
import '../api/addressiq_api.dart';
import '../api/models.dart';
import '../location/location_collector.dart';
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
  final void Function(VerifyResult result)? onComplete;
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
  VerifyResult? _result;

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

      // 2. Submit address
      final result = await _api.submitAddress(_address);
      _result = result;

      // 3. Start background location collection
      try {
        final collector = LocationCollector(
          api: _api,
          locationId: result.locationId,
          verificationId: result.verificationId,
        );
        await collector.start();
      } catch (e) {
        debugPrint('[AddressIQSDK] Background collection failed: $e');
      }

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

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    return Scaffold(
      backgroundColor: t.background,
      body: switch (_screen) {
        _Screen.welcome => WelcomeScreen(theme: t, onNext: () => _go(_Screen.addressSearch), onCancel: _handleCancel),
        _Screen.addressSearch => AddressSearchScreen(theme: t, address: _address, onNext: (a) { _address = a; _go(_Screen.mapPin); }, onBack: () => _go(_Screen.welcome), onCancel: _handleCancel),
        _Screen.mapPin => MapPinScreen(theme: t, address: _address, mapboxToken: widget.config.mapboxToken, onNext: (a) { _address = a; _go(_Screen.propertyDetails); }, onBack: () => _go(_Screen.addressSearch), onCancel: _handleCancel),
        _Screen.propertyDetails => PropertyDetailsScreen(theme: t, address: _address, onNext: (a) { _address = a; _go(_Screen.photoCapture); }, onBack: () => _go(_Screen.mapPin), onCancel: _handleCancel),
        _Screen.photoCapture => PhotoCaptureScreen(theme: t, address: _address, onNext: (a) { _address = a; _go(_Screen.consent); }, onBack: () => _go(_Screen.propertyDetails), onCancel: _handleCancel),
        _Screen.consent => ConsentScreen(theme: t, address: _address, onSubmit: _handleSubmit, onBack: () => _go(_Screen.photoCapture), onCancel: _handleCancel, submitting: _submitting),
        _Screen.verifying => _result != null ? VerifyingScreen(theme: t, result: _result!, onDone: _handleDone) : const SizedBox.shrink(),
      },
    );
  }
}
