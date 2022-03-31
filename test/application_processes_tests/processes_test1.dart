import 'dart:async';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/services/marker_service.dart';
import 'package:cycle_planner/services/places_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cycle_planner/models/location.dart';
import 'package:cycle_planner/models/geometry.dart';
import 'package:cycle_planner/models/place.dart';
import 'package:cycle_planner/models/place_search.dart';

final appProcesses = ApplicationProcesses();



void main() {

  group('MarkerService', ()
  {
    test('setGroupSize', () async {

      TestWidgetsFlutterBinding.ensureInitialized();
      appProcesses.setGroupSize(2);
      //ensure the number 2 is set
      expect(appProcesses.groupSize, 2);
    });

    test('Remove Polylines', () async {
      appProcesses.removePolyline();

      expect(appProcesses.polylines, []);
      expect(appProcesses.polyCoords, []);
    });

    test('Remove a marker', () async {
      final mockLocation = Location(lat: 50.1109, lng: 8.6821);
      final mockGeometry = Geometry(location: mockLocation);
      final mockPlace =
      Place(geometry: mockGeometry, name: "Test", vicinity: "Test");
      final markerID = mockPlace.name;
      final marker1 = Marker(
          markerId: MarkerId(markerID),
          draggable: false,
          visible: true,
          infoWindow:
          InfoWindow(title: mockPlace.name, snippet: mockPlace.vicinity),
          position: LatLng(mockPlace.geometry.location.lat,
              mockPlace.geometry.location.lng));

      final addedMarker = appProcesses.markers;

      addedMarker.add(marker1);
      appProcesses.removeMarker(0);

      expect(addedMarker, []);
    });

  });

}