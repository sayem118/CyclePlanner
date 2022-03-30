import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/services/bike_station_service.dart';

void main() {
  BikeStationService bikeStations = BikeStationService();
  group('BikeStationService', () {
    test('returns closest bike stations to latitude and longitude given)',
        () async {
// Check whether getClosestStations function returns
// a list of closest stations
      var test = await bikeStations.getClosestStations(51.5, 0.12);

      expect(test, isA<List>());
    });
    test('getStationWithBikes', () async {
      var test = await bikeStations.getStationWithBikes(55.1109, 0.12821, 1);
      expect(test, {});
    });
    test('getStationWithSpaces', () async {
      var test = await bikeStations.getStationWithSpaces(55.1109, 0.15, 3);
      expect(test, {});
    });
    test('Get filtered data', () async {
      var test = bikeStations.filterData(
          await bikeStations.getClosestStations(
            55.1109,
            0.15,
          ),
          6,
          10);
      expect(test, {});
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
