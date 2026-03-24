import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/widgets/header_widget.dart';

void main() {
  testWidgets('HeaderWidget displays date and encouragement', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: HeaderWidget())),
    );

    // Should display "新的一天" text
    expect(find.text('新的一天'), findsOneWidget);

    // Should display "加油哟" text
    expect(find.text('加油哟'), findsOneWidget);

    // Should display current date in format like "2026年3月24日"
    expect(find.textContaining('年'), findsWidgets);
    expect(find.textContaining('月'), findsWidgets);
    expect(find.textContaining('日'), findsWidgets);
  });

  testWidgets('HeaderWidget displays lunar date', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: HeaderWidget())),
    );

    // Should display lunar date text (农历)
    expect(find.textContaining('农历'), findsOneWidget);
  });
}
