import 'dart:convert';
import 'package:cycle_planner/models/bikestation.dart';
import 'package:http/http.dart';

/// Retrieve [BikeStation] based on the user's location and group size.
/// data is filtered to show available bike stations.
/// bicycle station data is provided by TFL BikePoint API

class BikeStationService {

  /// Return a list of [BikeStation] exactly around the user.
  Future<List<BikeStation>> getStations(double? lat, double? lon) async {
    String url = 'https://api.tfl.gov.uk/Bikepoint?radius=400&lat=$lat&lon=$lon';

    // Request URL with user latitude and longitude
    Response response = await get(Uri.parse(url));
    
    // Get bike stations from TFL JSON
    dynamic json = jsonDecode(response.body);

    List<dynamic> results = json['places'] as List;

    return results.map((station) => BikeStation.fromJson(station)).toList();
  }
  
  /// Return a list of [BikeStation] closest to the user.
  Future<List> getClosestStations(double? lat, double? lon) async {
    // Request URL with user latitude and longitude
    Response response = await get(Uri.parse('https://api.tfl.gov.uk/Bikepoint?radius=6000&lat=$lat&lon=$lon'));
    List stations = [];
    
    // Get bike stations from TFL JSON
    stations = jsonDecode(response.body)['places'];

    return stations;
  }

  /// Return a map of [BikeStation] with available bycicles.
  Future<Map> getStationWithBikes(double? lat, double? lon, int groupSize) async {
    return filterData(await getClosestStations(lat, lon), 6, groupSize);
  }

  /// Return a map of [BikeStation] that can facilitate all group memebers
  Future<Map> getStationWithSpaces(double? lat, double? lon, int groupSize) async {
    return filterData(await getClosestStations(lat, lon), 7, groupSize);
  }

  // Filter received data with the appropriate additionalProperties number
  Map<dynamic, dynamic> filterData(List stations, int additionalPropertiesNumber, int groupSize){
    for (int i = 0; i < stations.length; i++) {
      if (int.parse(stations[i]['additionalProperties'][additionalPropertiesNumber]['value']) >= groupSize) {
        return stations[i];
      }
    }
    return {};
  }

}
