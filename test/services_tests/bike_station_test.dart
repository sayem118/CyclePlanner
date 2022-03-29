import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/services/bike_station_service.dart';

void main() {
  BikeStationService bikeStations = BikeStationService();
  group('BikeStationService', () {
    test('returns closest bike stations to latitude and longitude given)',
        () async {
// Check whether getClosestStations function returns
// a list of closest stations
      var test = await bikeStations.getClosestStations(51.5, 0.12);

      expect(test, isA<List>());
    });
    test('getStationWithBikes', () async {
      var test = await bikeStations.getStationWithBikes(55.1109, 0.12821, 1);
      expect(test, {});
    });
    test('getStationWithSpaces', () async {
      var test = await bikeStations.getStationWithSpaces(55.1109, 0.15, 3);
      expect(test, {});
    });
    test('Get filtered data', () async {
      var test = bikeStations.filterData(
          await bikeStations.getClosestStations(
            55.1109,
            0.15,
          ),
          6,
          10);
      expect(test, {});
    });
  });
}
