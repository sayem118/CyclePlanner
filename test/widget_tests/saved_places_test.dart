import 'package:cycle_planner/widgets/saved_places.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  late Widget savedPlaces;

  setUpAll(() {
    HttpOverrides.global = null;
    savedPlaces = const MaterialApp(
        home: SavedPlaces()
    );
  });

  testWidgets('contains AppBar', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(savedPlaces);

    // Search for AppBar in the tree and verify it exists.
    expect(find.byWidget(AppBar()), findsOneWidget);
  });
}