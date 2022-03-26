//import test package and groups model
import 'package:flutter/services.dart';
import 'package:test/test.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cycle_planner/models/location.dart';

void main() {
  test('Location constructor sets attributes', () {
    final mockLocation = Location(lat: 50.1109, lng: 8.6821);
    //ensure the latitude is set
    expect(mockLocation.lat, 50.1109);
    //ensure the longitude is set
    expect(mockLocation.lng, 8.6821);
  });

  test('test 2', () {

    Map file = {'lat': 50.1109, 'lng': 8.6821};

    final user = Location.fromJson(file);

    expect(user.lat, 50.1109);
    expect(user.lng, 8.6821);
  });
}