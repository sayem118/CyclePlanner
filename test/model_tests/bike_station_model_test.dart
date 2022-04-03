import 'package:test/test.dart';
import 'package:cycle_planner/models/bikeStation.dart';

void main() {
  late dynamic mockBikeStation;

  group('Bike station model -', () {
    setUp(() {
      mockBikeStation = {
        "id": "BikePoints_309",
        "commonName": "Arundel Street, Temple",
        "lat": 51.511726,
        "lon": -0.113855
      };
    });
  });
}