import 'package:cycle_planner/models/place.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/models/place_search.dart';
import 'package:cycle_planner/services/places_service.dart';

void main() {
  final PlacesService place = PlacesService();
  group('PlacesService', () {
    test('returns if getPlace search works', () async {
// Mock the API call to return a json response with http status 200 Ok //
      Place search = await place.getPlace("ChIJc2nSALkEdkgRkuoJJBfzkUI");
      //const String key = 'AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY';
      //const String placeId = 'Riverside Building, County Hall, London SE1 7PB, UK';
      //const double lat = 51.5033;
      //const double lng = 0.1196;
      //final response = await place.getResponse('ChIJc2nSALkEdkgRkuoJJBfzkUI', 'result');
      //var search = await place.getPlace("ChIJc2nSALkEdkgRkuoJJBfzkUI");
      //String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJc2nSALkEdkgRkuoJJBfzkUI&location=51.5033,0.1196&key=AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY';
      //https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJc2nSALkEdkgRkuoJJBfzkUI&location=51.5033,0.1196&key=AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY
      //https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY&place_id=ChIJc2nSALkEdkgRkuoJJBfzkUI

      // Check whether getAutocomplete function returns
      // a list of PlaceSearch
      expect(search, isA<Place>());
    });

    test('returns if autocomplete search works', () async {
      // Mock the API call to return a json response with http status 200 Ok //
      // Check whether getAutocomplete function returns
      // a list of PlaceSearch
      expect(await place.getAutocomplete("poplar"), isA<List<PlaceSearch>>());
    });

    test('return error message when http response is unsuccessful', () async {
      // Mock the API call to return an
      // empty json response with http status 404
      expect(await place.getAutocomplete(""), []);
    });

    test('return if getPlaceMarkers', () async {
      Place getPlaceMakers = await place.getPlaceMarkers(
          50.1109, 8.6821, "ChIJc2nSALkEdkgRkuoJJBfzkUI");
      expect(getPlaceMakers, isA<Place>());
    });
  });
}











