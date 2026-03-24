import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/main.dart';

void main() {
  testWidgets('Check-in area has light green background', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '测试习惯');
    await tester.tap(find.text('确认'));
    await tester.pumpAndSettle();

    // Find Container with light green background
    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(Card),
        matching: find.byType(Container),
      ).first,
    );

    final decoration = container.decoration as BoxDecoration?;
    expect(decoration?.color, Colors.green[50]);
  });
}
