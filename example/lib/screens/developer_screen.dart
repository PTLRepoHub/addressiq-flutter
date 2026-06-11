// P1-1 / P1-4 — Developer APIs: low-level SDK calls with JSON results
// (OkHi debug style). Raw method names only.

import 'package:flutter/material.dart';
import 'package:addressiq_sdk/addressiq.dart';
import '../result_modal.dart';

class DeveloperScreen extends StatefulWidget {
  final String? defaultLocationCode;
  final String? defaultVerificationCode;

  const DeveloperScreen({
    super.key,
    this.defaultLocationCode,
    this.defaultVerificationCode,
  });

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
  late final TextEditingController _locationCode =
      TextEditingController(text: widget.defaultLocationCode ?? '');
  late final TextEditingController _verificationCode =
      TextEditingController(text: widget.defaultVerificationCode ?? '');

  @override
  void dispose() {
    _locationCode.dispose();
    _verificationCode.dispose();
    super.dispose();
  }

  String get _loc => _locationCode.text.trim();
  String get _ver => _verificationCode.text.trim();

  Future<void> _run(String title, Future<Object?> Function() fn, {String? type}) async {
    try {
      final payload = await fn();
      if (mounted) await showResultModal(context, title: title, payload: payload, type: type);
    } catch (e) {
      if (mounted) {
        await showResultModal(context, title: '$title — Error', payload: formatError(e), type: type);
      }
    }
  }

  /// Render a VerificationLifecycleState as a plain JSON-friendly map for
  /// the result modal (the entity itself is not JSON-encodable).
  Map<String, dynamic> _stateToMap(VerificationLifecycleState s) => {
        'state': s.state.name,
        'appUserId': s.appUserId,
        'verificationId': s.verificationId,
        'locationCode': s.locationCode,
        'pausedFor': s.pausedFor?.inSeconds,
      };

  @override
  Widget build(BuildContext context) {
    final sdk = AddressIQ.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Developer APIs')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Low-level SDK calls with JSON results (OkHi debug style).',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _locationCode,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Location code',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _verificationCode,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Verification code',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          _btn('getVerificationState()', () => _run('getVerificationState', () async => _stateToMap(sdk.getVerificationState()))),
          _btn('startVerification()', () => _run('startVerification', () => sdk.startVerification(StartVerificationArgs(locationCode: _loc)), type: 'DIGITAL')),
          _btn('startPhysicalVerification()', () => _run('startPhysicalVerification', () => sdk.startPhysicalVerification(StartPhysicalArgs(locationCode: _loc, provider: 'internal_agents')), type: 'PHYSICAL')),
          _btn('startDigitalAndPhysicalVerification()', () => _run('startDigitalAndPhysicalVerification', () => sdk.startDigitalAndPhysicalVerification(StartCombinedArgs(locationCode: _loc, physicalProvider: 'internal_agents')), type: 'COMBINED')),
          _btn('listProviders()', () => _run('listProviders', () => sdk.listProviders())),
          _btn('cancelVerification()', () => _run('cancelVerification', () => sdk.cancelVerification(_ver))),
          _btn('pauseVerification()', () => _run('pauseVerification', () async { await sdk.pauseVerification(); return {'ok': true}; })),
          _btn('resumeVerification()', () => _run('resumeVerification', () async { await sdk.resumeVerification(); return {'ok': true}; })),
          _btn('sync()', () => _run('sync', () => sdk.sync())),
        ],
      ),
    );
  }

  Widget _btn(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FilledButton.tonal(
        onPressed: onPressed,
        child: Align(alignment: Alignment.centerLeft, child: Text(label)),
      ),
    );
  }
}
