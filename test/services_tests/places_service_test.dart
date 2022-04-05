import 'package:cycle_planner/models/place.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/models/place_search.dart';
import 'package:cycle_planner/services/places_service.dart';

void main() {
  final PlacesService place = PlacesService();
  group('PlacesService', () {
    test('returns if getPlace search works', () async {
      Place search = await place.getPlace("ChIJc2nSALkEdkgRkuoJJBfzkUI");
      expect(search, isA<Place>());
    });

    test('returns if autocomplete search works', () async {
      expect(await place.getAutocomplete("poplar"), isA<List<PlaceSearch>>());
    });

    test('return error message when http response is unsuccessful', () async {
      // Mock the API call to return an
      // empty json response with http status 404
      expect(await place.getAutocomplete(""), []);
    });

    test('Testing return of the PlaceMarkers', () async {
      Place getPlaceMakers = await place.getPlaceMarkers(
          50.1109, 8.6821, "ChIJc2nSALkEdkgRkuoJJBfzkUI");
      expect(getPlaceMakers, isA<Place>());
    });
  });
}
