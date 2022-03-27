import 'dart:convert';
import 'package:cycle_planner/models/place.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/models/place_search.dart';
import 'package:cycle_planner/services/places_service.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';


void main() {
  PlacesService place = PlacesService();
  group('PlacesService', () {

    test('returns if getPlace search works',
            () async {

// Mock the API call to return a json response with http status 200 Ok //

          final test =((await place.getPlace("temple")));
          const String key = 'AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY';
          const String placeId = 'westminster';
          const double lat = 51.4974948;
          const double lng = -0.1356583;
          final response = await place.getResponse('https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&location=$lat,$lng&key=$key', '1');
          String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&location=$lat,$lng&key=$key';
//https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJc2nSALkEdkgRkuoJJBfzkUI&location=51.5033,0.1196&key=AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY
          await untilCalled(place.getPlace("test") as Map<String, dynamic>);

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











