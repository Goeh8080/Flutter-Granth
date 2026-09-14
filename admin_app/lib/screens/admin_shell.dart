import 'package:flutter/material.dart';
import '../main.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';
import 'topics_admin_screen.dart';
import 'granths_admin_screen.dart';
import 'pramans_admin_screen.dart';
import 'feedback_admin_screen.dart';
import 'manage_admins_screen.dart';
import 'server_settings_screen.dart';
import 'login_screen.dart';

class AdminShell extends StatefulWidget {
  final String username;
  const AdminShell({super.key, required this.username});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const TopicsAdminScreen(),
      const GranthsAdminScreen(),
      const PramansAdminScreen(),
      const FeedbackAdminScreen(),
    ];
    const titles = ['Topics', 'Granths', 'Pramans', 'Feedback'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(child: Text('👤 ${widget.username}', style: AppTheme.body(size: 12, color: AppColors.goldLight))),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(gradient: AppGradients.header),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('ग्रंथ प्रबंधन', style: AppTheme.display(size: 22, color: AppColors.goldLight)),
                ),
              ),
              for (int i = 0; i < titles.length; i++)
                ListTile(
                  title: Text(titles[i]),
                  selected: _index == i,
                  onTap: () {
                    setState(() => _index = i);
                    Navigator.pop(context);
                  },
                ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings_rounded),
                title: const Text('Manage Admins'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageAdminsScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.dns_rounded),
                title: const Text('Server Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ServerSettingsScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.palette_rounded),
                title: const Text('Appearance'),
                onTap: () {
                  Navigator.pop(context);
                  _showThemePicker(context);
                },
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: AppColors.maroon),
                title: const Text('Logout', style: TextStyle(color: AppColors.maroon)),
                onTap: () async {
                  await ApiClient.instance.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
                  }
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.topic_rounded), label: 'Topics'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Granths'),
          NavigationDestination(icon: Icon(Icons.image_rounded), label: 'Pramans'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_rounded), label: 'Feedback'),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text('Appearance', style: AppTheme.display(size: 16)),
            const SizedBox(height: 8),
            RadioListTile<AppThemeMode>(
              title: const Text('Light'),
              value: AppThemeMode.light,
              groupValue: themeController.mode,
              onChanged: (v) {
                themeController.setMode(v!);
                Navigator.pop(ctx);
              },
            ),
            RadioListTile<AppThemeMode>(
              title: const Text('Dark'),
              value: AppThemeMode.dark,
              groupValue: themeController.mode,
              onChanged: (v) {
                themeController.setMode(v!);
                Navigator.pop(ctx);
              },
            ),
            RadioListTile<AppThemeMode>(
              title: const Text('Liquid Glass'),
              value: AppThemeMode.liquid,
              groupValue: themeController.mode,
              onChanged: (v) {
                themeController.setMode(v!);
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
