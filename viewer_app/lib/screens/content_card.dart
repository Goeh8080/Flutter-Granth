import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'pack_image.dart';

class ContentCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imagePath;
  final List<String> tags;
  final VoidCallback? onTap;

  const ContentCard({super.key, required this.title, this.subtitle, this.imagePath, this.tags = const [], this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagePath != null)
              AspectRatio(
                aspectRatio: 16 / 10,
                child: PackImage(relativePath: imagePath, borderRadius: BorderRadius.zero, width: double.infinity),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTheme.display(size: 16, color: AppColors.maroon), maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(subtitle!, style: AppTheme.body(size: 12, color: AppColors.muted), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: tags
                          .map((t) => Chip(
                                label: Text(t, style: AppTheme.body(size: 10, color: AppColors.maroon)),
                                visualDensity: VisualDensity.compact,
                                backgroundColor: AppColors.maroon.withValues(alpha: 0.08),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
