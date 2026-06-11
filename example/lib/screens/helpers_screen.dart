// P1-1 — Helpers: permission probes (OkHi Helpers screen).
//
// Surfaces the permission helpers the Flutter SDK exposes:
//   getPermissionState / requestPermissions / canRequestPermission /
//   openSettings. Each call renders its result in the shared modal.

import 'package:flutter/material.dart';
import 'package:addressiq_sdk/addressiq.dart';
import '../result_modal.dart';

class HelpersScreen extends StatelessWidget {
  const HelpersScreen({super.key});

  Future<void> _run(
    BuildContext context,
    String title,
    Future<Object?> Function() fn,
  ) async {
    try {
      final payload = await fn();
      if (context.mounted) {
        await showResultModal(context, title: title, payload: payload);
      }
    } catch (e) {
      if (context.mounted) {
        await showResultModal(context, title: '$title — Error', payload: formatError(e));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sdk = AddressIQ.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Helpers Playground')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Permission probes — the five-state permission model '
            '(GRANTED · DENIED · NOT_DETERMINED · BLOCKED · UNAVAILABLE).',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          _btn(context, 'getPermissionState', () => _run(context, 'getPermissionState', sdk.getPermissionState)),
          _btn(context, 'requestPermissions', () => _run(context, 'requestPermissions', sdk.requestPermissions)),
          _btn(context, 'canRequestPermission', () => _run(context, 'canRequestPermission', () async => {'canRequest': await sdk.canRequestPermission()})),
          _btn(context, 'openSettings', () => _run(context, 'openSettings', () async => {'opened': await sdk.openSettings()})),
        ],
      ),
    );
  }

  Widget _btn(BuildContext context, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FilledButton.tonal(
        onPressed: onPressed,
        child: Align(alignment: Alignment.centerLeft, child: Text(label)),
      ),
    );
  }
}
