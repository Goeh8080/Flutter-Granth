import 'dart:io';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import 'admin_list_tile.dart';
import 'image_picker_field.dart';

class PramansAdminScreen extends StatefulWidget {
  const PramansAdminScreen({super.key});

  @override
  State<PramansAdminScreen> createState() => _PramansAdminScreenState();
}

class _PramansAdminScreenState extends State<PramansAdminScreen> {
  List<Praman> _items = [];
  List<Topic> _topics = [];
  List<Granth> _granths = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      final items = await ApiClient.instance.getPramans();
      final topics = await ApiClient.instance.getTopics();
      final granths = await ApiClient.instance.getGranths();
      setState(() {
        _items = items;
        _topics = topics;
        _granths = granths;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _openForm({Praman? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _PramanForm(existing: existing, topics: _topics, granths: _granths, onSaved: _refresh),
    );
  }

  Future<void> _delete(Praman p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Praman?'),
        content: Text('This will remove "${p.title}". Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      await ApiClient.instance.deletePraman(p.id);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add Praman'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _items.isEmpty
                ? ListView(children: const [Padding(padding: EdgeInsets.all(24), child: Text('No pramans yet — tap Add Praman to create one.'))])
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
                    itemCount: _items.length,
                    itemBuilder: (context, i) {
                      final p = _items[i];
                      return AdminListTile(
                        title: p.title,
                        subtitle: p.description,
                        imagePath: p.image,
                        tags: [if ((p.youtubeUrl ?? '').isNotEmpty) '▶ Video'],
                        onEdit: () => _openForm(existing: p),
                        onDelete: () => _delete(p),
                      );
                    },
                  ),
      ),
    );
  }
}

class _PramanForm extends StatefulWidget {
  final Praman? existing;
  final List<Topic> topics;
  final List<Granth> granths;
  final VoidCallback onSaved;
  const _PramanForm({this.existing, required this.topics, required this.granths, required this.onSaved});

  @override
  State<_PramanForm> createState() => _PramanFormState();
}

class _PramanFormState extends State<_PramanForm> {
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late final _desc = TextEditingController(text: widget.existing?.description ?? '');
  late final _ytUrl = TextEditingController(text: widget.existing?.youtubeUrl ?? '');
  late final _ytDesc = TextEditingController(text: widget.existing?.youtubeDesc ?? '');
  late final _ytStart = TextEditingController(text: widget.existing?.youtubeStart?.toString() ?? '');
  File? _image;
  String? _topicId;
  String? _granthId;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _topicId = widget.existing?.topicId;
    _granthId = widget.existing?.granthId;
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty || _topicId == null || _granthId == null) {
      setState(() => _error = 'Title, Topic and Granth are required.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ApiClient.instance.savePraman(
        id: widget.existing?.id,
        title: _title.text.trim(),
        description: _desc.text.trim(),
        topicId: _topicId,
        granthId: _granthId,
        youtubeUrl: _ytUrl.text.trim().isEmpty ? null : _ytUrl.text.trim(),
        youtubeDesc: _ytDesc.text.trim().isEmpty ? null : _ytDesc.text.trim(),
        youtubeStart: int.tryParse(_ytStart.text.trim()),
        image: _image,
      );
      widget.onSaved();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _error = 'Could not save. Check your connection and try again.');
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
            Text(widget.existing == null ? 'Add Praman' : 'Edit Praman', style: AppTheme.display(size: 18)),
            const SizedBox(height: 14),
            if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: AppColors.maroon, fontSize: 12.5)),
              const SizedBox(height: 8),
            ],
            TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title *')),
            const SizedBox(height: 12),
            TextField(controller: _desc, maxLines: 3, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _topicId,
              decoration: const InputDecoration(labelText: 'Topic *'),
              items: widget.topics.map((t) => DropdownMenuItem(value: t.id, child: Text(t.title))).toList(),
              onChanged: (v) => setState(() => _topicId = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _granthId,
              decoration: const InputDecoration(labelText: 'Granth *'),
              items: widget.granths.map((g) => DropdownMenuItem(value: g.id, child: Text(g.title))).toList(),
              onChanged: (v) => setState(() => _granthId = v),
            ),
            const SizedBox(height: 16),
            Text('YouTube Reference (optional)', style: AppTheme.body(size: 12.5, color: AppColors.muted)),
            const SizedBox(height: 8),
            TextField(controller: _ytUrl, decoration: const InputDecoration(labelText: 'YouTube URL')),
            const SizedBox(height: 12),
            TextField(controller: _ytStart, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Start time (seconds)')),
            const SizedBox(height: 12),
            TextField(controller: _ytDesc, maxLines: 2, decoration: const InputDecoration(labelText: 'YouTube description')),
            const SizedBox(height: 16),
            ImagePickerField(existingPath: widget.existing?.image, label: 'Upload Praman Image', onPicked: (f) => _image = f),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Save Praman'),
            ),
          ],
        ),
      ),
    );
  }
}
