// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:valentine_app/main.dart';

void main() {
  testWidgets('Valentine app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ValentineApp());

    // Verify that we start with the toggle screen
    expect(find.text('Start Experience ✨'), findsOneWidget);
    expect(find.text('Dear Elizabeth...'), findsNothing);

    // Tap the start button
    await tester.tap(find.text('Start Experience ✨'));
    await tester.pumpAndSettle(); // Wait for animations

    // Verify that we are now on the home screen
    expect(find.text('Dear Elizabeth...'), findsOneWidget);
  });
}
