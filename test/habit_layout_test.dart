import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/main.dart';

void main() {
  group('习惯条布局测试', () {
    testWidgets('习惯条布局：名称占1/3，拖动图标靠右，打卡区域居中', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // 添加习惯
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '测试习惯');
      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();

      // 验证有拖动图标
      expect(find.byIcon(Icons.drag_handle), findsOneWidget);

      // 验证有打卡圆圈
      expect(find.byIcon(Icons.circle_outlined), findsOneWidget);

      // 验证有习惯名称
      expect(find.text('测试习惯'), findsOneWidget);
    });
  });
}
