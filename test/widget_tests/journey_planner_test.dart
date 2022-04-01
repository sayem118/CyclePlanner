import 'package:cycle_planner/processes/application_processes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/widgets/journey_planner.dart';
import 'package:provider/provider.dart';

void main() {
  group('Journey Planner -', () {
    late Widget journeyPlanner;

    setUp(() {
      journeyPlanner =  ChangeNotifierProvider(
        create: (context) => ApplicationProcesses(),
        child: MaterialApp(
          title: 'Cycle Planner',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const JourneyPlanner(),
        ),
      );
    });

    testWidgets('Journey Planner loads', (WidgetTester tester) async {
      await tester.pumpWidget(journeyPlanner);

      expect(true, true);
    });

    testWidgets('contains appBar', (WidgetTester tester) async {
      await tester.pumpWidget(journeyPlanner);

      Finder appBar = find.byType(AppBar);

      expect(appBar, findsOneWidget);
    });

    testWidgets('appBar text', (WidgetTester tester) async {
      await tester.pumpWidget(journeyPlanner);

      Finder appBarText = find.text('My Journey');

      expect(appBarText, findsOneWidget);
    });
  });
}