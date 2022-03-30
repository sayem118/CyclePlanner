import 'package:cycle_planner/services/marker_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cycle_planner/models/location.dart';
import 'package:cycle_planner/models/geometry.dart';
import 'package:cycle_planner/models/place.dart';

void main() {
  MarkerService serviceMarker = MarkerService();
  // var routeEventHandler;
  // late final ApplicationProcesses applicationProcesses;
  // var wayPoints = <WayPoint>[];
  //
  // final _directions = MapBoxNavigation(onRouteEvent: routeEventHandler);
  // final _options = MapBoxOptions(
  //   initialLatitude: 53.1424,
  //   initialLongitude: 7.6921,
  //   zoom: 15,
  //   tilt: 0.0,
  //   bearing: 0.0,
  //   enableRefresh: true,
  //   alternatives: true,
  //   voiceInstructionsEnabled: true,
  //   bannerInstructionsEnabled: true,
  //   allowsUTurnAtWayPoints: true,
  //   mode: MapBoxNavigationMode.cycling,
  //   units: VoiceUnits.imperial,
  //   simulateRoute: false,
  //   animateBuildRoute: true,
  //   longPressDestinationEnabled: false,
  //   language: "en",
  // );

  group('MarkerService', () {
    test('Null value given when bound is empty', () async {
      // final boundsGiven = serviceMarker.bounds(<Marker>{});

      expect(serviceMarker.bounds(<Marker>{}), null);
    });
    test('create bounds method return', () async {
      var m1 = const LatLng(50.1108, 8.6821);
      var m2 = const LatLng(54.1108, 8.3821);
      List<LatLng> positions = [];
      positions.add(m1);
      positions.add(m2);
      expect(serviceMarker.createBounds(positions), isA<LatLngBounds>());
    });

    test('Create Marker from Place given', () async {
      final mockLocation = Location(lat: 50.1109, lng: 8.6821);
      final mockGeometry = Geometry(location: mockLocation);
      final mockPlace =
          Place(geometry: mockGeometry, name: "Test", vicinity: "Test");
      final markerID = mockPlace.name;
      final createMarker = serviceMarker.createMarkerFromPlace(mockPlace);
      expect(
          createMarker,
          Marker(
              markerId: MarkerId(markerID),
              draggable: false,
              visible: true,
              infoWindow: InfoWindow(
                  title: mockPlace.name, snippet: mockPlace.vicinity),
              position: LatLng(mockPlace.geometry.location.lat,
                  mockPlace.geometry.location.lng)));
    });



  });
}
