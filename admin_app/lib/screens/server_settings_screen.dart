import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';

class ServerSettingsScreen extends StatefulWidget {
  const ServerSettingsScreen({super.key});

  @override
  State<ServerSettingsScreen> createState() => _ServerSettingsScreenState();
}

class _ServerSettingsScreenState extends State<ServerSettingsScreen> {
  late final _url = TextEditingController(text: ApiClient.instance.baseUrl);
  String? _message;

  Future<void> _save() async {
    await ApiClient.instance.setBaseUrl(_url.text.trim());
    setState(() => _message = 'Saved. You may need to log in again.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Server Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Backend Server URL', style: AppTheme.display(size: 16)),
            const SizedBox(height: 6),
            Text(
              'The address where your granth-server is running, e.g. https://your-app.onrender.com (no trailing slash).',
              style: AppTheme.body(size: 12, color: AppColors.muted),
            ),
            const SizedBox(height: 14),
            TextField(controller: _url, decoration: const InputDecoration(labelText: 'Server URL')),
            if (_message != null) ...[
              const SizedBox(height: 10),
              Text(_message!, style: AppTheme.body(size: 12, color: AppColors.saffronDark)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
