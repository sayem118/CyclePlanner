import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/views/home_screen.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:provider/provider.dart';

void main() {
  group("Bottom nav bar", () {
    Widget homeScreen =  ChangeNotifierProvider(
      create: (context) => ApplicationProcesses(),
      child: MaterialApp(
        title: 'Cycle Planner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );

    testWidgets(
      'Testing for widgets created using key', (WidgetTester tester) async {
      // Define the test key.
      const testKey = Key('K');

      // Build a MaterialApp with the testKey.
      await tester.pumpWidget(MaterialApp(key: testKey, home: Container()));

      // Find the MaterialApp widget using the testKey.
      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets('Check child widgets are placed', (WidgetTester tester) async {
      const childWidget = Padding(padding: EdgeInsets.zero);

      // Provide the childWidget to the Container.
      await tester.pumpWidget(Container(child: childWidget));

      // Search for the childWidget in the tree and verify it exists.
      expect(find.byWidget(childWidget), findsOneWidget);
    });

    testWidgets('Menu icon', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(homeScreen);

      // Search for the menu icon in the tree and verify it exists.
      await tester.tap(find.byIcon(Icons.menu));
    });

    testWidgets('Directions Bike icon', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(homeScreen);

      // Search for the directions bike icon in the tree and verify it exists.
      await tester.tap(find.byIcon(Icons.directions_bike));
    });

    testWidgets('Add icon', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(homeScreen);

      // Search for the add icon in the tree and verify it exists.
      await tester.tap(find.byIcon(Icons.add));
    });

    //Navigation Rounded Icon is manually tested

    testWidgets('Directions icon', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(homeScreen);

      // Search for the directions icon in the tree and verify it exists.
      await tester.tap(find.byIcon(Icons.directions));
    });

    testWidgets('Group icon', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(homeScreen);

      // Search for the group icon in the tree and verify it exists.
      await tester.tap(find.byIcon(Icons.group));
    });
  });
}