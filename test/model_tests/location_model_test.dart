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
}