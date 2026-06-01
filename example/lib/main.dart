// AddressIQ Flutter sample app — full lifecycle demonstration.
//
// Run:
//   cd examples/flutter-sample && flutter run
//
// Phase 3 surface exercised:
//   AddressIQ.instance.initialize → setUser → startPhysical → pause →
//   resume → sync → cancelVerification → logout

import 'package:flutter/material.dart';
import 'package:addressiq_sdk/addressiq.dart';

const _apiUrl = String.fromEnvironment('API_URL', defaultValue: 'https://api.addressiq.com');
const _apiKey = String.fromEnvironment('API_KEY', defaultValue: 'aiq_test_demo_bank_seed01');
const _appUserId = 'cust_sample_001';
const _locationCode = 'loc_sample_demo';

void main() => runApp(const SampleApp());

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AddressIQ Sample',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const SampleHome(),
    );
  }
}

class SampleHome extends StatefulWidget {
  const SampleHome({super.key});
  @override
  State<SampleHome> createState() => _SampleHomeState();
}

class _SampleHomeState extends State<SampleHome> {
  final _log = <String>[];
  List<dynamic> _providers = const [];
  String? _verificationCode;
  String _state = 'UNINITIALIZED';

  void _append(String line) {
    setState(() {
      _log.add('${TimeOfDay.now().format(context)}  $line');
    });
  }

  void _refreshState() {
    final s = AddressIQ.instance.getVerificationState();
    setState(() => _state = s.state.name);
  }

  Future<void> _initialize() async {
    try {
      AddressIQ.instance.initialize(AddressIQConfig(
        apiKey: _apiKey,
        apiUrl: _apiUrl,
        environment: 'sandbox',
      ));
      _append('initialize: ok');
      final providers = await AddressIQ.instance.listProviders(type: 'physical');
      setState(() => _providers = providers);
      _refreshState();
    } catch (e) {
      _append('initialize: error $e');
    }
  }

  Future<void> _setUser() async {
    try {
      await AddressIQ.instance.setUser(const SdkUser(appUserId: _appUserId, firstName: 'Sample'));
      _append('setUser: bound $_appUserId');
      _refreshState();
    } catch (e) {
      _append('setUser: error $e');
    }
  }

  Future<void> _startPhysical(String provider) async {
    try {
      final res = await AddressIQ.instance.startPhysicalVerification(StartPhysicalArgs(
        locationCode: _locationCode,
        provider: provider,
      ));
      _verificationCode = res['verificationCode']?.toString();
      _append('startPhysical($provider): $_verificationCode');
      _refreshState();
    } catch (e) {
      _append('startPhysical: error $e');
    }
  }

  Future<void> _pause() async {
    await AddressIQ.instance.pauseVerification();
    _append('pause: ok');
    _refreshState();
  }

  Future<void> _resume() async {
    try {
      await AddressIQ.instance.resumeVerification();
      _append('resume: ok');
      _refreshState();
    } catch (e) {
      _append('resume: error $e');
    }
  }

  Future<void> _sync() async {
    final out = await AddressIQ.instance.sync();
    _append('sync: flushed ${out['flushed']}');
  }

  Future<void> _cancel() async {
    if (_verificationCode == null) return;
    try {
      final out = await AddressIQ.instance.cancelVerification(_verificationCode!);
      _append('cancel: ${out['status']}');
      _refreshState();
    } catch (e) {
      _append('cancel: error $e');
    }
  }

  Future<void> _logout() async {
    await AddressIQ.instance.logout();
    _append('logout: ok');
    _refreshState();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AddressIQ — Flutter Sample')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Lifecycle state'),
              subtitle: Text(_state),
              trailing: _verificationCode != null
                  ? Chip(label: Text(_verificationCode!))
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          _section('Lifecycle', [
            _btn('initialize', _initialize),
            _btn('setUser', _setUser),
            _btn('pause', _pause),
            _btn('resume', _resume),
            _btn('sync', _sync),
            _btn('cancel', _verificationCode == null ? null : _cancel),
            _btn('logout', _logout),
          ]),
          _section('Start physical via…', [
            if (_providers.isEmpty)
              const Text('(no providers — call initialize)', style: TextStyle(color: Colors.grey)),
            for (final p in _providers)
              _btn(p['displayName']?.toString() ?? p['slug']?.toString() ?? '?', () => _startPhysical(p['slug']?.toString() ?? '')),
          ]),
          _section('Activity log', [
            for (final line in _log) Text(line, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
          ]),
        ],
      ),
    );
  }

  Widget _section(String label, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(label.toUpperCase(), style: const TextStyle(letterSpacing: 0.5, color: Colors.grey)),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _btn(String label, Future<void> Function()? onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: FilledButton.tonal(
        onPressed: onPressed == null ? null : () => onPressed(),
        child: Align(alignment: Alignment.centerLeft, child: Text(label)),
      ),
    );
  }
}
