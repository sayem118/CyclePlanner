import 'dart:async';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/services/marker_service.dart';
import 'package:cycle_planner/services/places_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cycle_planner/models/location.dart';
import 'package:cycle_planner/models/geometry.dart';
import 'package:cycle_planner/models/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';


Position get mockPosition => Position(
    latitude: 52.561270,
    longitude: 5.639382,
    timestamp: DateTime.fromMillisecondsSinceEpoch(
      500,
      isUtc: true,
    ),
    altitude: 3000.0,
    accuracy: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0);

final appProcesses = ApplicationProcesses();

void main() {
  group('ApplicationProcess2', () {
    setUp(() {
      GeolocatorPlatform.instance = MockGeolocatorPlatform();
    });

    test('DrawRoute', () async {
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
      late PolylinePoints polylinePoints;
      late PolylineResult result;
      polylinePoints = PolylinePoints();
      appProcesses.bikeStations = [marker1, marker2];
      final PointLatLng markerA = PointLatLng(
          marker1.position.latitude, marker1.position.longitude);
      final PointLatLng markerB = PointLatLng(
          marker2.position.latitude, marker2.position.longitude);
      result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY",
        markerA,
        markerB,
        travelMode: TravelMode.bicycling,);


      late List<LatLng> nPoints = [];
      for (var point in result.points) {
        nPoints.add(LatLng(point.latitude, point.longitude));
      }
      final polylineGiven = Polyline(
          polylineId: const PolylineId("test"),
          points: nPoints,
          color: Colors.blue
      );
      polylineGiven;
      appProcesses.drawRoute();
      // for (int i = 1; i < appProcesses.bikeStations.length; i++) {
      //   late PolylinePoints polylinePoints;
      //   polylinePoints = PolylinePoints();
      //   final markerS =  appProcesses.bikeStations.elementAt(i - 1);
      //   final markerd =  appProcesses.bikeStations.elementAt(i);
      //   final PointLatLng marker1 = PointLatLng(
      //       markerd.position.latitude, markerd.position.longitude);
      //   final PointLatLng marker2 = PointLatLng(
      //       markerS.position.latitude, markerS.position.longitude);
      //
      //
      //   if (i == 1) {
      //     result = await polylinePoints.getRouteBetweenCoordinates(
      //       "AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY",
      //       marker1,
      //       marker2,
      //       travelMode: TravelMode.walking,);
      //   }
      //   else {
      //     result = await polylinePoints.getRouteBetweenCoordinates(
      //       "AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY",
      //       marker1,
      //       marker2,
      //       travelMode: TravelMode.bicycling,);
      expect(appProcesses.polylines, isA<Set<Polyline>>());
      expect(appProcesses.polylines, []);

    });




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





