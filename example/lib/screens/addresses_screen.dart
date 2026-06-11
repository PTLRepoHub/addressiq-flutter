// P1-5 — Addresses: list collected locationCodes; tapping "Verify
// digitally" re-runs startVerification for that address (OkHi re-verify
// pattern). Results render in the shared modal.

import 'package:flutter/material.dart';
import 'package:addressiq_sdk/addressiq.dart';
import '../app_state.dart';
import '../result_modal.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  bool _busy = false;

  Future<void> _reVerify(CollectedAddress address) async {
    setState(() => _busy = true);
    try {
      final res = await AddressIQ.instance.startVerification(
        StartVerificationArgs(locationCode: address.locationCode),
      );
      // Refresh the stored status from the re-verify response.
      final status = res['status']?.toString();
      if (status != null) {
        AppStore.instance.saveAddress(CollectedAddress(
          locationCode: address.locationCode,
          verificationCode: res['verificationCode']?.toString() ?? address.verificationCode,
          status: status,
        ));
      }
      if (mounted) {
        await showResultModal(context, title: 'Re-verify ${address.locationCode}', payload: res);
      }
    } catch (e) {
      if (mounted) {
        await showResultModal(context, title: 'Re-verify — Error', payload: formatError(e));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final addresses = AppStore.instance.addresses;
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Addresses')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Tap "Verify digitally" to re-run a digital verification on a '
              'collected address (OkHi re-verify pattern).',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: addresses.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No addresses yet. Use Collect Address on the '
                        'verification hub.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: addresses.length,
                    itemBuilder: (context, i) => _AddressCard(
                      address: addresses[i],
                      onVerify: _busy ? null : () => _reVerify(addresses[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final CollectedAddress address;
  final VoidCallback? onVerify;

  const _AddressCard({required this.address, required this.onVerify});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address.locationCode,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text('Status: ${address.status}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text('Verification: ${address.verificationCode}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: onVerify,
                child: const Text('Verify digitally →'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
