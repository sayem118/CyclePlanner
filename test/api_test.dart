import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/models/groups.dart';
import 'package:cycle_planner/models/place_search.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/services/bike_station_sevice.dart';
import 'package:cycle_planner/services/geolocator_service.dart';
import 'package:cycle_planner/services/places_service.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:geolocator/geolocator.dart';

const String key = 'AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY';
void main() {
  PlacesService place = PlacesService();
  group('getAutocomplete', () {
    test('returns if autocomplete search works',
            () async {

          // Mock the API call to return a json response with http status 200 Ok //
          final mockHTTPClient = MockClient((request) async {

            // Create sample response of the HTTP call //
            final response = {
            'text':
            "22834 is the feet above sea level of the highest mountain"
            };
            return Response(jsonEncode(response), 200);
          });
          // Check whether getAutocomplete function returns
          // a list of PlaceSearch
          expect(await place.getAutocomplete("poplar"), isA<List<PlaceSearch>>());
        });

    test('return error message when http response is unsuccessful', () async {

      // Mock the API call to return an
      // empty json response with http status 404
      final mockHTTPClient = MockClient((request) async {
        final response = {};
        return Response(jsonEncode(response), 404);
      });
      expect(await place.getAutocomplete(""),
          []);
    });
  });

  GeolocatorService geoLocator = GeolocatorService();
  group('GetCurrentLocation', () {

    test('returns error message if location service is not enabled',
    () async {
      bool serviceEnabled = false;
      final mockHTTPLocation = MockClient((request) async {
        // Create sample response of the HTTP call //
        final response = {
          'text':
          "Location services are disabled."
        };
        return Response(jsonEncode(response), 404);
      });
      // Check whether error message is given if location service is not enabled
      expect(await geoLocator.getCurrentLocation(),'Location services are disabled.');
    });
      });

  test('returns the current location if the location service and location permission is enabled',
          () async {
        bool serviceEnabled = true;
        LocationPermission permission = LocationPermission.whileInUse;
        final mockHTTPLocation = MockClient((request) async {
          // Create sample response of the HTTP call //
          final response = {
            'text':
            "Waterloo"
          };
          return Response(jsonEncode(response), 200);
        });
        // Check whether the getCurrentLocation function returns position of the current location
        expect(await geoLocator.getCurrentLocation(),isA<Position>);
      });

  test('returns error message if location permission is denied when service location is enabled',
          () async {
        bool serviceEnabled = true;
        LocationPermission permission = LocationPermission.denied;
        final mockHTTPLocation = MockClient((request) async {
          // Create sample response of the HTTP call //
          final response = {
            'text':
            "Location permission are denied"
          };
          return Response(jsonEncode(response), 200);
        });
        // Check whether error message is given if location permission is denied
        expect(await geoLocator.getCurrentLocation(),'Location permission are denied');
      });

  test('returns error message if location permission is denied when service location is not enabled',
          () async {
        bool serviceEnabled = false;
        LocationPermission permission = LocationPermission.denied;
        final mockHTTPLocation = MockClient((request) async {
          // Create sample response of the HTTP call //
          final response = {
            'text':
            "Location permission are denied"
          };
          return Response(jsonEncode(response), 404);
        });
        // Check whether error message is given if location permission is denied
        expect(await geoLocator.getCurrentLocation(),'Location permission are denied');
      });

  test('returns an error message on permanently disabled location permission',
          () async {
        bool serviceEnabled = false;
        LocationPermission permission = LocationPermission.deniedForever;
        final mockHTTPLocation = MockClient((request) async {
          // Create sample response of the HTTP call //
          final response = {
            'text':
            "Location permissions are permanently denied, we cannot request permissions"
          };
          return Response(jsonEncode(response), 404);
        });
        // Check whether error message is given if location permission is denied permanently
        expect(await geoLocator.getCurrentLocation(),'Location permissions are permanently denied, we cannot request permissions');
      });

  BikeStationSevice BikeStationService= BikeStationSevice();
  group('getClosestStations', () {
    test('returns closest bike stations to latitude and longitude given)',
            () async {

          // Mock the API call to return a json response with http status 200 Ok //
          final mockBikeStationService = MockClient((request) async {

            // Create sample response of the HTTP call //
            final response = {
              'text':
              "Strand, Waterloo"
            };
            return Response(jsonEncode(response), 200);
          });
          // Check whether getClosestStations function returns
          // a list of closest stations
          expect(await BikeStationService.getClosestStations(60.66,-65.66), isA<List>());
        });

    test('return error message when http response is unsuccessful and cant give closest bike stations', () async {

      // Mock the API call to return an
      // empty json response with http status 404
      final mockBikeStationService = MockClient((request) async {
        final response = {};
        return Response(jsonEncode(response), 404);
      });
      // Check whether an empty list is given when there is unsuccessful HTTP request
      expect(await BikeStationService.getClosestStations(0,0),
          []);

}







  //
  //
  //
  //
  //
  //
  //   };
  //
  //
  // };
  // BikeStationSevice BikeStationService= BikeStationSevice();
  // group('getClosestStations', () {
  //   test('returns closest bike stations to latitude and longitude given)',
  //           () async {
  //
  //         // Mock the API call to return a json response with http status 200 Ok //
  //         final mockBikeStationService = MockClient((request) async {
  //
  //           // Create sample response of the HTTP call //
  //           final response = {
  //             'text':
  //             "Strand, Waterloo"
  //           };
  //           return Response(jsonEncode(response), 200);
  //         });
  //         // Check whether getAutocomplete function returns
  //         // a list of PlaceSearch
  //         expect(await BikeStationService.getClosestStations(60.66,-65.66), isA<List>());
  //       });
  //
  //   test('return error message when http response is unsuccessful and cant give closest bike stations', () async {
  //
  //     // Mock the API call to return an
  //     // empty json response with http status 404
  //     final mockBikeStationService = MockClient((request) async {
  //       final response = {};
  //       return Response(jsonEncode(response), 404);
  //     });
  //     expect(await BikeStationService.getClosestStations(0,0),
  // []);




}


