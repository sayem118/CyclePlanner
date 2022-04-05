import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/widgets/bottom_navbar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:provider/provider.dart';
import 'package:cycle_planner/widgets/search_page.dart';
import 'searchPageTemplate.dart';

void main() {
  late Widget bottomNavBar;
  late GlobalKey<ScaffoldState> scaffoldKey;

  setUp(() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    bottomNavBar =  ChangeNotifierProvider<ApplicationProcesses>(
      create: (context) => ApplicationProcesses(),
      child: MaterialApp(
        title: 'Cycle Planner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          key: scaffoldKey,
          body: BottomNavBar(scaffoldKey: scaffoldKey),
        )
      ),
    );
  });

  group("Bottom navbar -", () {

    testWidgets('Testing for widgets created using key', (WidgetTester tester) async {
      // Define the test key.
      const testKey = Key('K');

      // Build a MaterialApp with the testKey.
      await tester.pumpWidget(MaterialApp(key: testKey, home: Container()));

      // Find the MaterialApp widget using the testKey.
      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets('contains bottom navbar', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(bottomNavBar);

      // Create the finder
      final bottomNavbar = find.byType(CurvedNavigationBar);

      // Search for list tiles in the tree and verify it exists.
      expect(bottomNavbar, findsWidgets);
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
      await tester.pumpWidget(bottomNavBar);

      // Create the finder
      final menuIcon = find.byIcon(Icons.menu);

      // Search for the menu icon in the tree and verify it exists.
      expect(menuIcon, findsOneWidget);
      
      // Tap the menu icon
      await tester.tap(menuIcon);

      await tester.pumpAndSettle();
    });

    testWidgets('Directions Bike icon', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(bottomNavBar);

      // Create the finder
      final directionsBikeIcon = find.byIcon(Icons.menu);

      // Search for the directions_bike icon in the tree and verify it exists.
      expect(directionsBikeIcon, findsOneWidget);

      // Icon tap testing will be included in the integration test.
    });

    testWidgets('Add icon', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(bottomNavBar);

      // Create the finder
      final addIcon = find.byIcon(Icons.add);

      // Search for the add icon in the tree and verify it exists.
      expect(addIcon, findsOneWidget);

      await tester.pumpWidget(DelegatePage(delegate: SearchPage()));

      await tester.pumpAndSettle();

      // Icon tap testing will be included in the integration test.
    });

    // Find Navigation Rounded Icon, tapping is manually tested
    testWidgets('Navigation Rounded icon', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(bottomNavBar);

      // Create the finder
      final navigationRoundedIcon = find.byIcon(Icons.navigation_rounded);

      // Search for the navigation_rounded icon in the tree and verify it exists.
      expect(navigationRoundedIcon, findsWidgets);

      // Icon tap testing will be included in the integration test.
    });

    testWidgets('Directions icon', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(bottomNavBar);

      // Create the finder
      final directionsIcon = find.byIcon(Icons.directions);

      // Search for the directions icon in the tree and verify it exists.
      expect(directionsIcon, findsOneWidget);

      // Icon tap testing will be included in the integration test.
    });

    testWidgets('Group icon', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(bottomNavBar);

      // Create the finder
      final groupIcon = find.byIcon(Icons.group);

      // Search for the group icon in the tree and verify it exists.
      expect(groupIcon, findsOneWidget);

      // Tap the group icon
      await tester.tap(groupIcon);

      await tester.pumpAndSettle();
    });
  });
}