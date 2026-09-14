import 'package:flutter/material.dart';
import '../main.dart';
import '../models/models.dart';
import '../services/resource_pack_service.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'topics_screen.dart';
import 'granths_screen.dart';
import 'pramans_screen.dart';
import 'feedback_screen.dart';
import 'server_settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  ResourcePack _pack = ResourcePack.empty();
  bool _loading = true;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final pack = await ResourcePackService.instance.loadLocal();
    if (!mounted) return;
    setState(() {
      _pack = pack;
      _loading = false;
    });
  }

  Future<void> _checkForUpdates() async {
    setState(() => _syncing = true);
    try {
      final available = await ResourcePackService.instance.isUpdateAvailable();
      if (available) {
        await ResourcePackService.instance.syncNow();
        await _load();
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Content updated!')));
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You already have the latest content.')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not check for updates. Are you online?')));
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.saffron)));
    }

    final screens = [
      DashboardScreen(pack: _pack, onNavigate: (i) => setState(() => _index = i)),
      TopicsScreen(pack: _pack),
      GranthsScreen(pack: _pack),
      PramansScreen(pack: _pack),
      FeedbackScreen(pack: _pack),
    ];
    const titles = ['Dashboard', 'Topics', 'Granths', 'Pramans', 'Feedback'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
        actions: [
          IconButton(
            icon: _syncing
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.sync_rounded),
            onPressed: _syncing ? null : _checkForUpdates,
            tooltip: 'Check for updates',
          ),
          PopupMenuButton<AppThemeMode>(
            icon: const Icon(Icons.palette_rounded),
            onSelected: (m) => themeController.setMode(m),
            itemBuilder: (context) => const [
              PopupMenuItem(value: AppThemeMode.light, child: Text('Light')),
              PopupMenuItem(value: AppThemeMode.dark, child: Text('Dark')),
              PopupMenuItem(value: AppThemeMode.liquid, child: Text('Liquid Glass')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.dns_rounded),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServerSettingsScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(color: AppColors.saffron, onRefresh: _load, child: screens[_index]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.topic_rounded), label: 'Topics'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Granths'),
          BottomNavigationBarItem(icon: Icon(Icons.image_rounded), label: 'Pramans'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Feedback'),
        ],
      ),
    );
  }
}
