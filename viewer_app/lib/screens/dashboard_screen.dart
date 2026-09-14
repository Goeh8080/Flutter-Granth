import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  final ResourcePack pack;
  final ValueChanged<int> onNavigate;

  const DashboardScreen({super.key, required this.pack, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _DashCard(icon: Icons.topic_rounded, color: AppColors.saffron, count: pack.topics.length, label: 'Topics', onTap: () => onNavigate(1)),
            _DashCard(icon: Icons.menu_book_rounded, color: AppColors.maroon, count: pack.granths.length, label: 'Granths', onTap: () => onNavigate(2)),
            _DashCard(icon: Icons.image_rounded, color: AppColors.gold, count: pack.pramans.length, label: 'Pramans', onTap: () => onNavigate(3)),
            _DashCard(icon: Icons.chat_bubble_rounded, color: AppColors.saffronDark, count: pack.feedbacks.length, label: 'Feedback', onTap: () => onNavigate(4)),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              const Icon(Icons.wifi_off_rounded, color: AppColors.muted),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Content here is stored on your device — browsing works with no internet. Tap the sync icon above to check for new content.',
                  style: AppTheme.body(size: 12, color: AppColors.muted),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int count;
  final String label;
  final VoidCallback onTap;

  const _DashCard({required this.icon, required this.color, required this.count, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$count', style: AppTheme.display(size: 22)),
                  Text(label, style: AppTheme.body(size: 12, color: AppColors.muted)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
