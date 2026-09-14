import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import 'admin_list_tile.dart';

class FeedbackAdminScreen extends StatefulWidget {
  const FeedbackAdminScreen({super.key});

  @override
  State<FeedbackAdminScreen> createState() => _FeedbackAdminScreenState();
}

class _FeedbackAdminScreenState extends State<FeedbackAdminScreen> {
  List<FeedbackItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      final items = await ApiClient.instance.getFeedback();
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _delete(FeedbackItem f) async {
    await ApiClient.instance.deleteFeedback(f.id);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No feedback submitted yet. Feedback sent from the Viewer app appears here live.',
                        textAlign: TextAlign.center,
                        style: AppTheme.body(size: 13, color: AppColors.muted),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _items.length,
                  itemBuilder: (context, i) {
                    final f = _items[i];
                    return AdminListTile(
                      title: f.description,
                      imagePath: f.image,
                      onEdit: () {},
                      onDelete: () => _delete(f),
                    );
                  },
                ),
    );
  }
}
