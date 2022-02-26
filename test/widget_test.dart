// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cycle_planner/main.dart';

void main() {
  group('Widget Tests', () {
    testWidgets(
        'Group size page is loaded correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that our counter starts at 1.
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);
      //Verify the correct texts are displayed
      expect(find.text('Group size'), findsOneWidget);
      expect(find.text('Start Route'), findsOneWidget);

      //Verify the group size will not decrement to 0
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);

      // Tap the '+' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify that our counter has incremented.
      expect(find.text('1'), findsNothing);
      expect(find.text('2'), findsOneWidget);

      // Tap the '-' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      // Verify that our counter has decremented.
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets(
        'Route page is loaded correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      //Verify navigation is on page.
      expect(find.byType(MapBoxNavigationView), findsOneWidget);

    });

  });
}
