import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';

class ServerImage extends StatelessWidget {
  final String? relativePath;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ServerImage({super.key, required this.relativePath, this.width = 56, this.height = 56, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(10);
    if (relativePath == null || relativePath!.isEmpty) {
      return ClipRRect(
        borderRadius: radius,
        child: Container(
          width: width,
          height: height,
          color: AppColors.creamDark,
          child: const Icon(Icons.image_rounded, color: AppColors.gold),
        ),
      );
    }
    return ClipRRect(
      borderRadius: radius,
      child: Image.network(
        ApiClient.instance.imageUrl(relativePath),
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: AppColors.creamDark,
            alignment: Alignment.center,
            child: const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
        errorBuilder: (context, error, stack) => Container(
          width: width,
          height: height,
          color: AppColors.creamDark,
          child: const Icon(Icons.broken_image_rounded, color: AppColors.gold),
        ),
      ),
    );
  }
}
