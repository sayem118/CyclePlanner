import 'dart:convert';
import 'package:http/http.dart';

/// Class description:

class BikeStationService {
  
  // Return a list of bike stations closest to the user.
  Future<List> getClosestStations(double ?lat, double ?lon) async {
    // Request URL with user latitude and longitude
    Response response = await get(Uri.parse('https://api.tfl.gov.uk/Bikepoint?radius=6000&lat=$lat&lon=$lon'));
    
    // Get bike stations from TFL JSON
    List stations = jsonDecode(response.body)['places'];

    return stations;
  }

  // Ammar's refactored code, commented until a solution is found
  // // Return a map of bike stations with available bycicles.
  // Future<Map> getStationWithBikes(double? lat, double? lon, int groupSize) async {
  //   Future<List> futureOfStations = getClosestStations(lat, lon);
  //   List stations = await futureOfStations;
  //   return filterData(stations, 6, groupSize);
  //   // return{};
  // }

  // // Return a map of bike stations with ??? -> Maya fill this part :)
  // Future<Map> getStationWithSpaces(double? lat, double? lon, int groupSize) async {
  //   Future<List> futureOfStations = getClosestStations(lat, lon);
  //   List stations = await futureOfStations;
  //   return filterData(stations, 7, groupSize);
  //   // return {};
  // }

  // // Filter received data with the appropriate additionalProperties number
  // Map<dynamic, dynamic> filterData(List stations, int additionalPropertiesNumber, int groupSize){
  //   for (int i = 0; i < stations.length; i++) {
  //     if (int.parse(stations[i]['additionalProperties'][additionalPropertiesNumber]['value']) >= groupSize) {
  //       return stations[i];
  //     }
  //   }
  //   return {};
  // }

  // Maya's original code
  Future<Map> getStationWithBikes(double? lat, double? lon, int groupSize) async {
    Future<List> futureOfStations = getClosestStations(lat, lon);
    List stations = await futureOfStations;

    for (int i = 0; i < stations.length; i++) {
      if (int.parse(stations[i]['additionalProperties'][6]['value']) >= groupSize) {
        return stations[i];
      }
    }
    return{};
  }

  Future<Map> getStationWithSpaces(double? lat, double? lon, int groupSize) async {
    Future<List> futureOfStations = getClosestStations(lat, lon);
    List stations = await futureOfStations;

    for (int i = 0; i < stations.length; i++) {
      if (int.parse(stations[i]['additionalProperties'][7]['value']) >= groupSize) {
        return stations[i];
      }
    }
    return {};
  }

}