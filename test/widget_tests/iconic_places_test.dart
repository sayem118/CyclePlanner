import 'package:cycle_planner/widgets/iconic_places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

void main() {
  //const iconicCollection = "iconic-places";
  late Widget iconicScreen;

  setUpAll(() {
    HttpOverrides.global = null;
    iconicScreen = const MaterialApp(
        home: IconicScreen()
    );
  });

  //testWidgets('Iconic Screen created successfully', (WidgetTester tester) async {


    // await tester.pumpWidget(MaterialApp(
    //   home: Scaffold(
    //     appBar: AppBar(
    //         title: const Text("Iconic Places"),
    //     ),
    //   )
    // ));

    // await tester.pumpWidget(
    // const MaterialApp(
    //       home:IconicScreen( )
    //   ),
    // );
  //   Finder title = find.text("Iconic Places");
  //   expect(title, findsOneWidget);
  // });

  testWidgets('contains appropriate text', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(iconicScreen);

    // Search for list tiles in the tree and verify it exists.
    expect(find.text("Iconic Places"), findsOneWidget);
  });

}