import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import 'admin_shell.dart';
import 'server_settings_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _user = TextEditingController(text: 'amit8080');
  final _pass = TextEditingController();
  String? _error;
  bool _busy = false;

  Future<void> _login() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final username = await ApiClient.instance.login(_user.text.trim(), _pass.text);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => AdminShell(username: username)));
    } catch (e) {
      setState(() => _error = _friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('SocketException') || msg.contains('connection')) {
      return 'Could not reach the server. Check the server URL in Settings and your connection.';
    }
    if (msg.contains('401')) return 'Incorrect username or password.';
    return 'Login failed. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.header),
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.settings_rounded, color: Colors.white70),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServerSettingsScreen())),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(18)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('ग्रंथ प्रबंधन', style: AppTheme.display(size: 26, color: AppColors.maroon), textAlign: TextAlign.center),
                        Text('Admin Login', style: AppTheme.body(size: 13, color: AppColors.muted), textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        if (_error != null) ...[
                          Text(_error!, style: const TextStyle(color: AppColors.maroon, fontSize: 12.5)),
                          const SizedBox(height: 8),
                        ],
                        TextField(controller: _user, decoration: const InputDecoration(labelText: 'Username')),
                        const SizedBox(height: 12),
                        TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _busy ? null : _login,
                          child: _busy
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Login'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Default: amit8080 / amit8080 — change this after first login.',
                          style: AppTheme.body(size: 11, color: AppColors.muted),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
