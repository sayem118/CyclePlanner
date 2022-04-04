import 'dart:async';
import 'package:cycle_planner/models/geometry.dart';
import 'package:cycle_planner/models/location.dart';
import 'package:cycle_planner/services/marker_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:cycle_planner/services/places_service.dart';
import 'package:cycle_planner/models/place_search.dart';
import 'package:cycle_planner/models/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cycle_planner/services/bike_station_service.dart';

/// Class description:
/// This class handles features that requires constant proccessing.
/// For example Updating the user's location
/// and processing user typed search locations.

class ApplicationProcesses with ChangeNotifier {
  final placesService = PlacesService();
  final markerService = MarkerService();
  final polylinePoints = PolylinePoints();
  final bikeService = BikeStationService();

  // Class variables
  Position? currentLocation;
  List<PlaceSearch> searchResults = [];
  StreamController<Place> selectedLocation = StreamController<Place>.broadcast();
  StreamController<LatLngBounds> bounds = StreamController<LatLngBounds>.broadcast();
  Place? selectedLocationStatic;
  String? placeName;
  List<Marker> markers = [];
  Timer? timer;

  //hidden set of markers to be used behind the scenes
  List<Marker> bikeStations = [];

  List<Marker> publicBikeStations = [];

  //station1 has initial bike station and station 2 has last one
  Set<Polyline> polylines = {};
  List<LatLng> polyCoords = [];
  int groupSize = 1;

  // Class Initializer
  ApplicationProcesses() {
    setCurrentLocation();
  }

  /// Update the user's [currentLocation]
  setCurrentLocation() async {
    currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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

  void setGroupSize(int group) {
    groupSize = group;
  }

  int getGroupSize() {
    return groupSize;
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
    publicBikeStations.clear();
    placeName = value;

    Place place = await placesService.getPlaceMarkers(
      selectedLocationStatic!.geometry.location.lat,
      selectedLocationStatic!.geometry.location.lng,
      placeName!
    );

    var newMarker = markerService.createMarkerFromPlace(place);
    if (!markers.contains(newMarker)) {
      markers.add(newMarker);
    }

    var _bounds = markerService.bounds(Set<Marker>.of(markers));
    bounds.add(_bounds!);
    notifyListeners();
  }

  /// Create a [Marker] on [bikeStations] around the user's location and set the appropriate camera [bounds].
  toggleBikeMarker() async {
    markerService.setBikeMarkerIcon();
    var position = currentLocation;
    var futureBikeStation = bikeService.getStations(
      position!.latitude,
      position.longitude,
    );

    List stations = await futureBikeStation;

    if(stations.isNotEmpty) {
      for(int i = 0; i < stations.length; i++) {
        var bikeMarker = markerService.createBikeMarker(stations[i]);
        publicBikeStations.add(bikeMarker);
      }
    }

    var _bounds = markerService.bounds(Set<Marker>.of(publicBikeStations));
    bounds.add(_bounds!);
    notifyListeners();
  }

  void drawNewRouteIfPossible(context) async {
    var position = currentLocation;
    Future<Map> futureBikeStation1 = bikeService.getStationWithBikes(
      position!.latitude,
      position.longitude,
      groupSize
    );
    Map startStation = await futureBikeStation1;

    Marker temp = markers.last;
    Future<Map> futureBikeStation2 = bikeService.getStationWithSpaces(
        temp.position.latitude, temp.position.longitude, groupSize
    );
    Map endStation = await futureBikeStation2;

    // only draw polylines if route has not been drawn already or bike stations have changed.
    if( polylines.isEmpty
        || (startStation['lat'] != bikeStations[1].position.latitude && startStation['lon'] != bikeStations[1].position.longitude)
        || (endStation['lat'] != bikeStations.last.position.latitude && endStation['lon'] != bikeStations.last.position.longitude)) {
      if(startStation.isNotEmpty && endStation.isNotEmpty) {
        bikeStations.clear();
        polylines = {};
        bikeStations = List<Marker>.from(markers);
        Marker currentLocation =
        Marker(markerId: const MarkerId("current location"),
            position: LatLng(position.latitude, position.longitude)
        );
        //for now it assumes group size is 1 all the time but someone can prolly easily change it to be a variable
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
        drawRoute();
        print("bike station changed");
        notifyListeners();

        // automatically refresh route overview.
        timer?.cancel();
        timer = Timer.periodic(const Duration(seconds: 15), (Timer t) => {
          drawNewRouteIfPossible(context),
        });
      }
      else if (endStation.isEmpty) {
        showNoStationsFinalStopAlert(context);
      }
      else {
        showNoStationsCurrentLocationAlert(context);
      }
    }
  }

  void drawRoute() async {
    for (int i = 1; i < bikeStations.length; i++) {
      late PolylinePoints polylinePoints;
      polylinePoints = PolylinePoints();
      final markerS = bikeStations.elementAt(i - 1);
      final markerd = bikeStations.elementAt(i);
      final PointLatLng marker1 = PointLatLng(
        markerd.position.latitude, markerd.position.longitude
      );
      final PointLatLng marker2 = PointLatLng(
        markerS.position.latitude, markerS.position.longitude
      );
      //gets a set of coordinates between 2 markers
      late PolylineResult result;
      if (i == 1) {
        result = await polylinePoints.getRouteBetweenCoordinates(
          "AIzaSyBDiE-PLzVVbe4ARNyLt_DD91lqFpqGHFk",
          marker1,
          marker2,
          travelMode: TravelMode.walking,
        );
      }
      else {
        result = await polylinePoints.getRouteBetweenCoordinates(
          "AIzaSyBDiE-PLzVVbe4ARNyLt_DD91lqFpqGHFk",
          marker1,
          marker2,
          travelMode: TravelMode.bicycling,
        );
      }
      //drawing route to bike stations
      late List<LatLng> nPoints = [];
      double stuff = 0;
      for (var point in result.points) {
        nPoints.add(LatLng(point.latitude, point.longitude));
        stuff = point.latitude + point.longitude;
      }
      //adds stuff to polyline
      //if its a cycle path line is red otherwise line is blue
      if (i == 1 || i == bikeStations.length - 1) {
        polylines.add(Polyline(
          polylineId: PolylineId(stuff.toString()),
          points: nPoints,
          color: Colors.red
        ));
      }
      else {
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
    polylines = {};
    polyCoords = [];
  }

  // Creates alert if there are no available bike stations near final stop.
  Future<void> showNoStationsFinalStopAlert(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No available bike stations near your final stop.'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Try reordering your stops or changing your final stop.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Creates alert if there are no available bike stations near final stop.
  Future<void> showNoStationsCurrentLocationAlert(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No available bike stations.'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Try using the app from a different location.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    selectedLocation.close();
    bounds.close();
    super.dispose();
  }
}
