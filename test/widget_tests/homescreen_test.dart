import 'package:cycle_planner/Widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/main.dart';

void main() {
  testWidgets('finds a widget using a Key', (WidgetTester tester) async {
    // Define the test key.
    const testKey = Key('K');

    // Build a MaterialApp with the testKey.
    await tester.pumpWidget(MaterialApp(key: testKey, home: Container()));

    // Find the MaterialApp widget using the testKey.
    expect(find.byKey(testKey), findsOneWidget);
  });

  testWidgets('finds a specific instance', (WidgetTester tester) async {
    const childWidget = Padding(padding: EdgeInsets.zero);

    // Provide the childWidget to the Container.
    await tester.pumpWidget(Container(child: childWidget));

    // Search for the childWidget in the tree and verify it exists.
    expect(find.byWidget(childWidget), findsOneWidget);
  });


  // testWidgets(
  //
  //     'Group size page is loaded correctly', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //    await tester.pumpWidget(const MyApp());
  //
  //   // // Verify that our counter starts at 1.
  //   expect(find.byWidget(const NavBar()), findsOneWidget);
  //   expect(find.text('1'), findsOneWidget);
  //   //Verify the correct texts are displayed
  //   expect(find.text('Start Route'), findsOneWidget);
  //
  //   //Verify the group size will not decrement to 0
  //   await tester.tap(find.byIcon(Icons.remove));
  //   await tester.pump();
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('1'), findsNothing);
  //   expect(find.text('2'), findsOneWidget);
  //
  //   // Tap the '-' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.remove));
  //   await tester.pump();
  //
  //   // Verify that our counter has decremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
}