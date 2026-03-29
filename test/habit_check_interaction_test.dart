import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/main.dart';

void main() {
  group('打卡交互测试', () {
    testWidgets('点击圆圈进行打卡，不显示加号按钮', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Switch to habit tab
      await tester.tap(find.text('习惯'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, '测试习惯');
      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();

      // 验证不显示加号按钮
      expect(find.byIcon(Icons.add_circle_outline), findsNothing);

      // 验证显示1个未打卡圆圈 (within card, excluding navigation)
      final card = find.byType(Card);
      expect(find.descendant(of: card, matching: find.byIcon(Icons.circle_outlined)), findsOneWidget);
    });

    testWidgets('点击未打卡圆圈变为已打卡', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Switch to habit tab
      await tester.tap(find.text('习惯'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, '测试习惯');
      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();

      // 点击未打卡圆圈
      await tester.tap(find.byIcon(Icons.circle_outlined).first);
      await tester.pumpAndSettle();

      // 验证变为已打卡 (within card, excluding navigation)
      final card = find.byType(Card);
      expect(find.descendant(of: card, matching: find.byIcon(Icons.check_circle)), findsOneWidget);
      expect(find.descendant(of: card, matching: find.byIcon(Icons.circle_outlined)), findsNothing);
    });
  });
}
