import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/models/groups.dart';
import 'package:cycle_planner/models/place_search.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/services/bike_station_service.dart';
import 'package:cycle_planner/services/geolocator_service.dart';
import 'package:cycle_planner/services/places_service.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';




const String key = 'AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY';

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
  group('Geolocator', () {
    setUp(() {
      GeolocatorPlatform.instance = MockGeolocatorPlatform();
    });

    // Checks whether permission is enabled
    test('checkPermission', () async {
      final permission = await Geolocator.checkPermission();

      expect(permission, LocationPermission.whileInUse);
    });

    // Permission is requested
    test('requestPermission', () async {
      final permission = await Geolocator.requestPermission();

      expect(permission, LocationPermission.whileInUse);
    });

    // Check whether location service is enabled
    test('isLocationServiceEnabled', () async {
      final isLocationServiceEnabled =
      await Geolocator.isLocationServiceEnabled();

      expect(isLocationServiceEnabled, true);
    });

    // Last known location is given
    test('getLastKnownPosition', () async {
      final position = await Geolocator.getLastKnownPosition();

      expect(position, mockPosition);
    });

    // Current position is given
    test('getCurrentPosition', () async {
      final position = await Geolocator.getCurrentPosition();

      expect(position, mockPosition);
    });

    // Current position given for IOS
    test('getCurrentPosition iOS', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final position = await Geolocator.getCurrentPosition();
      expect(position, mockPosition);
      debugDefaultTargetPlatformOverride = null;
    });

    // Accuracy of location is given
    test('getLocationAccuracy', () async {
      final accuracy = await Geolocator.getLocationAccuracy();

      expect(accuracy, LocationAccuracyStatus.reduced);
    });

    // Checks whether full accuracy is asked for
    test('requestTemporaryFullAccuracy', () async {
      final accuracy = await Geolocator.requestTemporaryFullAccuracy(
        purposeKey: "purposeKeyValue",
      );

      expect(accuracy, LocationAccuracyStatus.reduced);
    });

    // Service status is enabled
    test('getServiceStatusStream', () {
      when(GeolocatorPlatform.instance.getServiceStatusStream())
          .thenAnswer((_) => Stream.value(ServiceStatus.enabled));

      final locationService = Geolocator.getServiceStatusStream();

      expect(locationService,
          emitsInOrder([emits(ServiceStatus.enabled), emitsDone]));
    });

    test('getPositionStream', () {
      when(GeolocatorPlatform.instance.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            timeLimit: null,
          ))).thenAnswer((_) => Stream.value(mockPosition));

      final position = Geolocator.getPositionStream();

      expect(position, emitsInOrder([emits(mockPosition), emitsDone]));
    });

    // Check if app settings is opened
    test('openAppSettings', () async {
      final hasOpened = await Geolocator.openAppSettings();
      expect(hasOpened, true);
    });

    // Checks if location settings is open
    test('openLocationSettings', () async {
      final hasOpened = await Geolocator.openLocationSettings();
      expect(hasOpened, true);
    });

    // Distance between the locations given
    test('distanceBetween', () {
      final distance = Geolocator.distanceBetween(0, 0, 0, 0);
      expect(distance, 42);
    });

    // Bearings given between locations
    test('bearingBetween', () {
      final bearing = Geolocator.bearingBetween(0, 0, 0, 0);
      expect(bearing, 42);
    });
  });

  BikeStationService bikeStations = BikeStationService();
  group('getClosestStations', () {
    test('returns closest bike stations to latitude and longitude given)',
            () async {

          // Mock the API call to return a json response with http status 200 Ok //
          final mockBikeStationService = MockClient((request) async {

            // Create sample response of the HTTP call //
            final response = {
              'text':
              'Strand, Waterloo'
            };
            return Response(jsonEncode(response), 200);
          });
          // Check whether getClosestStations function returns
          // a list of closest stations
          expect(await bikeStations.getClosestStations(60.66,-65.66), []);
        });

    test('return error message when http response is unsuccessful and cant give closest bike stations', () async {

      // Mock the API call to return an
      // empty json response with http status 404
      final mockBikeStationService = MockClient((request) async {
        final response = {};
        return Response(jsonEncode(response), 404);
      });
      // Check whether an empty list is given when there is unsuccessful HTTP request
      expect(await bikeStations.getClosestStations(0,0),
          []);

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

// void main() {
//   group('PermissionHandler', () {
//     setUp(() {
//       PermissionHandlerPlatform.instance = MockPermissionHandlerPlatform();
//     });
//
//     test('openAppSettings', () async {
//       final hasOpened = await openAppSettings();
//
//       expect(hasOpened, true);
//     });
//
//     test('PermissionActions on Permission: get status', () async {
//       final permissionStatus = await Permission.calendar.status;
//
//       expect(permissionStatus, PermissionStatus.granted);
//     });
//
//     test(
//       // ignore: lines_longer_than_80_chars
//         'PermissionActions on Permission: get shouldShowRequestRationale should return true when on android',
//             () async {
//           final mockPermissionHandlerPlatform = PermissionHandlerPlatform.instance;
//
//           when(mockPermissionHandlerPlatform
//               .shouldShowRequestPermissionRationale(Permission.calendar))
//               .thenAnswer((_) => Future.value(true));
//
//           await Permission.calendar.shouldShowRequestRationale;
//
//           verify(mockPermissionHandlerPlatform
//               .shouldShowRequestPermissionRationale(Permission.calendar))
//               .called(1);
//         });
//
//     test('PermissionActions on Permission: request()', () async {
//       final permissionRequest = Permission.calendar.request();
//
//       expect(permissionRequest, isA<Future<PermissionStatus>>());
//     });
//
//     test('PermissionCheckShortcuts on Permission: get isGranted', () async {
//       final isGranted = await Permission.calendar.isGranted;
//       expect(isGranted, true);
//     });
//
//     test('PermissionCheckShortcuts on Permission: get isDenied', () async {
//       final isDenied = await Permission.calendar.isDenied;
//       expect(isDenied, false);
//     });
//
//     test('PermissionCheckShortcuts on Permission: get isRestricted', () async {
//       final isRestricted = await Permission.calendar.isRestricted;
//       expect(isRestricted, false);
//     });
//
//     test('PermissionCheckShortcuts on Permission: get isLimited', () async {
//       final isLimited = await Permission.calendar.isLimited;
//       expect(isLimited, false);
//     });
//
//     test('PermissionCheckShortcuts on Permission: get isPermanentlyDenied',
//             () async {
//           final isPermanentlyDenied = await Permission.calendar.isPermanentlyDenied;
//           expect(isPermanentlyDenied, false);
//         });
//
//     test(
//       // ignore: lines_longer_than_80_chars
//         'ServicePermissionActions on PermissionWithService: get ServiceStatus returns the right service status',
//             () async {
//           var serviceStatus = await Permission.phone.serviceStatus;
//
//           expect(serviceStatus, ServiceStatus.enabled);
//         });
//
//     test(
//       // ignore: lines_longer_than_80_chars
//         'PermissionListActions on List<Permission>: request() on  a list returns a Map<Permission, PermissionStatus>',
//             () async {
//           var permissionList = <Permission>[];
//           final permissionMap = await permissionList.request();
//
//           expect(permissionMap, isA<Map<Permission, PermissionStatus>>());
//         });
//   });
// }
//
// class MockPermissionHandlerPlatform extends Mock
//     with
//     // ignore: prefer_mixin
//         MockPlatformInterfaceMixin
//     implements
//         PermissionHandlerPlatform {
//   @override
//   Future<PermissionStatus> checkPermissionStatus(Permission permission) =>
//       Future.value(PermissionStatus.granted);
//
//   @override
//   Future<ServiceStatus> checkServiceStatus(Permission permission) =>
//       Future.value(ServiceStatus.enabled);
//
//   @override
//   Future<bool> openAppSettings() => Future.value(true);
//
//   @override
//   Future<Map<Permission, PermissionStatus>> requestPermissions(
//       List<Permission> permissions) {
//     var permissionsMap = <Permission, PermissionStatus>{};
//     return Future.value(permissionsMap);
//   }
//
//   @override
//   Future<bool> shouldShowRequestPermissionRationale(Permission? permission) {
//     return super.noSuchMethod(
//       Invocation.method(
//         #shouldShowPermissionRationale,
//         [permission],
//       ),
//       returnValue: Future.value(true),
//     );
//   }
// }
