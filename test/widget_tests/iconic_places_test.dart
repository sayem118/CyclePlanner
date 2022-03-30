import 'package:cycle_planner/widgets/iconic_places.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/widgets/iconic_places.dart';
import 'dart:io';

void main() {

  late Widget iconicScreen;

  setUpAll(() {
    HttpOverrides.global = null;
    iconicScreen = const Scaffold(
        body: IconicScreen()
    );
  });

  testWidgets('Iconic Screen created successfully', (WidgetTester tester) async {
    IconicScreen testIconicScreen = const IconicScreen(
    );
  });

  testWidgets('contains appropriate text', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(iconicScreen);

    // Search for list tiles in the tree and verify it exists.
    expect(find.text("Iconic Places"), findsOneWidget);
  });
}