// P1-3 — Login: environment picker + appUserId (+ profile fields) →
// produces a SessionData the hub uses to initialize + setUser.

import 'package:flutter/material.dart';
import '../app_state.dart';

class LoginScreen extends StatefulWidget {
  final void Function(SessionData session) onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _environment = 'staging';
  final _appUserId = TextEditingController(text: 'cust_sample_001');
  final _firstName = TextEditingController(text: 'Demo');
  final _lastName = TextEditingController(text: 'User');
  final _email = TextEditingController(text: 'demo@addressiq.test');
  final _phone = TextEditingController(text: '+2348000000000');

  @override
  void dispose() {
    _appUserId.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _submit() {
    final id = _appUserId.text.trim();
    if (id.isEmpty) return;
    widget.onLogin(SessionData(
      environment: _environment,
      appUserId: id,
      firstName: _firstName.text.trim().isEmpty ? null : _firstName.text.trim(),
      lastName: _lastName.text.trim().isEmpty ? null : _lastName.text.trim(),
      email: _email.text.trim().isEmpty ? null : _email.text.trim(),
      phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AddressIQ — Sign in')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Sign in to try address collection and verification — the same '
            'flow as the OkHi example login screen.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          const Text('Environment', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _environment,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: [
              for (final env in sdkEnvironments)
                DropdownMenuItem(value: env, child: Text(env)),
            ],
            onChanged: (v) => setState(() => _environment = v ?? _environment),
          ),
          const SizedBox(height: 16),
          _field('App User ID', _appUserId),
          _field('First name', _firstName),
          _field('Last name', _lastName),
          _field('Email', _email, keyboardType: TextInputType.emailAddress),
          _field('Phone', _phone, keyboardType: TextInputType.phone),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submit,
            child: const Text('Continue to SDK Hub'),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
