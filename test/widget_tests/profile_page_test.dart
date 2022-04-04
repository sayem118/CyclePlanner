import 'package:cycle_planner/widgets/profile_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  late Widget profilePage;

  setUpAll(() {
    HttpOverrides.global = null;
    profilePage = const MaterialApp(
        home: ProfilePage()
    );
  });

  testWidgets('ProfilePage created successfully', (WidgetTester tester) async {
    ProfilePage testProfilePage= const ProfilePage(
    );
  });

  testWidgets('contains AppBar', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(profilePage);

    // Search for AppBar in the tree and verify it exists.
    expect(find.byWidget(AppBar()), findsOneWidget);
  });

}