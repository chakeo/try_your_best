import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/main.dart';

void main() {
  group('打卡总天数测试', () {
    testWidgets('显示打卡总天数', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '测试习惯');
      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();

      // 验证显示目标天数21
      expect(find.textContaining('目标 21 天'), findsOneWidget);

      // 打卡一次
      await tester.tap(find.byIcon(Icons.circle_outlined));
      await tester.pumpAndSettle();

      // 验证仍显示目标天数21
      expect(find.textContaining('目标 21 天'), findsOneWidget);
    });
  });
}
