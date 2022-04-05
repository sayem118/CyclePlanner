import 'dart:async';
import 'package:cycle_planner/models/bikestation.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/services/marker_service.dart';
import 'package:cycle_planner/services/places_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cycle_planner/models/location.dart';
import 'package:cycle_planner/models/geometry.dart';
import 'package:cycle_planner/models/place.dart';
import 'package:cycle_planner/models/place_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

final appProcesses = ApplicationProcesses();

Position get mockPosition => Position(
    latitude: 55.561270,
    longitude: 0.139382,
    timestamp: DateTime.fromMillisecondsSinceEpoch(
      500,
      isUtc: true,
    ),
    altitude: 3000.0,
    accuracy: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0);

void main() {
  setUp(() {
    GeolocatorPlatform.instance = MockGeolocatorPlatform();

    // // Markers initialised
    // const Marker a =
    // Marker(markerId: MarkerId("marker"), position: LatLng(55, 0.12));
    // const Marker b =
    // Marker(markerId: MarkerId("marker1"), position: LatLng(54, 0.15));
    //
    // const Marker c =
    // Marker(markerId: MarkerId("marker2"), position: LatLng(56, 0.17));
  });
  group('Application Processes tests', () {

    test('testing the Search results', () async {
      await appProcesses.searchPlaces("Westminster");

      expect(appProcesses.searchResults, isA<List<PlaceSearch>>());
    });

    test('Testing whethere the location selected is set', () async {
      await appProcesses.setSelectedLocation("ChIJc2nSALkEdkgRkuoJJBfzkUI");

      expect(appProcesses.searchResults, []);
      expect(appProcesses.selectedLocation, isA<StreamController<Place>>());
    });

    test('Testing the toggleMarker function if a string is returned', () async {
      await appProcesses.setSelectedLocation('ChIJlQh0H88adkgRT1sjAmMXQt4');
      await appProcesses.toggleMarker("ChIJlQh0H88adkgRT1sjAmMXQt4");
      expect(appProcesses.placeName, isA<String>());
    });

    test('Testing the toggleMarker function if publicBikeStations variable is emptied', () async {
      await appProcesses.toggleMarker("ChIJc2nSALkEdkgRkuoJJBfzkUI");
      expect(appProcesses.publicBikeStations.isEmpty, true);
    });

    test('Testing the toggleMarker function if a string is returned and if publicBikeStations variable is emptied',
      () async {
      await appProcesses.toggleMarker("ChIJc2nSALkEdkgRkuoJJBfzkUI");
      expect(appProcesses.placeName, isA<String>());
      expect(appProcesses.publicBikeStations.isEmpty, true);
    });

    test(
        'Testing the toggleMarker function if the specific place name is returned from input',
            () async {
          await appProcesses.toggleMarker("ChIJc2nSALkEdkgRkuoJJBfzkUI");
          expect(appProcesses.placeName, "ChIJc2nSALkEdkgRkuoJJBfzkUI");
        });

    test('Testing overall if toggleMarker function works', () async {
      PlacesService place = PlacesService();
      final markerService = MarkerService();

      appProcesses.toggleMarker("ChIJc2nSALkEdkgRkuoJJBfzkUI");

      expect(appProcesses.placeName, "ChIJc2nSALkEdkgRkuoJJBfzkUI");

      final mockLocation = Location(lat: 50.1109, lng: 8.6821);
      final mockGeometry = Geometry(location: mockLocation);
      appProcesses.selectedLocationStatic =
          Place(geometry: mockGeometry, name: "Test", vicinity: "Test");
      Place place1 = await place.getPlaceMarkers(
          appProcesses.selectedLocationStatic!.geometry.location.lat,
          appProcesses.selectedLocationStatic!.geometry.location.lng,
          appProcesses.placeName!);

      final newMarker = markerService.createMarkerFromPlace(place1);
      appProcesses.markers.add(newMarker);

      expect(appProcesses.markers, isA<List<Marker>>());

      final bounds1 =
      markerService.bounds(Set<Marker>.of(appProcesses.markers));
      appProcesses.bounds.add(bounds1!);
    });

    test('Testing if the group size is returned', () async {
      final groupSizeNum = appProcesses.groupSize;

      expect(appProcesses.getGroupSize(), groupSizeNum);
    });

    test('Testing if the route is drawn when that function is called',
            () async {
          // appProcesses.drawRoute();
          final mockLocation = Location(lat: 50.1109, lng: 8.6821);
          final mockGeometry = Geometry(location: mockLocation);
          final mockPlace =
          Place(geometry: mockGeometry, name: "Test", vicinity: "Test");
          final markerID = mockPlace.name;
          final marker1 = Marker(
              markerId: MarkerId(markerID),
              position: LatLng(mockPlace.geometry.location.lat,
                  mockPlace.geometry.location.lng));

          final mockLocation2 = Location(lat: 51.494720, lng: -0.135278);
          final mockGeometry2 = Geometry(location: mockLocation2);
          final mockPlace2 =
          Place(geometry: mockGeometry2, name: "Test2", vicinity: "Test2");
          final markerID2 = mockPlace2.name;
          final marker2 = Marker(
              markerId: MarkerId(markerID2),
              position: LatLng(mockPlace2.geometry.location.lat,
                  mockPlace2.geometry.location.lng));

          late PolylinePoints polylinePoints;
          late PolylineResult result;
          polylinePoints = PolylinePoints();
          appProcesses.bikeStations.add(marker1);
          appProcesses.bikeStations.add(marker2);
          final PointLatLng markerA =
          PointLatLng(marker1.position.latitude, marker1.position.longitude);
          final PointLatLng markerB =
          PointLatLng(marker2.position.latitude, marker2.position.longitude);

          result = await polylinePoints.getRouteBetweenCoordinates(
            "AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY",
            markerA,
            markerB,
            travelMode: TravelMode.bicycling,
          );

          late List<LatLng> nPoints = [];
          for (var point in result.points) {
            nPoints.add(LatLng(point.latitude, point.longitude));

            final polylineGiven = Polyline(
                polylineId: const PolylineId("test"),
                points: nPoints,
                color: Colors.blue);
            appProcesses.polylines.add(polylineGiven);
          }
          final polylineGiven1 = Polyline(
              polylineId: const PolylineId("test"),
              points: nPoints,
              color: Colors.blue);

          // appProcesses.polylines.add(polylineGiven);
          final ifPossibleDrawRoute = appProcesses.drawRoute();
          ifPossibleDrawRoute;
          // appProcesses.drawRoute();
          expect(appProcesses.polylines, isA<Set<Polyline>>());
          expect(appProcesses.polylines.first, polylineGiven1);
        });

    test('', () async {
      final mockLocation = Location(lat: 50.1109, lng: 8.6821);
      final mockGeometry = Geometry(location: mockLocation);
      final mockPlace =
      Place(geometry: mockGeometry, name: "Test", vicinity: "Test");

      final ifPossibleDrawRoute =
      appProcesses.drawNewRouteIfPossible(BuildContext);
      ifPossibleDrawRoute;
      expect(appProcesses.polylines, isA<Set<Polyline>>());
      // expect(appProcesses.polylines.first, polylineGiven1 );
    });

    test('testing a dispose function', () async {
      appProcesses.dispose();

      expect(appProcesses.selectedLocation.isClosed, true);
      expect(appProcesses.bounds.isClosed, true);
    });

    test('draw between markers', () async {
      late PolylinePoints polylinePoints;
      late PolylineResult result;
      polylinePoints = PolylinePoints();

      const marker1 =
      Marker(markerId: MarkerId("marker"), position: LatLng(51.5, 0.01));

      const marker2 =
      Marker(markerId: MarkerId("marker"), position: LatLng(51.5, 0.03));

      final PointLatLng markerA =
      PointLatLng(marker1.position.latitude, marker1.position.longitude);
      final PointLatLng markerB =
      PointLatLng(marker2.position.latitude, marker2.position.longitude);

      final PointLatLng markerC =
      PointLatLng(marker2.position.latitude, marker2.position.longitude);

      result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY",
        markerA,
        markerB,
        travelMode: TravelMode.bicycling,
      );

      late List<LatLng> nPoints = [];
      double stuff = 0;

      for (var point in result.points) {
        nPoints.add(LatLng(point.latitude, point.longitude));
        stuff = point.latitude + point.longitude;
      }

      result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY",
        markerA,
        markerC,
        travelMode: TravelMode.walking,
      );
      for (var point in result.points) {
        nPoints.add(LatLng(point.latitude, point.longitude));
        stuff = point.latitude + point.longitude;
      }

      double number = appProcesses.buildWaypoints(result, nPoints, stuff);
      appProcesses.polylineBetweenMarkers(2, stuff, nPoints);
      appProcesses.polylineBetweenMarkers(1, stuff, nPoints);
      appProcesses.buildWaypoints(result, nPoints, stuff);

      expect(appProcesses.polylines, isA<Set<Polyline>>());
      expect(number, isA<double>());
    });

    test('Testing toggleBikeMarker function', () async {

      final markerService = MarkerService();
      await appProcesses.toggleBikeMarker();

      expect(markerService.bikeMarker, isA<BitmapDescriptor>);
      expect(appProcesses.currentLocation, isA<Place>);
      expect(appProcesses.publicBikeStations, isA<List<Marker>>());
      expect(appProcesses.bounds, isA<StreamController<LatLngBounds>>());
    });

    testWidgets('show No Stations Final Stop Alert', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: alertDialogTest()
          )
        )
      );

      await tester.pumpAndSettle();
      Finder addButton = find.byIcon(Icons.add);

      await tester.tap(addButton);

      await tester.pumpAndSettle();

      Finder ok = find.byType(TextButton);

      await tester.tap(ok);

      await tester.pumpAndSettle();
    });

    testWidgets('show No Stations Final Stop Alert', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: alertDialogTest()
          )
        )
      );

      await tester.pumpAndSettle();

      Finder removeButton = find.byIcon(Icons.remove);

      await tester.tap(removeButton);

      await tester.pumpAndSettle();

      Finder ok = find.byType(TextButton);

      await tester.tap(ok);

      await tester.pumpAndSettle();
    });

    test('drawRouteIfPossible', () async {

      appProcesses.markers.isNotEmpty;
      appProcesses.polylines.isEmpty;
      appProcesses.drawNewRouteIfPossible(BuildContext);
      expect(appProcesses.currentLocation, isA<Position>());
      expect(appProcesses.bikeStations, isA<List<Marker>>());
      // expect(await appProcesses.showNoStationsFinalStopAlert(), showDialog<void>(
      //   context: context,
      //   barrierDismissible: false, // user must tap button!
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: const Text('No available bike stations near your final stop.'),
      //       content: SingleChildScrollView(
      //         child: ListBody(
      //           children: const <Widget>[
      //             Text('Try reordering your stops or changing your final stop.'),
      //           ],
      //         ),
      //       ),
      //       actions: <Widget>[
      //         TextButton(
      //           child: const Text('Ok'),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // );)
      Builder(builder: (BuildContext context) {
        appProcesses.drawNewRouteIfPossible(context);
        return Placeholder();
      });
      expect(appProcesses.timer?.isActive, 3);
  });
}

class MockGeolocatorPlatform extends Mock
    with
    // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        GeolocatorPlatform {
  @override
  Future<LocationPermission> checkPermission() =>
      Future.value(LocationPermission.whileInUse);

  @override
  Future<LocationPermission> requestPermission() =>
      Future.value(LocationPermission.whileInUse);

  @override
  Future<bool> isLocationServiceEnabled() => Future.value(true);

  @override
  Future<Position> getLastKnownPosition({
    bool forceLocationManager = false,
  }) =>
      Future.value(mockPosition);

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) =>
      Future.value(mockPosition);

  @override
  Stream<ServiceStatus> getServiceStatusStream() {
    return super.noSuchMethod(
      Invocation.method(
        #getServiceStatusStream,
        null,
      ),
      returnValue: Stream.value(ServiceStatus.enabled),
    );
  }

  @override
  Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #getPositionStream,
        null,
        <Symbol, Object?>{
          #desiredAccuracy: locationSettings?.accuracy ?? LocationAccuracy.best,
          #distanceFilter: locationSettings?.distanceFilter ?? 0,
          #timeLimit: locationSettings?.timeLimit ?? 0,
        },
      ),
      returnValue: Stream.value(mockPosition),
    );
  }

  @override
  Future<bool> openAppSettings() => Future.value(true);

  @override
  Future<LocationAccuracyStatus> getLocationAccuracy() =>
      Future.value(LocationAccuracyStatus.reduced);

  @override
  Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) =>
      Future.value(LocationAccuracyStatus.reduced);

  @override
  Future<bool> openLocationSettings() => Future.value(true);

  @override
  double distanceBetween(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) =>
      42;

  @override
  double bearingBetween(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) =>
      42;
}

class alertDialogTest extends StatefulWidget {
  const alertDialogTest({ Key? key }) : super(key: key);

  @override
  State<alertDialogTest> createState() => _alertDialogTestState();
}

class _alertDialogTestState extends State<alertDialogTest> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
          IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            appProcesses.showNoStationsFinalStopAlert(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            appProcesses.showNoStationsCurrentLocationAlert(context);
          },
        ),
      ]
    );
  }
}