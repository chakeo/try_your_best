import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/main.dart';

void main() {
  group('MainScreen', () {
    testWidgets('should display bottom navigation with two tabs', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('任务'), findsOneWidget);
      expect(find.text('习惯'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('should switch between task and habit screens', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Initially on task screen
      expect(find.byIcon(Icons.timer), findsOneWidget);

      // Tap habit tab
      await tester.tap(find.text('习惯'));
      await tester.pumpAndSettle();

      // Should show habit screen
      expect(find.text('点击 + 添加第一个习惯'), findsOneWidget);

      // Tap task tab
      await tester.tap(find.text('任务'));
      await tester.pumpAndSettle();

      // Should show task screen
      expect(find.text('暂无任务，点击右下角添加'), findsOneWidget);
    });
  });
}
