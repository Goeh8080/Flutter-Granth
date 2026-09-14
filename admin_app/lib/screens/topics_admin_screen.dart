import 'dart:io';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import 'admin_list_tile.dart';
import 'image_picker_field.dart';

class TopicsAdminScreen extends StatefulWidget {
  const TopicsAdminScreen({super.key});

  @override
  State<TopicsAdminScreen> createState() => _TopicsAdminScreenState();
}

class _TopicsAdminScreenState extends State<TopicsAdminScreen> {
  List<Topic> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await ApiClient.instance.getTopics();
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not load topics. Pull down to retry.';
        _loading = false;
      });
    }
  }

  void _openForm({Topic? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _TopicForm(existing: existing, onSaved: _refresh),
    );
  }

  Future<void> _delete(Topic t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Topic?'),
        content: Text('This will remove "${t.title}" and update the live resource pack. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      await ApiClient.instance.deleteTopic(t.id);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add Topic'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? ListView(children: [Padding(padding: const EdgeInsets.all(24), child: Text(_error!, textAlign: TextAlign.center))])
                : _items.isEmpty
                    ? ListView(children: const [Padding(padding: EdgeInsets.all(24), child: Text('No topics yet — tap Add Topic to create one.'))])
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
                        itemCount: _items.length,
                        itemBuilder: (context, i) {
                          final t = _items[i];
                          return AdminListTile(
                            title: t.title,
                            subtitle: t.description,
                            imagePath: t.image,
                            onEdit: () => _openForm(existing: t),
                            onDelete: () => _delete(t),
                          );
                        },
                      ),
      ),
    );
  }
}

class _TopicForm extends StatefulWidget {
  final Topic? existing;
  final VoidCallback onSaved;
  const _TopicForm({this.existing, required this.onSaved});

  @override
  State<_TopicForm> createState() => _TopicFormState();
}

class _TopicFormState extends State<_TopicForm> {
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late final _desc = TextEditingController(text: widget.existing?.description ?? '');
  File? _image;
  bool _saving = false;
  String? _error;

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ApiClient.instance.saveTopic(
        id: widget.existing?.id,
        title: _title.text.trim(),
        description: _desc.text.trim(),
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
            Text(widget.existing == null ? 'Add Topic' : 'Edit Topic', style: AppTheme.display(size: 18)),
            const SizedBox(height: 14),
            if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: AppColors.maroon, fontSize: 12.5)),
              const SizedBox(height: 8),
            ],
            TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title *')),
            const SizedBox(height: 12),
            TextField(controller: _desc, maxLines: 3, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 12),
            ImagePickerField(existingPath: widget.existing?.image, onPicked: (f) => _image = f),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Save Topic'),
            ),
          ],
        ),
      ),
    );
  }
}
