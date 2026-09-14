import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'pack_image.dart';
import '../services/resource_pack_service.dart';

class PramanDetailScreen extends StatelessWidget {
  final Praman praman;
  final ResourcePack pack;

  const PramanDetailScreen({super.key, required this.praman, required this.pack});

  String? _topicTitle() {
    final m = pack.topics.where((t) => t.id == praman.topicId);
    return m.isEmpty ? null : m.first.title;
  }

  String? _granthTitle() {
    final m = pack.granths.where((g) => g.id == praman.granthId);
    return m.isEmpty ? null : m.first.title;
  }

  Future<void> _openYoutube(BuildContext context) async {
    final url = praman.youtubeUrl;
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open the video link.')));
      }
    }
  }

  Future<void> _openFullscreenImage(BuildContext context) async {
    final file = await ResourcePackService.instance.resolveImage(praman.image);
    if (file == null || !context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white)),
          body: Center(child: InteractiveViewer(maxScale: 5, child: Image.file(file))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(praman.title, style: AppTheme.display(size: 18, color: AppColors.goldLight))),
      body: ListView(
        children: [
          if (praman.image != null)
            GestureDetector(
              onTap: () => _openFullscreenImage(context),
              child: AspectRatio(aspectRatio: 4 / 3, child: PackImage(relativePath: praman.image, borderRadius: BorderRadius.zero)),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(praman.title, style: AppTheme.display(size: 20)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (_topicTitle() != null) _Tag('📋 ${_topicTitle()}'),
                    if (_granthTitle() != null) _Tag('📚 ${_granthTitle()}'),
                  ],
                ),
                if (praman.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(praman.description, style: AppTheme.body(size: 14, color: AppColors.text)),
                ],
                if ((praman.youtubeUrl ?? '').isNotEmpty) ...[
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () => _openYoutube(context),
                    icon: const Icon(Icons.play_circle_fill_rounded),
                    label: const Text('Watch Reference Video'),
                  ),
                  if ((praman.youtubeDesc ?? '').isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(praman.youtubeDesc!, style: AppTheme.body(size: 13, color: AppColors.muted)),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.maroon.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.maroon.withValues(alpha: 0.15)),
      ),
      child: Text(text, style: AppTheme.body(size: 11.5, color: AppColors.maroon)),
    );
  }
}
