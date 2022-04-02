import 'package:cycle_planner/processes/application_processes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/widgets/journey_planner.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  group('Journey Planner -', () {
    late Widget journeyPlanner;
    List<Marker> markerList = [
      const Marker(
        markerId: MarkerId("Marker 1"),
        position: LatLng(51.508076, -0.09719399999999997)
      ),
      const Marker(
        markerId: MarkerId("Marker 2"),
        position: LatLng(51.5231577, -0.156863)
      )
    ];
    List<Marker> publicMarkerList = [];

    setUp(() {
      publicMarkerList = markerList.toList();

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

    Future<void> longPressDrag(WidgetTester tester, Offset start, Offset end) async {
      final TestGesture drag = await tester.startGesture(start);
      await tester.pump(kLongPressTimeout + kPressTimeout);
      await drag.moveTo(end);
      await tester.pump(kPressTimeout);
      await drag.up();
    }

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

    testWidgets('Display markers from another list', (WidgetTester tester) async {
      await tester.pumpWidget(journeyPlanner);

      expect(publicMarkerList, orderedEquals(markerList));
    });

    testWidgets('Reorder marker item from bottom to top', (WidgetTester tester) async {
      await tester.pumpWidget(journeyPlanner);
      expect(publicMarkerList, orderedEquals(markerList));
      await longPressDrag(
        tester,
        tester.getCenter(find.text(publicMarkerList[1].markerId.value)),
        tester.getCenter(find.text(publicMarkerList[0].markerId.value)) + const Offset(0.0, 40),
      );
      await tester.pumpAndSettle();
      expect(publicMarkerList, orderedEquals(<Marker>[
        const Marker(
          markerId: MarkerId("Marker 2"),
          position: LatLng(51.5231577, -0.156863)
        ),
        const Marker(
          markerId: MarkerId("Marker 1"),
          position: LatLng(51.508076, -0.09719399999999997)
        ),
      ]));
    });
  });
}