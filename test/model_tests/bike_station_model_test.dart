import 'package:test/test.dart';
import 'package:cycle_planner/models/bikeStation.dart';

void main() {
  group('Bike station model -', () {
    late dynamic bikeStationJSON;
    late BikeStation bikeModel;
    late String id;
    late String commonName;
    late double lat;
    late double lon;
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

    test('Required Params passed', () {
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

    test('Bike station object from JSON', () {
      Map<dynamic, dynamic> mockGeometryJSON = {"id": "BikePoints_79", "commonName": "Arundel Street, Temple", 'lat': 51.511726, 'lon': -0.113855};
      final mockGeometry = BikeStation.fromJson(mockGeometryJSON);

      expect(mockGeometry.id, "BikePoints_79");
      expect(mockGeometry.commonName, "Arundel Street, Temple");
      expect(mockGeometry.lat, 51.511726);
      expect(mockGeometry.lon, -0.113855);
    });
  });
}