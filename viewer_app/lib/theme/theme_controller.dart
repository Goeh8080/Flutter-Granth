import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

class ThemeController extends ChangeNotifier {
  static const _kKey = 'app_theme_mode';
  AppThemeMode _mode = AppThemeMode.light;
  AppThemeMode get mode => _mode;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    _mode = AppThemeMode.values.firstWhere((e) => e.name == raw, orElse: () => AppThemeMode.light);
    notifyListeners();
  }

  Future<void> setMode(AppThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, mode.name);
  }
}

/// Full-screen gradient background used only in Liquid mode, so glass
/// cards on top of it have something colorful to refract.
class LiquidBackdrop extends StatelessWidget {
  final Widget child;
  const LiquidBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppGradients.liquidBackground),
      child: child,
    );
  }
}

/// A frosted-glass card: blurred translucent surface with a soft border.
/// Falls back to a normal Card automatically outside Liquid mode by
/// simply not being used there (screens choose based on ThemeController).
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: child,
        ),
      ),
    );
  }
}
