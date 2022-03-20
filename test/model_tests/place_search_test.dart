//import test package and groups model
import 'package:test/test.dart';
import 'package:cycle_planner/models/place_search.dart';


void main() {
  group('PlaceSearch constructor working', () {
    test('PlaceSearch sets description attribute', () {
      final mockPlaceSearch = PlaceSearch(
          description: 'Mock PlaceSearch', placeId: 'Mock');
      //ensure the description is set
      expect(mockPlaceSearch.description, 'Mock PlaceSearch');
    });

    test('PlaceSearch sets placeID attribute', () {
      final mockPlaceSearch = PlaceSearch(
          description: 'Mock PlaceSearch', placeId: 'Mock');
      //ensure the placeID is set
      expect(mockPlaceSearch.placeId, 'Mock');
    });
  });

  // test('PlaceSearch API checks', () {
  //
  // });
}
