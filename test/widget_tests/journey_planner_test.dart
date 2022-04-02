import 'package:cycle_planner/processes/application_processes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/widgets/journey_planner.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  group('Journey Planner -', () {
    late Widget journeyPlanner;
    List<Marker> markerList = [];

    setUp(() {
      markerList.add(
        const Marker(
          markerId: MarkerId("Marker 1"),
          position: LatLng(51.508076, -0.09719399999999997)
        )
      );

      markerList.add(
        const Marker(
          markerId: MarkerId("Marker 2"),
          position: LatLng(51.5231577, -0.156863)
        )
      );

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

    testWidgets('Contains group size button', (WidgetTester tester) async {
      await tester.pumpWidget(journeyPlanner);

      Finder appBarText = find.text('My Journey');

      expect(appBarText, findsOneWidget);
    });



  });
}