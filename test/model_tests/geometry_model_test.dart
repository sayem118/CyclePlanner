//import test package and groups model
import 'package:test/test.dart';
import 'package:cycle_planner/models/location.dart';
import 'package:cycle_planner/models/geometry.dart';

void main() {
  test('Geometry constructor sets attributes', () {
    final mockLocation = Location(lat: 50.1109, lng: 8.6821);
    final mockGeometry = Geometry(location: mockLocation);
    //ensure the attributes are set
    expect(mockGeometry.location, mockLocation);
  });
}