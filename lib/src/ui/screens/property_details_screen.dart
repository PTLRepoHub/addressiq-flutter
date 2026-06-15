import 'package:flutter/material.dart';
import '../../api/models.dart';
import '../theme.dart';
import '../components/addressiq_button.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final AddressIQTheme theme;
  final AddressData address;
  final void Function(AddressData) onNext;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  const PropertyDetailsScreen({super.key, required this.theme, required this.address, required this.onNext, required this.onBack, required this.onCancel});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  late TextEditingController _numberCtrl, _nameCtrl, _streetCtrl, _directionsCtrl;
  String _color = '';

  static const _colors = [
    _ColorOption('White', Color(0xFFF5F5F5), true),
    _ColorOption('Brown', Color(0xFF8B4513), false),
    _ColorOption('Blue', Color(0xFF2563EB), false),
    _ColorOption('Red', Color(0xFFDC2626), false),
    _ColorOption('Grey', Color(0xFF6B7280), false),
    _ColorOption('Yellow', Color(0xFFEAB308), true),
    _ColorOption('Green', Color(0xFF16A34A), false),
    _ColorOption('Cream', Color(0xFFFFFDD0), true),
  ];

  @override
  void initState() {
    super.initState();
    _numberCtrl = TextEditingController(text: widget.address.propertyNumber);
    _nameCtrl = TextEditingController(text: widget.address.propertyName ?? '');
    _streetCtrl = TextEditingController(text: widget.address.streetName);
    _directionsCtrl = TextEditingController(text: widget.address.directions ?? '');
    _color = widget.address.buildingColor;
  }

  bool get _isValid => _numberCtrl.text.trim().isNotEmpty && _streetCtrl.text.trim().isNotEmpty && _color.isNotEmpty;

  void _handleNext() {
    widget.address.propertyNumber = _numberCtrl.text.trim();
    widget.address.propertyName = _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim();
    widget.address.streetName = _streetCtrl.text.trim();
    widget.address.buildingColor = _color;
    widget.address.directions = _directionsCtrl.text.trim().isEmpty ? null : _directionsCtrl.text.trim();
    widget.onNext(widget.address);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: widget.onCancel),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Property details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: t.textColor)),
                  const SizedBox(height: 6),
                  Text('Tell us about your building', style: TextStyle(fontSize: 15, color: t.textSecondary)),
                  const SizedBox(height: 20),
                  _buildField('Property Number *', _numberCtrl, 'e.g. 12A', t),
                  _buildField('Street Name *', _streetCtrl, 'e.g. Broad Street', t),
                  _buildField('Property Name', _nameCtrl, 'e.g. Sunshine Estate (optional)', t),
                  // Color picker
                  Text('Building Color *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: t.textColor)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _colors.map((c) {
                      final selected = _color == c.label;
                      return GestureDetector(
                        onTap: () => setState(() => _color = c.label),
                        child: Container(
                          width: 72,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: selected ? t.primary : Colors.transparent, width: selected ? 2.5 : 1),
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(radius: 18, backgroundColor: c.color,
                                child: c.hasBorder ? Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD1D5DB)))) : null),
                              const SizedBox(height: 4),
                              Text(c.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: selected ? t.primary : t.textSecondary)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  _buildField('Directions / Landmarks', _directionsCtrl, 'Optional', t, multiline: true),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: AddressIQButton(title: 'Continue', onPressed: _handleNext, theme: t, disabled: !_isValid),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, String hint, AddressIQTheme t, {bool multiline = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: t.textColor)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          onChanged: (_) => setState(() {}),
          maxLines: multiline ? 3 : 1,
          decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

class _ColorOption {
  final String label;
  final Color color;
  final bool hasBorder;
  const _ColorOption(this.label, this.color, this.hasBorder);
}
