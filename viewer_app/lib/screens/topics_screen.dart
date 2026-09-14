import 'package:flutter/material.dart';
import '../models/models.dart';
import 'content_card.dart';
import 'pramans_screen.dart';

class TopicsScreen extends StatefulWidget {
  final ResourcePack pack;
  const TopicsScreen({super.key, required this.pack});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final items = widget.pack.topics.where((t) => t.title.toLowerCase().contains(_query.toLowerCase())).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search topics…'),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('No topics found', style: TextStyle(color: Colors.black45)))
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.82,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final t = items[i];
                    return ContentCard(
                      title: t.title,
                      subtitle: t.description,
                      imagePath: t.image,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PramansScreen(pack: widget.pack, filterTopicId: t.id, title: t.title)),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
