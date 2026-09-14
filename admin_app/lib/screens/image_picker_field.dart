import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import 'server_image.dart';

class ImagePickerField extends StatefulWidget {
  final String? existingPath; // pack-relative path already on the server
  final ValueChanged<File> onPicked;
  final String label;

  const ImagePickerField({super.key, required this.onPicked, this.existingPath, this.label = 'Upload Image'});

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  File? _picked;

  Future<void> _pick() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (result == null) return;
    setState(() => _picked = File(result.path));
    widget.onPicked(_picked!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pick,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.creamDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
        ),
        clipBehavior: Clip.antiAlias,
        child: _picked != null
            ? Image.file(_picked!, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
            : (widget.existingPath != null
                ? ServerImage(relativePath: widget.existingPath, width: double.infinity, height: double.infinity, borderRadius: BorderRadius.zero)
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_photo_alternate_rounded, color: AppColors.saffron, size: 32),
                        const SizedBox(height: 6),
                        Text(widget.label, style: AppTheme.body(size: 12.5, color: AppColors.muted)),
                      ],
                    ),
                  )),
      ),
    );
  }
}
