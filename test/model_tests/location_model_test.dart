//import test package and groups model
import 'package:test/test.dart';
import 'package:cycle_planner/models/location.dart';

void main() {
  test('Location constructor sets attributes', () {
    final mockLocation = Location(lat: 50.1109, lng: 8.6821);
    //ensure the latitude is set
    expect(mockLocation.lat, 50.1109);
    //ensure the longitude is set
    expect(mockLocation.lng, 8.6821);
  });

  test('Testing Location factory method', () {

    //creating a test JSON and feeding it in
    Map mockLocationJSON = {'lat': 50.1109, 'lng': 8.6821};
    final mockLocation = Location.fromJson(mockLocationJSON);

    //ensure the attributes are set
    expect(mockLocation.lat, 50.1109);
    expect(mockLocation.lng, 8.6821);
  });
}