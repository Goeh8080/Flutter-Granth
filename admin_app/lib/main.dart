import 'package:flutter/material.dart';
import 'services/api_client.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'screens/login_screen.dart';

final themeController = ThemeController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.instance.init();
  await themeController.load();
  runApp(const GranthAdminApp());
}

class GranthAdminApp extends StatelessWidget {
  const GranthAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'ग्रंथ प्रबंधन — Admin',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.of(themeController.mode),
          home: const LoginScreen(),
        );
      },
    );
  }
}
