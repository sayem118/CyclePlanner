import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/widgets/google_map_page.dart';
import 'package:cycle_planner/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:cycle_planner/widgets/search_bar.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:provider/provider.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  //setup
  late Widget mapPage;
  final Completer<GoogleMapController> _mapController = Completer();
  final applicationProcesses = ApplicationProcesses();


  setUpAll(() {
    mapPage = MaterialApp(
        home: GoogleMapPage(mapController: _mapController, applicationProcesses: applicationProcesses)
    );
  });


  testWidgets('contains stack', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(mapPage);

    // Search for the row in the tree and verify it exists.
    expect(find.byType(Stack), findsOneWidget);
  });


}
