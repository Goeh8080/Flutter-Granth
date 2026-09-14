import 'package:flutter/material.dart';
import 'services/resource_pack_service.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'screens/pack_setup_screen.dart';

final themeController = ThemeController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ResourcePackService.instance.init();
  await themeController.load();
  runApp(const GranthViewerApp());
}

class GranthViewerApp extends StatelessWidget {
  const GranthViewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'ग्रंथ प्रबंधन',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.of(themeController.mode),
          home: const PackSetupScreen(),
        );
      },
    );
  }
}
