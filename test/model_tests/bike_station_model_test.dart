//import test package and groups model
import 'package:cycle_planner/models/bikestation.dart';
import 'package:test/test.dart';

void main() {
  late dynamic bikeStationJSON;
  late BikeStation bikeModel;
  late String id;
  late String commonName;
  late double lat;
  late double lon;

  group('Bike station model -', () {
    setUp(() {
      bikeStationJSON = {
        "id": "BikePoints_79",
        "commonName": "Arundel Street, Temple",
        "lat": 51.511726,
        "lon": -0.113855
      };

      id = bikeStationJSON["id"];
      commonName = bikeStationJSON["commonName"];
      lat = bikeStationJSON["lat"];
      lon = bikeStationJSON["lon"];

      bikeModel = BikeStation(id: id, commonName: commonName, lat: lat, lon: lon);
    });

    test('Pass correct param data', () {
      id = '';
      commonName = '';
      lat = 0.0;
      lon = 0.0;

      BikeStation generateBikeStation = BikeStation(id: id, commonName: commonName, lat: lat, lon: lon);

      expect(generateBikeStation.id, '');
      expect(generateBikeStation.commonName, '');
      expect(generateBikeStation.lat, 0.0);
      expect(generateBikeStation.lon, 0.0);
    });
    
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

    test('Bike station id matches JSON data', () {
      BikeStation generateBikeStation = BikeStation(id: id, commonName: commonName, lat: lat, lon: lon);

      expect(generateBikeStation.id, bikeModel.id);
    });

    test('Bike station commonName matches JSON data', () {
      BikeStation generateBikeStation = BikeStation(id: id, commonName: commonName, lat: lat, lon: lon);

      expect(generateBikeStation.commonName, bikeModel.commonName);
    });

    test('Bike station lat matches JSON data', () {
      BikeStation generateBikeStation = BikeStation(id: id, commonName: commonName, lat: lat, lon: lon);

      expect(generateBikeStation.lat, bikeModel.lat);
    });

    test('Bike station lon matches JSON data', () {
      BikeStation generateBikeStation = BikeStation(id: id, commonName: commonName, lat: lat, lon: lon);

      expect(generateBikeStation.lon, bikeModel.lon);
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
  });
}
