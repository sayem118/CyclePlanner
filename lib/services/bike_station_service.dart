import 'dart:convert';
import 'package:cycle_planner/models/bikeStation.dart';
import 'package:http/http.dart';

/// Class description:
/// This class gets the bicycle stations based of the user's location and
/// from TFL API and filter the data to show available bike stations

class BikeStationService {

  Future<List<BikeStation>> getStations(double? lat, double? lon) async {
    String url = 'https://api.tfl.gov.uk/Bikepoint?radius=400&lat=$lat&lon=$lon';

    // Request URL with user latitude and longitude
    Response response = await get(Uri.parse(url));
    
    // Get bike stations from TFL JSON
    dynamic json = jsonDecode(response.body);

    List<dynamic> results = json['places'] as List;

    return results.map((station) => BikeStation.fromJson(station)).toList();
  }
  
  // Return a list of bike stations closest to the user.
  Future<List> getClosestStations(double? lat, double? lon) async {
    // Request URL with user latitude and longitude
    Response response = await get(Uri.parse('https://api.tfl.gov.uk/Bikepoint?radius=6000&lat=$lat&lon=$lon'));
    List stations = [];
    
    // Get bike stations from TFL JSON
    stations = jsonDecode(response.body)['places'];

    return stations;
  }

  // Return a map of bike stations with available bycicles.
  Future<Map> getStationWithBikes(double? lat, double? lon, int groupSize) async {
    return filterData(await getClosestStations(lat, lon), 6, groupSize);
  }

  // Return a map of bike stations with ??? -> Maya fill this part :)
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
