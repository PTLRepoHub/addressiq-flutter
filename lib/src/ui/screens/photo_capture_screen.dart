import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../api/models.dart';
import '../theme.dart';
import '../components/addressiq_button.dart';
import '../components/step_indicator.dart';

class PhotoCaptureScreen extends StatefulWidget {
  final AddressIQTheme theme;
  final AddressData address;
  final void Function(AddressData) onNext;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  const PhotoCaptureScreen({super.key, required this.theme, required this.address, required this.onNext, required this.onBack, required this.onCancel});

  @override
  State<PhotoCaptureScreen> createState() => _PhotoCaptureScreenState();
}

class _PhotoCaptureScreenState extends State<PhotoCaptureScreen> {
  final _picker = ImagePicker();
  List<String> _photos = [];
  static const _maxPhotos = 3;

  @override
  void initState() {
    super.initState();
    _photos = List.from(widget.address.photos);
  }

  Future<void> _takePhoto() async {
    final image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (image != null && _photos.length < _maxPhotos) {
      setState(() => _photos.add(image.path));
    }
  }

  Future<void> _pickFromGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null && _photos.length < _maxPhotos) {
      setState(() => _photos.add(image.path));
    }
  }

  void _removePhoto(int index) {
    setState(() => _photos.removeAt(index));
  }

  void _handleNext({bool skip = false}) {
    widget.address.photos = skip ? [] : _photos;
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
                Expanded(child: StepIndicator(totalSteps: 5, currentStep: 3, theme: t)),
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
                  Text('Photo of your entrance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: t.textColor)),
                  const SizedBox(height: 6),
                  Text('Take a clear photo of your gate, front door, or building entrance.',
                    style: TextStyle(fontSize: 15, color: t.textSecondary, height: 1.4)),
                  const SizedBox(height: 20),
                  // Photo grid
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ..._photos.asMap().entries.map((entry) => Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(File(entry.value), width: 100, height: 100, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: -6, right: -6,
                            child: GestureDetector(
                              onTap: () => _removePhoto(entry.key),
                              child: Container(
                                width: 24, height: 24,
                                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                child: const Icon(Icons.close, color: Colors.white, size: 14),
                              ),
                            ),
                          ),
                        ],
                      )),
                      if (_photos.length < _maxPhotos)
                        GestureDetector(
                          onTap: _takePhoto,
                          child: Container(
                            width: 100, height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: t.border, width: 2, strokeAlign: BorderSide.strokeAlignCenter),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, color: t.primary, size: 28),
                                const SizedBox(height: 4),
                                Text('Take Photo', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: t.primary)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (_photos.length < _maxPhotos)
                    OutlinedButton.icon(
                      onPressed: _pickFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Choose from gallery'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text('${_photos.length}/$_maxPhotos photos \u00b7 Photos are optional',
                      style: TextStyle(fontSize: 12, color: t.textSecondary)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                TextButton(onPressed: () => _handleNext(skip: true), child: Text('Skip', style: TextStyle(color: t.primary))),
                const SizedBox(width: 10),
                Expanded(child: AddressIQButton(title: _photos.isNotEmpty ? 'Continue' : 'Skip', onPressed: () => _handleNext(), theme: t)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
