import 'dart:convert';

import 'package:cycle_planner/services/marker_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/models/groups.dart';
import 'package:cycle_planner/models/place_search.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/services/bike_station_service.dart';
import 'package:cycle_planner/services/geolocator_service.dart';
import 'package:cycle_planner/services/places_service.dart';
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
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    test('Null value given when bound is empty',
            () async {
          // final boundsGiven = serviceMarker.bounds(<Marker>{});

          expect(serviceMarker.bounds(<Marker>{}), null);



        });

    test('Create Marker from Place given', ()
        async {
          final mockLocation = Location(lat: 50.1109, lng: 8.6821);
          final mockGeometry = Geometry(location: mockLocation);
          final mockPlace = Place(geometry: mockGeometry, name: "Test", vicinity: "Test");
          final MarkerID = mockPlace.name;
          final createMarker = serviceMarker.createMarkerFromPlace(mockPlace);
          expect(createMarker, Marker(
              markerId: MarkerId(MarkerID),
          draggable: false,
          visible: true,
          infoWindow: InfoWindow(
          title: mockPlace.name, snippet: mockPlace.vicinity
          ),
          position: LatLng(
          mockPlace.geometry.location.lat,
          mockPlace.geometry.location.lng
          )
          ));




        });





    // test('returns directions present',
    //         () async {
    //       final directionsGiven = navigation.directions;
    //
    //       expect(navigation.getDirections(), directionsGiven);
    //     });
    //
    // test('add Wapoints',
    //         () async {
    //       // final wayPointsGiven = navigation.wayPoints;
    //       final mockWaypoints = WayPoint(name: "westminster", latitude: 51.4974948, longitude: -0.1356583);
    //
    //       expect(navigation.addStop (name:"Westminster", latitude: 51.497498, longitude: -0.1356583), < )
    //
    //     });
  });



}