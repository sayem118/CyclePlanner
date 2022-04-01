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

import 'dart:async';
import 'package:cycle_planner/processes/application_processes.dart';
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
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

final appProcesses = ApplicationProcesses();

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

void main() {
  setUp(() {
    GeolocatorPlatform.instance = MockGeolocatorPlatform();
  });
  group('MarkerService', () {

    test('setGroupSize', () async {
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

    test('testing the Search results', () async {
      await appProcesses.searchPlaces("Westminster");

      expect(appProcesses.searchResults, isA<List<PlaceSearch>>());
    });

    test('setLocationSelected', () async {
      await appProcesses.setSelectedLocation("ChIJc2nSALkEdkgRkuoJJBfzkUI");

      expect(appProcesses.searchResults, []);
      expect(appProcesses.selectedLocation, isA<StreamController<Place>>());
    });

    test('toggleMarker', () async {
      await appProcesses.toggleMarker("ChIJc2nSALkEdkgRkuoJJBfzkUI");
      expect(appProcesses.placeName, isA<String>());
    });

    test('', () async {
      PlacesService place = PlacesService();
      final markerService = MarkerService();

      appProcesses.toggleMarker("ChIJc2nSALkEdkgRkuoJJBfzkUI");


      expect(appProcesses.placeName, isA<String>());

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

      final bounds1 = markerService.bounds(Set<Marker>.of(appProcesses.markers));
      appProcesses.bounds.add(bounds1!);



    });


    // test('toggleMarker', ()  {
    //   appProcesses.toggleMarker("westminster");
    //
    //   expect(appProcesses.placeName, "westminster");
    // });

    // test('', () async {
    //   PlacesService place = PlacesService();
    //   final markerService = MarkerService();
    //
    //   appProcesses.toggleMarker("westminster");
    //
    //
    //   expect(appProcesses.placeName, "westminster");
    //
    //   final mockLocation = Location(lat: 50.1109, lng: 8.6821);
    //   final mockGeometry = Geometry(location: mockLocation);
    //   appProcesses.selectedLocationStatic =
    //       Place(geometry: mockGeometry, name: "Test", vicinity: "Test");
    //   Place place1 = await place.getPlaceMarkers(
    //       appProcesses.selectedLocationStatic!.geometry.location.lat,
    //       appProcesses.selectedLocationStatic!.geometry.location.lng,
    //       appProcesses.placeName!);
    //
    //   var newMarker = markerService.createMarkerFromPlace(place1);
    //   appProcesses.markers.add(newMarker);
    //
    //   expect(appProcesses.markers, isA<List<Marker>>);


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