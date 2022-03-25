import 'dart:convert';

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

  group('getOptions', () {
    test('returns options present)',
            () async {
          final optionsGiven = navigation.options;

          expect(navigation.getOptions(), optionsGiven);



          });
        });
  }

