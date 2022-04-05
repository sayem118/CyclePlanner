import 'package:cycle_planner/widgets/info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Widget infoPage;

  setUp(() {
    infoPage = MaterialApp(
      home: InfoPage()
    );
  });

  group('Info page -', () {
    testWidgets('info page loads', (WidgetTester tester) async {
      await tester.pumpWidget(infoPage);

      expect(true, true);
    });

    testWidgets('User can see 4 cards', (WidgetTester tester) async {
      await tester.pumpWidget(infoPage);

      Finder cards = find.byType(Card);

      expect(cards, findsNWidgets(4));
    });
  });
}