import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/services/mapbox_navigation_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cycle_planner/models/location.dart';
import 'package:cycle_planner/models/geometry.dart';
import 'package:cycle_planner/models/place.dart';

final navigation = MapboxNavigationService();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // var routeEventHandler;
  // late final ApplicationProcesses applicationProcesses;
  // var wayPoints = <WayPoint>[];
  //
  // final _directions = MapBoxNavigation(onRouteEvent: routeEventHandler);

  group('NavigationService', () {
    test('returns options present)', () async {
      final optionsGiven = navigation.options;

      expect(navigation.getOptions(), optionsGiven);
    });

    test('returns directions present', () async {
      final directionsGiven = navigation.directions;

      expect(navigation.getDirections(), directionsGiven);
    });

    test('add Waypoints', () async {
      // final wayPointsGiven = navigation.wayPoints;
      final mockWayPoint = WayPoint(
          name: "westminster", latitude: 51.4974948, longitude: -0.1356583);
      navigation.addStop(mockWayPoint);
      expect(navigation.wayPoints, <WayPoint>[mockWayPoint]);
    });

    test('mapBoxBegin', () async {
      const MethodChannel('flutter_mapbox_navigation')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'finishNavigation') {
          return false;
        }
        return "";
      });
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

      final mockLocation2 = Location(lat: 51.494720, lng: -0.135278);
      final mockGeometry2 = Geometry(location: mockLocation2);
      final mockPlace2 =
          Place(geometry: mockGeometry2, name: "Test2", vicinity: "Test2");
      final markerID2 = mockPlace2.name;
      final marker2 = Marker(
          markerId: MarkerId(markerID2),
          draggable: false,
          visible: true,
          infoWindow:
              InfoWindow(title: mockPlace2.name, snippet: mockPlace2.vicinity),
          position: LatLng(mockPlace2.geometry.location.lat,
              mockPlace2.geometry.location.lng));

      List<Marker> markersPresent = [marker1, marker2];
      final wayPointsTemp = navigation.wayPoints;

      navigation.mapboxBegin(markersPresent);
      for (var stop in markersPresent) {
        wayPointsTemp.add(WayPoint(
            name: stop.markerId.toString(),
            latitude: stop.position.latitude,
            longitude: stop.position.longitude));

        expect(
            await navigation.directions.startNavigation(
                wayPoints: wayPointsTemp, options: navigation.options),
            null);
        expect(await navigation.directions.finishNavigation(), false);

      }
    });








  });
}
