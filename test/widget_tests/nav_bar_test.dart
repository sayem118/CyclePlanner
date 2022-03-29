import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/widgets/nav_bar.dart';
import 'dart:io';

void main() {
  group("Navbar -", () {
    late Widget navbar;

    setUpAll(() {
      HttpOverrides.global = null;
      navbar = const MaterialApp(
        home: NavBar()
      );
    });

    testWidgets('contains list tiles', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(navbar);

      // Search for list tiles in the tree and verify it exists.
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('Place sharp icon', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(navbar);

      // Create the finder
      final placesIcon = find.byIcon(Icons.place_sharp);

      // Search for the place_sharp icon in the tree and verify it exists.
      expect(placesIcon, findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('favorite icon', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(navbar);

      // Create the finder
      final favoriteIcon = find.byIcon(Icons.favorite);

      // Search for the favorite icon in the tree and verify it exists.
      expect(favoriteIcon, findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('info icon', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(navbar);
      
      // Create the finder
      final infoIcon = find.byIcon(Icons.info);

      // Search for the info icon in the tree and verify it exists.
      expect(infoIcon, findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('exit icon', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(navbar);

      // Create the finder
      final exitIcon = find.byIcon(Icons.exit_to_app);

      // Search for the exit icon in the tree and verify it exists.
      expect(exitIcon, findsOneWidget);
      
      // await tester.tap(exitIcon);

      await tester.pumpAndSettle();
    });
  });
}