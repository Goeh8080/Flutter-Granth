import 'dart:io';
import 'package:flutter/material.dart';
import '../services/resource_pack_service.dart';
import '../theme/app_theme.dart';

class PackImage extends StatelessWidget {
  final String? relativePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const PackImage({super.key, required this.relativePath, this.width, this.height, this.fit = BoxFit.cover, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(12);
    return ClipRRect(
      borderRadius: radius,
      child: FutureBuilder<File?>(
        future: ResourcePackService.instance.resolveImage(relativePath),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return _placeholder(loading: true);
          final file = snap.data;
          if (file == null) return _placeholder(loading: false);
          return Image.file(file, width: width, height: height, fit: fit, errorBuilder: (_, __, ___) => _placeholder(loading: false));
        },
      ),
    );
  }

  Widget _placeholder({required bool loading}) => Container(
        width: width,
        height: height,
        color: AppColors.creamDark,
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.saffron))
            : const Icon(Icons.menu_book_rounded, color: AppColors.gold, size: 28),
      );
}
