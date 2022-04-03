import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cycle_planner/models/place.dart';

class MarkerService{
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

  Marker createBikeMarker(String id, double lat, double lng) {
    return Marker(
      markerId: MarkerId(id),
      draggable: false,
      visible: true,
      // infoWindow: InfoWindow(
      //   title: place.name, snippet: place.vicinity
      // ),
      position: LatLng(
        lat,
        lng
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
