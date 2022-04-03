//import test package and groups model
import 'package:cycle_planner/models/bikeStation.dart';
import 'package:test/test.dart';
import 'package:cycle_planner/models/bikeStation.dart';

void main() {
  test('Bike Station constructor sets attributes', () {
    final mockBikeStation = BikeStation(id: "Test", commonName: "Test", lat: 50.1109, lon: 8.6821);

    //ensure the id is set
    expect(mockBikeStation.id, "Test");
    //ensure the commonName is set
    expect(mockBikeStation.commonName, "Test");
    //ensure the latitude is set
    expect(mockBikeStation.lat, 50.1109);
    //ensure the longitude is set
    expect(mockBikeStation.lon, 8.6821);
  });

  test('Testing Bike Station factory method', () {

    //creating a test JSON and feeding it in
    Map mockBikeStationJSON = {'id': "Test", 'commonName': "Test", 'lat': 50.1109, 'lon': 8.6821};
    final mockBikeStation = BikeStation.fromJson(mockBikeStationJSON);

    //ensure the id is set
    expect(mockBikeStation.id, "Test");
    //ensure the commonName is set
    expect(mockBikeStation.commonName, "Test");
    //ensure the latitude is set
    expect(mockBikeStation.lat, 50.1109);
    //ensure the longitude is set
    expect(mockBikeStation.lon, 8.6821);
  });
}