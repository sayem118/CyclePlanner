import 'dart:async';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/services/geolocator_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

Position get mockPosition =>
    Position(
        latitude: 55.561270,
        longitude: 0.17639382,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          500,
          isUtc: true,
        ),
        altitude: 3000.0,
        accuracy: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0);
    final  appProcesses = ApplicationProcesses();

void main() {
  GeolocatorPlatform.instance = MockGeolocatorPlatform();
  TestWidgetsFlutterBinding.ensureInitialized();
  group('MarkerService', () {

    test('setGroupSize', () async {
      const MethodChannel('flutter.baseflow.com/geolocator')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getCurrentPosition') {
          return{};
        }
        return {};
      });
      appProcesses.setGroupSize(2);
      //ensure the number 2 is set
      expect(appProcesses.groupSize, 2);

    });

    test('Remove Polylines', () async {
      const MethodChannel('flutter.baseflow.com/geolocator')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getCurrentPosition') {
          return null;
        }
        return {};
      });
      appProcesses.removePolyline();

      expect(appProcesses.polylines, []);
      expect(appProcesses.polyCoords, []);


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
  double distanceBetween(double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,) =>
      42;

  @override
  double bearingBetween(double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,) =>
      42;
}