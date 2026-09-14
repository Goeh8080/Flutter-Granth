import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'server_image.dart';

class AdminListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imagePath;
  final List<String> tags;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminListTile({
    super.key,
    required this.title,
    required this.onEdit,
    required this.onDelete,
    this.subtitle,
    this.imagePath,
    this.tags = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ServerImage(relativePath: imagePath),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTheme.display(size: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (subtitle != null && subtitle!.trim().isNotEmpty)
                    Text(subtitle!, style: AppTheme.body(size: 12, color: AppColors.muted), maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (tags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Wrap(
                        spacing: 6,
                        children: tags.map((t) => Text(t, style: AppTheme.body(size: 10.5, color: AppColors.maroon))).toList(),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.edit_rounded, size: 20, color: AppColors.saffronDark),
                  onPressed: onEdit,
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.maroon),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
