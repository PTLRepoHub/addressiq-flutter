// P1-4 — reusable result/error dialog (OkHi JSON-debug style).
//
// Shows a pretty-printed JSON payload (a verification result map, a
// permission-state map, or a formatted error) in a scrollable modal.

import 'dart:convert';
import 'package:flutter/material.dart';

/// Show a result modal with [title] and any JSON-encodable [payload].
///
/// [payload] is typically a `Map<String, dynamic>` returned by a `start*`
/// call, a permission-state map, or a `{'code', 'message'}` error map.
Future<void> showResultModal(
  BuildContext context, {
  required String title,
  required Object? payload,
  String? type,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF111827),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => _ResultSheet(title: title, payload: payload, type: type),
  );
}

/// Normalise an arbitrary thrown object into a JSON-friendly map so the
/// modal renders a stable shape for errors.
Map<String, String> formatError(Object error) {
  return {'message': error.toString()};
}

class _ResultSheet extends StatelessWidget {
  final String title;
  final Object? payload;
  final String? type;

  const _ResultSheet({required this.title, required this.payload, this.type});

  /// Coloured chip for the resulting verification type.
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
        color: c.withOpacity(0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c),
      ),
      child: Text(type, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  String _pretty() {
    const encoder = JsonEncoder.withIndent('  ');
    try {
      return encoder.convert(payload);
    } catch (_) {
      // Payload had non-encodable members — fall back to its string form.
      return payload.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (type != null) _typeChip(type!),
            ],
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                _pretty(),
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
