import 'package:flutter/material.dart';
import '../models/models.dart';
import 'content_card.dart';
import 'pramans_screen.dart';

class GranthsScreen extends StatefulWidget {
  final ResourcePack pack;
  const GranthsScreen({super.key, required this.pack});

  @override
  State<GranthsScreen> createState() => _GranthsScreenState();
}

class _GranthsScreenState extends State<GranthsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final items = widget.pack.granths.where((g) => g.title.toLowerCase().contains(_query.toLowerCase())).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search granths…'),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('No granths found', style: TextStyle(color: Colors.black45)))
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.78,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final g = items[i];
                    return ContentCard(
                      title: g.title,
                      subtitle: g.description,
                      imagePath: g.image,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PramansScreen(pack: widget.pack, filterGranthId: g.id, title: g.title)),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
