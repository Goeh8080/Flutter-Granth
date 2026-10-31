import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:granthprabandhan/main.dart';
import 'package:granthprabandhan/state/router.dart';
import 'helpers.dart';

Future<void> settle(WidgetTester t, [int n = 14]) async {
  for (var i = 0; i < n; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  setUp(setUpApp);

  for (final w in [320.0, 411.0]) {
    testWidgets('bottom tabs: profile is 3rd, opens Account, no overflow at ${w.toInt()}dp', (t) async {
      t.view.physicalSize = Size(w * 2, 1400);
      t.view.devicePixelRatio = 2;
      addTearDown(t.view.reset);
      await t.pumpWidget(const GranthApp(splash: false, links: false));
      await settle(t);
      expect(find.byKey(const ValueKey('bottom-tabs')), findsOneWidget);
      expect(find.byKey(const ValueKey('tab-profile-avatar')), findsOneWidget);
      // Signed out: person icon fallback, inside the 3rd tab.
      expect(find.descendant(of: find.byKey(const ValueKey('tab-2')), matching: find.byKey(const ValueKey('tab-profile-avatar'))), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('tab-2')));
      await settle(t);
      expect(AppNav.I.route.legalPage, 'account');
      await t.tap(find.byKey(const ValueKey('tab-1')));
      await settle(t);
      expect(AppNav.I.route.panel, Panel.topics);
      await t.tap(find.byKey(const ValueKey('tab-0')));
      await settle(t);
      expect(AppNav.I.route.panel, Panel.dashboard);
      expect(t.takeException(), isNull);
    });
  }
}
