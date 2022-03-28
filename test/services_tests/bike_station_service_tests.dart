import 'dart:convert';

import 'package:cycle_planner/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/models/groups.dart';
import 'package:cycle_planner/models/place_search.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/services/bike_station_service.dart';
import 'package:cycle_planner/services/places_service.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:cycle_planner/services/geolocator_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// import 'package:permission_handler/permission_handler.dart';

void main() {
  BikeStationService bikeStations = BikeStationService();
  group('BikeStationService', () {
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
          expect(await bikeStations.getClosestStations(60.66, -65.66), isA<List>());
        });

    // test('getStationWithBikes',
    //   () async {
    //   List closestStations = await bikeStations.getClosestStations(50.1109, 8.6821);
    //   Map<dynamic, dynamic> filteredData = await bikeStations.filterData(closestStations, 7, 3);
    //   Map stationWithBikes = await bikeStations.getStationWithBikes(50.1109, 8.6821, 3);
    //
    //
    //   expect(stationWithBikes, filteredData);

      test('getStationWithSpaces',
          () async {
        List closestStations = await bikeStations.getClosestStations(50.1109, 8.6821);
        Map<dynamic, dynamic> filteredData = bikeStations.filterData(closestStations, 8, 3);
        Map stationWithSpaces = await bikeStations.getStationWithSpaces(50.1109, 8.6821, 3);

        expect(stationWithSpaces, filteredData);

          });





    });

//     test(
//         'return error message when http response is unsuccessful and cant give closest bike stations', () async {
// // Mock the API call to return an
// // empty json response with http status 404
//       final mockBikeStationService = MockClient((request) async {
//         final response = {};
//         return Response(jsonEncode(response), 404);
//       });
// // Check whether an empty list is given when there is unsuccessful HTTP request
//       expect(await bikeStations.getClosestStations(0, 0),
//           []);
//     });
//   });
}