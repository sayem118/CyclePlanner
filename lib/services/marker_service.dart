import 'package:cycle_planner/models/bikestation.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cycle_planner/models/place.dart';

class MarkerService{
  BitmapDescriptor? bikeMarker;

  void setBikeMarkerIcon() async {
    bikeMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        devicePixelRatio: 2.0,
        size: Size(2.0, 2.0),
      ),
      'assets/bike-marker.png'
    );
  }

  LatLngBounds? bounds(Set<Marker> markers) {
    if (markers.isEmpty) return null;
    return createBounds(markers.map((m) => m.position).toList());
  }

  LatLngBounds createBounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce((value, element) => value < element ? value : element); // smallest
    final southwestLon = positions.map((p) => p.longitude).reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce((value, element) => value > element ? value : element); // biggest
    final northeastLon = positions.map((p) => p.longitude).reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
      southwest: LatLng(southwestLat, southwestLon),
      northeast: LatLng(northeastLat, northeastLon)
    );
  }

  Marker createBikeMarker(BikeStation station) {
    return Marker(
      markerId: MarkerId(station.id),
      icon: bikeMarker!,
      draggable: false,
      visible: true,
      infoWindow: InfoWindow(
        title: station.id, snippet: station.commonName
      ),
      position: LatLng(
        station.lat,
        station.lon
      )
    );
  }

  Marker createMarkerFromPlace(Place place) {
    String markerId = place.name;

    return Marker(
      markerId: MarkerId(markerId),
      draggable: false,
      visible: true,
      infoWindow: InfoWindow(
        title: place.name, snippet: place.vicinity
      ),
      position: LatLng(
        place.geometry.location.lat,
        place.geometry.location.lng
      )
    );
  }
}
