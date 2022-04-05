import 'package:cycle_planner/widgets/info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import our widget

void main() {
  testWidgets('testing listview widget', (WidgetTester tester) async {
    // the items to add to list
    List<String> listItems = ["item 1", "item 2", "item 3"];

    //start the widget
    await tester.pumpWidget(
        MaterialApp(home: ListAppWidget(listItems))
    );
  });
  }