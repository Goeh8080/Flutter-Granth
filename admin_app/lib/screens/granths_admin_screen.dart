import 'dart:io';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import 'admin_list_tile.dart';
import 'image_picker_field.dart';

class GranthsAdminScreen extends StatefulWidget {
  const GranthsAdminScreen({super.key});

  @override
  State<GranthsAdminScreen> createState() => _GranthsAdminScreenState();
}

class _GranthsAdminScreenState extends State<GranthsAdminScreen> {
  List<Granth> _items = [];
  List<Topic> _topics = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      final items = await ApiClient.instance.getGranths();
      final topics = await ApiClient.instance.getTopics();
      setState(() {
        _items = items;
        _topics = topics;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _openForm({Granth? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _GranthForm(existing: existing, topics: _topics, onSaved: _refresh),
    );
  }

  Future<void> _delete(Granth g) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Granth?'),
        content: Text('This will remove "${g.title}". Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      await ApiClient.instance.deleteGranth(g.id);
      _refresh();
    }
  }

  String? _topicName(String? id) {
    if (id == null) return null;
    final m = _topics.where((t) => t.id == id);
    return m.isEmpty ? null : m.first.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add Granth'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _items.isEmpty
                ? ListView(children: const [Padding(padding: EdgeInsets.all(24), child: Text('No granths yet — tap Add Granth to create one.'))])
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
                    itemCount: _items.length,
                    itemBuilder: (context, i) {
                      final g = _items[i];
                      final topicName = _topicName(g.topicId);
                      return AdminListTile(
                        title: g.title,
                        subtitle: g.description,
                        imagePath: g.image,
                        tags: [if (topicName != null) '📋 $topicName'],
                        onEdit: () => _openForm(existing: g),
                        onDelete: () => _delete(g),
                      );
                    },
                  ),
      ),
    );
  }
}

class _GranthForm extends StatefulWidget {
  final Granth? existing;
  final List<Topic> topics;
  final VoidCallback onSaved;
  const _GranthForm({this.existing, required this.topics, required this.onSaved});

  @override
  State<_GranthForm> createState() => _GranthFormState();
}

class _GranthFormState extends State<_GranthForm> {
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late final _desc = TextEditingController(text: widget.existing?.description ?? '');
  File? _image;
  String? _topicId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _topicId = widget.existing?.topicId;
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      await ApiClient.instance.saveGranth(
        id: widget.existing?.id,
        title: _title.text.trim(),
        description: _desc.text.trim(),
        topicId: _topicId,
        image: _image,
      );
      widget.onSaved();
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.existing == null ? 'Add Granth' : 'Edit Granth', style: AppTheme.display(size: 18)),
            const SizedBox(height: 14),
            TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title *')),
            const SizedBox(height: 12),
            TextField(controller: _desc, maxLines: 3, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _topicId,
              decoration: const InputDecoration(labelText: 'Topic (optional)'),
              items: [
                const DropdownMenuItem(value: null, child: Text('— None —')),
                ...widget.topics.map((t) => DropdownMenuItem(value: t.id, child: Text(t.title))),
              ],
              onChanged: (v) => setState(() => _topicId = v),
            ),
            const SizedBox(height: 12),
            ImagePickerField(existingPath: widget.existing?.image, onPicked: (f) => _image = f),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Save Granth'),
            ),
          ],
        ),
      ),
    );
  }
}
