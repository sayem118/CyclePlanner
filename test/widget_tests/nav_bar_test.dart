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

    testWidgets('Iconic Places text', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(navbar);

      // Create the finder
      final iconicPlacesText = find.text('Iconic places');

      // Search for the Iconic places text in the tree and verify it exists.
      expect(iconicPlacesText, findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('Saved places text', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(navbar);

      // Create the finder
      final savedPlacesText = find.text('Saved places');

      // Search for the Saved places text in the tree and verify it exists.
      expect(savedPlacesText, findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('Info text', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(navbar);

      // Create the finder
      final infoText = find.text('Info');

      // Search for the Info text in the tree and verify it exists.
      expect(infoText, findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('Exit text', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(navbar);

      // Create the finder
      final exitText = find.text('Exit');

      // Search for the exit text in the tree and verify it exists.
      expect(exitText, findsOneWidget);

      await tester.pumpAndSettle();
    });
  });
}