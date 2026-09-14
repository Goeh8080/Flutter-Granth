import 'package:flutter/material.dart';
import '../services/resource_pack_service.dart';
import '../theme/app_theme.dart';
import 'home_shell.dart';
import 'server_settings_screen.dart';

class PackSetupScreen extends StatefulWidget {
  const PackSetupScreen({super.key});

  @override
  State<PackSetupScreen> createState() => _PackSetupScreenState();
}

class _PackSetupScreenState extends State<PackSetupScreen> {
  double _progress = 0;
  String _status = 'Checking for content…';
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    if (await ResourcePackService.instance.hasLocalPack) {
      _goHome();
      return;
    }
    await _sync();
  }

  Future<void> _sync() async {
    setState(() {
      _failed = false;
      _progress = 0;
      _status = 'Downloading Granth content…';
    });
    try {
      await ResourcePackService.instance.syncNow(onProgress: (p) => setState(() => _progress = p));
      _goHome();
    } catch (e) {
      setState(() {
        _failed = true;
        _status = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeShell()));
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
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('ग्रंथ प्रबंधन', style: AppTheme.display(size: 34, color: AppColors.goldLight)),
                      const SizedBox(height: 8),
                      Text('Granth Management System', style: AppTheme.body(size: 13, color: Colors.white.withValues(alpha: 0.7))),
                      const SizedBox(height: 40),
                      if (!_failed) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _progress > 0 ? _progress : null,
                            minHeight: 8,
                            backgroundColor: Colors.white.withValues(alpha: 0.12),
                            valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(_status, textAlign: TextAlign.center, style: AppTheme.body(size: 12.5, color: Colors.white.withValues(alpha: 0.75))),
                      ] else ...[
                        Icon(Icons.wifi_off_rounded, color: AppColors.goldLight.withValues(alpha: 0.8), size: 40),
                        const SizedBox(height: 12),
                        Text(_status, textAlign: TextAlign.center, style: AppTheme.body(size: 13, color: Colors.white)),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(onPressed: _sync, icon: const Icon(Icons.refresh), label: const Text('Retry')),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServerSettingsScreen())),
                          child: const Text('Check Server Address', style: TextStyle(color: Colors.white70)),
                        ),
                      ],
                    ],
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
