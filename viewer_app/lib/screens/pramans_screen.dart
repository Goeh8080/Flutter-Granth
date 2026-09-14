import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'content_card.dart';
import 'praman_detail_screen.dart';

class PramansScreen extends StatefulWidget {
  final ResourcePack pack;
  final String? filterTopicId;
  final String? filterGranthId;
  final String? title;

  const PramansScreen({super.key, required this.pack, this.filterTopicId, this.filterGranthId, this.title});

  @override
  State<PramansScreen> createState() => _PramansScreenState();
}

class _PramansScreenState extends State<PramansScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    var items = widget.pack.pramans.where((p) {
      if (widget.filterTopicId != null && p.topicId != widget.filterTopicId) return false;
      if (widget.filterGranthId != null && p.granthId != widget.filterGranthId) return false;
      if (_query.isNotEmpty && !p.title.toLowerCase().contains(_query.toLowerCase())) return false;
      return true;
    }).toList();

    final body = Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search pramans…'),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('No pramans found', style: TextStyle(color: Colors.black45)))
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final praman = items[i];
                    return ContentCard(
                      title: praman.title,
                      subtitle: praman.description,
                      imagePath: praman.image,
                      tags: [if ((praman.youtubeUrl ?? '').isNotEmpty) '▶ Video'],
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PramanDetailScreen(praman: praman, pack: widget.pack))),
                    );
                  },
                ),
        ),
      ],
    );

    if (widget.title != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title!, style: AppTheme.display(size: 18, color: AppColors.goldLight))),
        body: body,
      );
    }
    return body;
  }
}
