import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';

class ManageAdminsScreen extends StatefulWidget {
  const ManageAdminsScreen({super.key});

  @override
  State<ManageAdminsScreen> createState() => _ManageAdminsScreenState();
}

class _ManageAdminsScreenState extends State<ManageAdminsScreen> {
  List<AdminAccount> _admins = [];
  final _user = TextEditingController();
  final _pass = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    try {
      final list = await ApiClient.instance.listAdmins();
      setState(() => _admins = list);
    } catch (_) {}
  }

  Future<void> _add() async {
    setState(() {
      _error = null;
      _busy = true;
    });
    try {
      await ApiClient.instance.createAdmin(_user.text.trim(), _pass.text);
      _user.clear();
      _pass.clear();
      await _refresh();
    } catch (e) {
      setState(() => _error = 'Could not create admin — username may already be taken, or password too short (min 6 chars).');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove(AdminAccount a) async {
    try {
      await ApiClient.instance.deleteAdmin(a.id);
      _refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not remove this admin.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Admins')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Add New Admin', style: AppTheme.display(size: 16)),
          const SizedBox(height: 10),
          if (_error != null) ...[
            Text(_error!, style: const TextStyle(color: AppColors.maroon, fontSize: 12.5)),
            const SizedBox(height: 8),
          ],
          TextField(controller: _user, decoration: const InputDecoration(labelText: 'Username')),
          const SizedBox(height: 10),
          TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: 'Password (min 6 chars)')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _busy ? null : _add,
            child: _busy
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Add Admin'),
          ),
          const SizedBox(height: 24),
          Text('Existing Admins', style: AppTheme.display(size: 16)),
          const SizedBox(height: 10),
          if (_admins.isEmpty) const Text('None yet.'),
          for (final a in _admins)
            Card(
              child: ListTile(
                title: Text(a.username),
                subtitle: a.createdAt != null ? Text('Added ${a.createdAt}') : null,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.maroon),
                  onPressed: () => _remove(a),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
