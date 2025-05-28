// This is a basic Flutter widget test for the Tutorial Management App.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:tutorial_management_app/main.dart';

void main() {
  testWidgets('Tutorial Management App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(TutorialManagementApp());

    // Verify that the UI Showcase screen loads.
    expect(find.text('Tutorial Management UI Showcase'), findsOneWidget);
    
    // Verify that navigation buttons are present.
    expect(find.text('Tutorial List'), findsOneWidget);
    expect(find.text('Tutorial Detail'), findsOneWidget);
    expect(find.text('Add Tutorial'), findsOneWidget);
    expect(find.text('Analytics Dashboard'), findsOneWidget);
  });
}
