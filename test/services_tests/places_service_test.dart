import 'dart:convert';

import 'package:cycle_planner/models/place.dart';
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
import 'package:google_maps_flutter/google_maps_flutter.dart';


void main() {
  PlacesService place = PlacesService();
  group('PlacesService', () {

    test('returns if getPlace search works',
            () async {

// Mock the API call to return a json response with http status 200 Ok //

          final test =((await place.getPlace("temple")));
          final String key = 'AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY';
          final String placeId = 'Westminster';
          final double lat = 51.4974948;
          final double lng = -0.1356583;
          final response = await place.getResponse('https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&location=$lat,$lng&key=$key', '1');

// Check whether getAutocomplete function returns
// a list of PlaceSearch
          expect(place.getPlace("Westminster"), response);
        });

});

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


}











