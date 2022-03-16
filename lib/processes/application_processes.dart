import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cycle_planner/services/geolocator_service.dart';
import 'package:cycle_planner/services/places_service.dart';
import 'package:cycle_planner/models/place_search.dart';
import 'package:cycle_planner/models/place.dart';

/// Class description:
/// This class handles features that requires constant proccessing.
/// For example Updating the user's location
/// and processing user typed search locations.

class ApplicationProcesses with ChangeNotifier {
  
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();

  // Class variables
  Position? currentLocation;
  List<PlaceSearch> searchResults = [];
  StreamController<Place> selectedLocation = StreamController<Place>();

  // Class Initializer
  ApplicationProcesses() {
    setCurrentLocation();
  }

  // Update the user's current location
  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
  }

  // Receive user's search input to proccess for autocompletion
  searchPlaces(String userInput) async {
    searchResults = await placesService.getAutocomplete(userInput);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async{
    selectedLocation.add(await placesService.getPlace(placeId));
    searchResults = [];
    notifyListeners();
  }

  @override
  void dispose() {
    selectedLocation.close();
    super.dispose();
  }
}
