import 'package:cycle_planner/widgets/search_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void main() {

  late Widget searchbar;
  const testKey = Key('K');

  setUpAll(() {
    HttpOverrides.global = null;
    searchbar = const MaterialApp(
        key: testKey,
        home: SearchBar()
    );
  });

  testWidgets('SearchBar created successfully', (WidgetTester tester) async {
    SearchBar testSearchBar = const SearchBar(
    );
  });

  testWidgets('Testing for SearchBar created using key', (WidgetTester tester) async {
    // Define the test key.
    const testKey = Key('K');

    // Build a MaterialApp with the testKey.
    await tester.pumpWidget(MaterialApp(key: testKey, home: Container()));

    // Find the MaterialApp widget using the testKey.
    expect(find.byKey(testKey), findsOneWidget);
  });

  testWidgets('contains child row', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(searchbar);

    // Search for the row in the tree and verify it exists.
    expect(find.byType(Row), findsOneWidget);
  });

  testWidgets('Tests for padding within Container', (WidgetTester tester) async {
    const childWidget = Padding(padding: EdgeInsets.all(5));

    // Provide the padding to the Container.
    await tester.pumpWidget(Container(child: childWidget));

    // Search for the padding in the tree and verify it exists.
    expect(find.byWidget(childWidget), findsOneWidget);
  });

  testWidgets('contains child column', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(searchbar);

    // Search for the column in the tree and verify it exists.
    expect(find.byType(Column), findsOneWidget);
  });

  testWidgets('Finding Text Widget in App', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(searchbar);

    // Search for the TextField in the tree and verify it exists.
    expect(find.byType(TextField), findsOneWidget);
    //Mock a search
    await tester.tap(find.byType(TextField));
    //await tester.pump();
    //??? What to check for after search

  });

}