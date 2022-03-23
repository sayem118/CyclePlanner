import 'dart:async';
import 'package:cycle_planner/models/geometry.dart';
import 'package:cycle_planner/models/location.dart';
import 'package:cycle_planner/services/marker_service.dart';
import 'package:cycle_planner/services/polyline_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:cycle_planner/services/geolocator_service.dart';
import 'package:cycle_planner/services/places_service.dart';
import 'package:cycle_planner/models/place_search.dart';
import 'package:cycle_planner/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cycle_planner/services/bike_station_service.dart';

/// Class description:
/// This class handles features that requires constant proccessing.
/// For example Updating the user's location
/// and processing user typed search locations.

class ApplicationProcesses with ChangeNotifier {
  
  final geoLocatorService = Geolocator();
  final placesService = PlacesService();
  final markerService = MarkerService();
  final polylineService = PolylineService();
  final polylinePoints = PolylinePoints();
  final bikeService = BikeStationService();

  // Class variables
  Position? currentLocation;
  List<PlaceSearch> searchResults = [];
  StreamController<Place> selectedLocation = StreamController<Place>();
  StreamController<LatLngBounds> bounds = StreamController<LatLngBounds>();
  Place? selectedLocationStatic;
  String? placeName;
  List<Marker> markers = [];
  //hidden set of markers to be used behind the scenes
  List<Marker> bikeStations = [];
  //station1 has initial bike station and station 2 has last one
  Set<Polyline> polylines = {};
  List<LatLng> polyCoords = [];

  // Class Initializer
  ApplicationProcesses() {
    setCurrentLocation();
  }

  /// Update the user's [currentLocation]
  setCurrentLocation() async {
    currentLocation = await Geolocator.getCurrentPosition();
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

  /// Receive [userInput] to proccess for autocompletion
  searchPlaces(String userInput) async {
    searchResults = await placesService.getAutocomplete(userInput);
    notifyListeners();
  }

  /// Get a [Place] based on user's selection and set it as a selected location.
  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    searchResults = [];
    notifyListeners();
  }

  /// Create a [Marker] on a user selected [Place] and set the appropriate camera [bounds].
  toggleMarker(String value) async {
    placeName = value;

    Place place = await placesService.getPlaceMarkers(
      selectedLocationStatic!.geometry.location.lat,
      selectedLocationStatic!.geometry.location.lng,
      placeName!
    );

    var newMarker = markerService.createMarkerFromPlace(place);
    if (!markers.contains(newMarker)) {
      markers.add(newMarker);
      drawRoute();
    }

    var _bounds = markerService.bounds(Set<Marker>.of(markers));
    bounds.add(_bounds!);
    notifyListeners();
  }

  void drawRoute() async{
    removePolyline();
    if(bikeStations.length > 1) {
      bikeStations.removeLast();
      bikeStations.removeAt(1);
    }
    bikeStations = markers;
    var position = await Geolocator.getCurrentPosition();
    Marker currentLocation =
      Marker(markerId: const MarkerId("current location"),
      position: LatLng(position.latitude, position.longitude)
    );
    //for now it assumes group size is 1 all the time but someone can prolly easily change it to be a variable
    Future<Map> futureBikeStation1 = bikeService.getStationWithBikes(position.latitude, position.longitude, 1);
    Map startStation = await futureBikeStation1;
    Marker temp = markers.last;
    Future<Map> futureBikeStation2 = bikeService.getStationWithBikes(temp.position.latitude, temp.position.longitude, 1);
    Map endStation = await futureBikeStation2;
    Marker station1 = Marker(
      markerId: const MarkerId("start station"),
      position: LatLng(startStation['lat'], startStation['lon'])
    );
    Marker station2 = Marker(
        markerId: const MarkerId("end station"),
        position: LatLng(endStation['lat'], endStation['lon'])
    );
    bikeStations.insert(0, station1);
    bikeStations.insert(0, currentLocation);
    bikeStations.add(station2);
    for(int i = 1; i < bikeStations.length; i++) {
      late PolylinePoints polylinePoints;
      polylinePoints = PolylinePoints();
      final markerS = bikeStations.elementAt(i - 1);
      final markerd = bikeStations.elementAt(i);
      final PointLatLng marker1 = PointLatLng(markerd.position.latitude, markerd.position.longitude);
      final PointLatLng marker2 = PointLatLng(markerS.position.latitude, markerS.position.longitude);
      //gets a set of coordinates between 2 markers
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY",
        marker1,
        marker2,
        travelMode: TravelMode.bicycling,);
      //drawing route to bike stations
      late List<LatLng> nPoints = [];
      double stuff = 0;
      for (var point in result.points) {
        nPoints.add(LatLng(point.latitude, point.longitude));
        stuff = point.latitude + point.longitude;
      }
      //adds stuff to polyline
      //if its a cycle path line is red otherwise line is blue
      if (i == 1 || i == bikeStations.length - 1){
        polylines.add(Polyline(
            polylineId: PolylineId(stuff.toString()),
            points: nPoints,
            color: Colors.red
        ));
      }
      else{
        polylines.add(Polyline(
            polylineId: PolylineId(stuff.toString()),
            points: nPoints,
            color: Colors.blue
        ));
      }

    }
    notifyListeners();
  }
  /// Draw a [Polyline] between user's [currentLocation] and one or more selected [Place].
  /// [Polyline] are drawn between [Marker] coordinates.
  /*
  drawPolyline(Position? currentLoc) async {

    // // Hard coded for quick testing purposes.
    // markers.add(
    //   const Marker(
    //     markerId: MarkerId("London eye"),
    //     position: LatLng(51.50461919293181, -0.11954631306912968),
    //   )
    // );

    final userMarker = currentLoc!;
    for(int i = 0; i < markers.length; i++) {
      final locationMarker = markers.elementAt(i);
      final PointLatLng marker1 = PointLatLng(userMarker.latitude, userMarker.longitude);
      final PointLatLng marker2 = PointLatLng(locationMarker.position.latitude, locationMarker.position.longitude);

      PolylineResult result = await polylineService.getMarkerPoints(marker1, marker2);

      double polylineName = 0;
      if(result.status == 'OK') {
        for (var point in result.points) {
          polyCoords.add(LatLng(point.latitude, point.longitude));
          polylineName = point.latitude + point.longitude;
        }
      }

      if (i == 1 || i == markers.length - 1) {
        polylines.add(
          Polyline(
            polylineId: PolylineId(polylineName.toString()),
            points: polyCoords,
            color: Colors.red
          )
        );
      }
      polylines.add(
        Polyline(
          polylineId: PolylineId(polylineName.toString()),
          points: polyCoords,
          color: Colors.blue
        )
      );
    }
    notifyListeners();
  }
*/
  /// Remove a [Marker] from a selected [index]
  void removeMarker(index) {
    markers.removeAt(index);
    notifyListeners();
  }

  /// For now, removes all [polylines] from the map
  void removePolyline() {
    // polylines.remove(index);
    // polyCoords.remove(index);
    polylines = {};
    polyCoords = [];
  }

  @override
  void dispose() {
    selectedLocation.close();
    bounds.close();
    super.dispose();
  }
}
