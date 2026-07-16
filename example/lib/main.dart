// AddressIQ Flutter sample — OkHi-style §6 screen canon.
//
// Run:
//   cd example && flutter run \
//     --dart-define=API_KEY=aiq_test_... --dart-define=SESSION_TOKEN=sdk_widget_...
//
// The API host is resolved from the selected deployment — integrators never
// pass a URL. Pick "Development" on the Login screen to hit a local backend on
// port 4000 (Android emulators auto-use 10.0.2.2).
//
// Screens: Login → Verification hub → Helpers → Addresses → Developer →
// Settings. Human labels live on the hub; raw SDK method names appear only on
// the Developer screen. Both integration tracks are exercised:
//   Track A — Collect UI (`AddressIQVerify`) launched from the hub.
//   Track B — imperative `AddressIQ.instance.start*` (hub + Developer).

import 'package:flutter/material.dart';
import 'package:addressiq_sdk/addressiq.dart';
// The Collect UI widget (`AddressIQVerify`) takes the widget-flow config,
// which the public barrel hides in favour of the lifecycle config. Import it
// directly under a prefix so both configs are usable side-by-side.
import 'package:addressiq_sdk/src/api/models.dart' as collect;

const _apiKey = String.fromEnvironment('API_KEY', defaultValue: 'aiq_test_demo_bank_seed01');
// Track-A Collect UI authenticates with a widget session token (Bearer).
const _sessionToken = String.fromEnvironment('SESSION_TOKEN', defaultValue: 'sdk_widget_session_demo');
// Fallback name only — the widget fetches the real business identity from the backend.
const _businessName = String.fromEnvironment('BUSINESS_NAME', defaultValue: 'Kuda Business');

void main() => runApp(const SampleApp());

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AddressIQ Sample',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const RootScreen(),
    );
  }
}

/// Gates the authenticated tab shell behind the Login screen.
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool _loggedIn = false;
  int _tab = 0;

  // Login inputs.
  String _deployment = 'development';
  final _appUserIdCtrl = TextEditingController(text: 'cust_sample_001');

  // Session-derived state.
  String _lifecycle = 'uninitialized';
  String? _verificationCode;
  final List<String> _locationCodes = [];

  @override
  void dispose() {
    _appUserIdCtrl.dispose();
    super.dispose();
  }

  // ─── Shared helpers ───────────────────────────────────────────────────────

  void _refreshLifecycle() {
    setState(() => _lifecycle = AddressIQ.instance.getVerificationState().state.name);
  }

  /// Public setter so the Login screen can change the deployment without
  /// reaching into the framework's `@protected` setState.
  void chooseDeployment(String value) => setState(() => _deployment = value);

  void _remember(String? locationCode) {
    if (locationCode == null || locationCode.isEmpty) return;
    if (_locationCodes.contains(locationCode)) return;
    setState(() => _locationCodes.add(locationCode));
  }

  String get _workingLocationCode =>
      _locationCodes.isNotEmpty ? _locationCodes.last : 'loc_sample_demo';

  /// Result/error modal (P1-4).
  Future<void> _showResult(String title, {Map<String, dynamic>? body, Object? error, String? type}) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Expanded(child: Text(title)),
            if (type != null) _typeChip(type),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            error != null ? error.toString() : _pretty(body ?? const {}),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close'))],
      ),
    );
  }

  /// Coloured chip for the resulting verification type (DIGITAL / PHYSICAL / COMBINED).
  Widget _typeChip(String type) {
    const colors = {
      'DIGITAL': Color(0xFF3B82F6),
      'PHYSICAL': Color(0xFF8B5CF6),
      'COMBINED': Color(0xFF14B8A6),
    };
    final c = colors[type] ?? const Color(0xFF6B7280);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c),
      ),
      child: Text(type, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  String _pretty(Map<String, dynamic> body) =>
      body.entries.map((e) => '${e.key}: ${e.value}').join('\n');

  // ─── Track B — SDK API ────────────────────────────────────────────────────

  Future<void> _login() async {
    try {
      AddressIQ.instance.initialize(AddressIQConfig(
        apiKey: _apiKey,
        deployment: _deployment,
      ));
      await AddressIQ.instance.setUser(SdkUser(appUserId: _appUserIdCtrl.text, firstName: 'Sample'));
      _refreshLifecycle();
      setState(() => _loggedIn = true);
    } catch (e) {
      await _showResult('Login failed', error: e);
    }
  }

  Future<void> _startDigital(String locationCode) async {
    try {
      final res = await AddressIQ.instance.startVerification(StartVerificationArgs(locationCode: locationCode));
      setState(() => _verificationCode = res['verificationCode']?.toString());
      _remember(locationCode);
      _refreshLifecycle();
      await _showResult('Digital verification started', body: res, type: 'DIGITAL');
    } catch (e) {
      await _showResult('Digital verification failed', error: e);
    }
  }

  Future<void> _startPhysical(String locationCode, String provider) async {
    try {
      final res = await AddressIQ.instance
          .startPhysicalVerification(StartPhysicalArgs(locationCode: locationCode, provider: provider));
      setState(() => _verificationCode = res['verificationCode']?.toString());
      _remember(locationCode);
      _refreshLifecycle();
      await _showResult('Physical verification started', body: res, type: 'PHYSICAL');
    } catch (e) {
      await _showResult('Physical verification failed', error: e);
    }
  }

  Future<void> _startCombined(String locationCode) async {
    try {
      final res = await AddressIQ.instance.startDigitalAndPhysicalVerification(
        StartCombinedArgs(locationCode: locationCode, physicalProvider: 'internal_agents'),
      );
      setState(() => _verificationCode = res['verificationCode']?.toString());
      _remember(locationCode);
      _refreshLifecycle();
      await _showResult('Combined verification started', body: res, type: 'COMBINED');
    } catch (e) {
      await _showResult('Combined verification failed', error: e);
    }
  }

  Future<void> _logout() async {
    await AddressIQ.instance.logout();
    _refreshLifecycle();
    setState(() => _loggedIn = false);
  }

  Future<void> _reset() async {
    await AddressIQ.instance.reset();
    setState(() {
      _loggedIn = false;
      _verificationCode = null;
      _locationCodes.clear();
    });
    _refreshLifecycle();
  }

  // ─── Track A — Collect UI ─────────────────────────────────────────────────

  void _openCollectUI() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => AddressIQVerify(
        config: collect.AddressIQConfig(
          apiKey: _apiKey,
          deployment: _deployment,
          sessionToken: _sessionToken,
          appUserId: _appUserIdCtrl.text,
          businessName: _businessName,
        ),
        onComplete: (result) async {
          Navigator.of(context).pop();
          _remember(result.locationCode);
          // The Collect UI collects only — the host starts verification here.
          await _startDigital(result.locationCode);
        },
        onCancel: () => Navigator.of(context).pop(),
        onError: (error) {
          Navigator.of(context).pop();
          _showResult('Collect failed', error: error);
        },
      ),
    ));
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (!_loggedIn) return _LoginScreen(this);

    final tabs = <Widget>[
      _HubScreen(this),
      _HelpersScreen(this),
      _AddressesScreen(this),
      _DeveloperScreen(this),
      _SettingsScreen(this),
    ];

    return Scaffold(
      body: SafeArea(child: tabs[_tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.verified_user), label: 'Verify'),
          NavigationDestination(icon: Icon(Icons.pan_tool), label: 'Helpers'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Addresses'),
          NavigationDestination(icon: Icon(Icons.build), label: 'Developer'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// ─── Screens ──────────────────────────────────────────────────────────────

class _LoginScreen extends StatelessWidget {
  const _LoginScreen(this.s);
  final _RootScreenState s;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AddressIQ Sample')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Sign in', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: s._deployment,
            decoration: const InputDecoration(labelText: 'Deployment'),
            items: const [
              DropdownMenuItem(value: 'staging', child: Text('Staging')),
              DropdownMenuItem(value: 'production', child: Text('Production')),
              DropdownMenuItem(value: 'development', child: Text('Development')),
            ],
            onChanged: (v) => s.chooseDeployment(v ?? 'development'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: s._appUserIdCtrl,
            decoration: const InputDecoration(labelText: 'App user ID'),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: s._login, child: const Text('Continue')),
          const SizedBox(height: 8),
          const Text('Calls initialize() then setUser().',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

class _HubScreen extends StatelessWidget {
  const _HubScreen(this.s);
  final _RootScreenState s;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            title: const Text('Lifecycle'),
            subtitle: Text(s._lifecycle),
            trailing: s._verificationCode != null ? Chip(label: Text(s._verificationCode!)) : null,
          ),
        ),
        const SizedBox(height: 8),
        _section('Collect', [
          FilledButton.tonal(
            onPressed: s._openCollectUI,
            child: const Align(alignment: Alignment.centerLeft, child: Text('Collect Address')),
          ),
        ]),
        _section('Verify an address (${s._workingLocationCode})', [
          _btn('Digital Verification', () => s._startDigital(s._workingLocationCode)),
          _btn('Physical Verification', () => s._startPhysical(s._workingLocationCode, 'internal_agents')),
          _btn('Digital + Physical', () => s._startCombined(s._workingLocationCode)),
        ]),
      ],
    );
  }
}

class _HelpersScreen extends StatefulWidget {
  const _HelpersScreen(this.s);
  final _RootScreenState s;
  @override
  State<_HelpersScreen> createState() => _HelpersScreenState();
}

class _HelpersScreenState extends State<_HelpersScreen> {
  Map<String, String> _perms = const {};

  Future<void> _refresh() async {
    final p = await AddressIQ.instance.getPermissionState();
    setState(() => _perms = p);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Permission state', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        for (final entry in _perms.entries)
          ListTile(dense: true, title: Text(entry.key), trailing: Text(entry.value)),
        const SizedBox(height: 12),
        FilledButton.tonal(
          onPressed: () async {
            final p = await AddressIQ.instance.requestPermissions();
            setState(() => _perms = p);
          },
          child: const Text('Request permissions'),
        ),
        const SizedBox(height: 4),
        FilledButton.tonal(
          onPressed: () => AddressIQ.instance.openSettings(),
          child: const Text('Open settings'),
        ),
        const SizedBox(height: 12),
        const Text('Values ∈ { GRANTED, DENIED, NOT_DETERMINED, BLOCKED, UNAVAILABLE }.',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}

class _AddressesScreen extends StatelessWidget {
  const _AddressesScreen(this.s);
  final _RootScreenState s;

  @override
  Widget build(BuildContext context) {
    if (s._locationCodes.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('No addresses yet. Collect one from the Verify tab.', textAlign: TextAlign.center),
      ));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Saved Addresses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        for (final code in s._locationCodes)
          Card(
            child: ListTile(
              title: Text(code, style: const TextStyle(fontFamily: 'monospace')),
              trailing: const Icon(Icons.refresh),
              onTap: () => s._startDigital(code),
            ),
          ),
      ],
    );
  }
}

class _DeveloperScreen extends StatelessWidget {
  const _DeveloperScreen(this.s);
  final _RootScreenState s;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('locationCode: ${s._workingLocationCode}',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
        const SizedBox(height: 8),
        _section('Raw start* calls', [
          _btn('startVerification(args)', () => s._startDigital(s._workingLocationCode)),
          _btn('startPhysicalVerification(args)', () => s._startPhysical(s._workingLocationCode, 'internal_agents')),
          _btn('startDigitalAndPhysicalVerification(args)', () => s._startCombined(s._workingLocationCode)),
        ]),
        _section('Lifecycle', [
          _btn('getVerificationState()', () async {
            final st = AddressIQ.instance.getVerificationState();
            await s._showResult('getVerificationState', body: {
              'state': st.state.name,
              'appUserId': st.appUserId,
              'verificationId': st.verificationId,
              'locationCode': st.locationCode,
            });
          }),
          _btn('cancelVerification(code)', () async {
            final code = s._verificationCode;
            if (code == null) {
              await s._showResult('cancelVerification', error: 'No active verification');
              return;
            }
            try {
              final out = await AddressIQ.instance.cancelVerification(code);
              s._refreshLifecycle();
              await s._showResult('cancelVerification', body: out);
            } catch (e) {
              await s._showResult('cancelVerification error', error: e);
            }
          }),
        ]),
      ],
    );
  }
}

class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen(this.s);
  final _RootScreenState s;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(title: const Text('Deployment'), trailing: Text(s._deployment)),
        ListTile(title: const Text('App user'), trailing: Text(s._appUserIdCtrl.text)),
        ListTile(title: const Text('Lifecycle'), trailing: Text(s._lifecycle)),
        const SizedBox(height: 12),
        FilledButton.tonal(onPressed: s._logout, child: const Text('Log out')),
        const SizedBox(height: 4),
        FilledButton.tonal(onPressed: s._reset, child: const Text('Reset SDK')),
      ],
    );
  }
}

// ─── Small shared widgets ───────────────────────────────────────────────────

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

Widget _btn(String label, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: FilledButton.tonal(
      onPressed: onPressed,
      child: Align(alignment: Alignment.centerLeft, child: Text(label)),
    ),
  );
}
