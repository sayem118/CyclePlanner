//import test package and groups model
import 'package:test/test.dart';
import 'package:cycle_planner/models/place_search.dart';

void main() {
  test('Place Search constructor sets attributes', () {
    final mockPlaceSearch = PlaceSearch(description: "Test", placeId: "Test");

    //ensure the description is set
    expect(mockPlaceSearch.description, "Test");
    //ensure the placeID is set
    expect(mockPlaceSearch.placeId, "Test");
  });

  test('Testing Place Search factory method', () {
    //creating a test JSON and feeding it in
    Map<String, dynamic> mockPlaceSearchJSON = {
      'description': "Test",
      'place_id': "Test"
    };
    final mockPlaceSearch = PlaceSearch.fromJson(mockPlaceSearchJSON);

    //ensure the description is set
    expect(mockPlaceSearch.description, "Test");
    //ensure the placeID is set
    expect(mockPlaceSearch.placeId, "Test");
  });
}