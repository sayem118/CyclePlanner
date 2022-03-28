import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/models/groups.dart';
import 'package:cycle_planner/models/place_search.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/services/bike_station_service.dart';
import 'package:cycle_planner/services/geolocator_service.dart';
import 'package:cycle_planner/services/places_service.dart';
import 'package:cycle_planner/services/marker_service.dart';
import 'package:cycle_planner/services/mapbox_navigation_service.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:cycle_planner/models/location.dart';
import 'package:cycle_planner/models/geometry.dart';
import 'package:cycle_planner/models/place.dart';


void main() {
  MapboxNavigationService navigation = MapboxNavigationService();
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

  group('NavigationService', () {
    test('returns options present)',
            () async {
          final optionsGiven = navigation.options;

          expect(navigation.getOptions(), optionsGiven);



          });

    test('returns directions present',
        () async {
      final directionsGiven = navigation.directions;

      expect(navigation.getDirections(), directionsGiven);
        });



    test('add Waypoints',
        () async {
      // final wayPointsGiven = navigation.wayPoints;
      final mockWayPoint = WayPoint(name: "westminster", latitude: 51.4974948, longitude: -0.1356583);
      navigation.addStop(mockWayPoint);





      expect(navigation.wayPoints, <WayPoint>[mockWayPoint]);

        });

    test('mapBoxBegin',
        () async {
          MapboxNavigationService navigation = MapboxNavigationService();
          MarkerService serviceMarker = MarkerService();
          final mockLocation = Location(lat: 50.1109, lng: 8.6821);
          final mockGeometry = Geometry(location: mockLocation);
          final mockPlace = Place(geometry: mockGeometry, name: "Test", vicinity: "Test");
          final MarkerID = mockPlace.name;
          final createMarker = serviceMarker.createMarkerFromPlace(mockPlace);
          final marker1 = Marker(
              markerId: MarkerId(MarkerID),
          draggable: false,
          visible: true,
          infoWindow: InfoWindow(
          title: mockPlace.name, snippet: mockPlace.vicinity
          ),
          position: LatLng(
          mockPlace.geometry.location.lat,
          mockPlace.geometry.location.lng));

          MarkerService serviceMaker2 = MarkerService();
          final mockLocation2 = Location(lat: 51.494720, lng: -0.135278);
          final mockGeometry2 = Geometry(location: mockLocation2);
          final mockPlace2 = Place(geometry: mockGeometry2, name: "Test2", vicinity: "Test2");
          final MarkerID2 = mockPlace2.name;
          final createMarker2 = serviceMarker.createMarkerFromPlace(mockPlace2);
          final marker2 = Marker(
              markerId: MarkerId(MarkerID2),
              draggable: false,
              visible: true,
              infoWindow: InfoWindow(
                  title: mockPlace2.name, snippet: mockPlace2.vicinity
              ),
              position: LatLng(
                  mockPlace2.geometry.location.lat,
                  mockPlace2.geometry.location.lng));

          List<Marker> markersPresent = [marker1,marker2];
          final wayPointsTemp = navigation.wayPoints;
          final directionTemp = navigation.directions;

          navigation.mapboxBegin(markersPresent);
          for (var stop in markersPresent) {
            wayPointsTemp.add(WayPoint(name: stop.markerId.toString(), latitude: stop.position.latitude, longitude: stop.position.longitude));
          final mockWayPoint = WayPoint(name: "Test2", latitude: mockPlace2.geometry.location.lat, longitude: mockPlace2.geometry.location.lng );

          // expect(navigation.directions.startNavigation(wayPoints: wayPointsTemp, options:navigation.options), isA<)

          expect(await navigation.directions.finishNavigation(), false);









        }

    });
        });


  }

