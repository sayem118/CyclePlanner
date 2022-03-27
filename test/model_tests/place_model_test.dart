//import test package and groups model
import 'package:test/test.dart';
import 'package:cycle_planner/models/location.dart';
import 'package:cycle_planner/models/geometry.dart';
import 'package:cycle_planner/models/place.dart';

void main() {
  test('Place constructor sets attributes', () {
    final mockLocation = Location(lat: 50.1109, lng: 8.6821);
    final mockGeometry = Geometry(location: mockLocation);
    final mockPlace = Place(geometry: mockGeometry, name: "Test", vicinity: "Test");
    //ensure the geometry is set
    expect(mockPlace.geometry, mockGeometry);
    //ensure the name is set
    expect(mockPlace.name, "Test");
    //ensure the vicinity is set
    expect(mockPlace.vicinity, "Test");

  });

  test('Testing Place factory method', () {

    //creating a test JSON and feeding it in
    Map mockGeometryJSON = {'location': {'lat': 50.1109, 'lng': 8.6821}};
    Map mockPlaceJSON = {'geometry': mockGeometryJSON
      , 'formatted_address': "Test", 'vicinity': "Test"};
    final mockPlace = Place.fromJson(mockPlaceJSON);

    //ensure the attributes are set
    expect(mockPlace.geometry.location.lat, 50.1109);
    expect(mockPlace.geometry.location.lng, 8.6821);
    expect(mockPlace.name, "Test");
    expect(mockPlace.vicinity, "Test");
  });
}