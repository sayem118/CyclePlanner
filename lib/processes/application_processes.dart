import 'dart:async';
import 'package:cycle_planner/models/geometry.dart';
import 'package:cycle_planner/models/location.dart';
import 'package:cycle_planner/services/marker_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cycle_planner/services/geolocator_service.dart';
import 'package:cycle_planner/services/places_service.dart';
import 'package:cycle_planner/models/place_search.dart';
import 'package:cycle_planner/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Class description:
/// This class handles features that requires constant proccessing.
/// For example Updating the user's location
/// and processing user typed search locations.

class ApplicationProcesses with ChangeNotifier {
  
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();

  // Class variables
  Position? currentLocation;
  List<PlaceSearch> searchResults = [];
  StreamController<Place> selectedLocation = StreamController<Place>();
  StreamController<LatLngBounds> bounds = StreamController<LatLngBounds>();
  late Place selectedLocationStatic;
  late  String placeName;
  List<Marker> markers = [];

  // Class Initializer
  ApplicationProcesses() {
    setCurrentLocation();
  }

  // Update the user's current location
  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    selectedLocationStatic = Place(
      name: '',
      geometry: Geometry(
        location: Location(
          lat: currentLocation!.latitude,
          lng: currentLocation!.longitude
        ),
      ), 
      vicinity: '',
    );
    notifyListeners();
  }

  // Receive user's search input to proccess for autocompletion
  searchPlaces(String userInput) async {
    searchResults = await placesService.getAutocomplete(userInput);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    searchResults = [];
    notifyListeners();
  }

  togglePlaceType(String value) async {
    placeName = value;

    Place place = await placesService.getPlaceMarkers(
      selectedLocationStatic.geometry.location.lat,
      selectedLocationStatic.geometry.location.lng,
      placeName
    );
    markers= [];

    var newMarker = markerService.createMarkerFromPlace(place);
    markers.add(newMarker);

    var _bounds = markerService.bounds(Set<Marker>.of(markers));
    bounds.add(_bounds!);
    notifyListeners();
  }

  @override
  void dispose() {
    selectedLocation.close();
    bounds.close();
    super.dispose();
  }
}
