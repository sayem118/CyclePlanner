import 'package:cycle_planner/models/bikestation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cycle_planner/models/place.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

/// Creates a [Marker] from user selected [Place] or [BikeStation].
/// Handles [Marker] size and camera position when a [Marker] is added to the map.
/// Markers are provided by Google maps.

class MarkerService {

  // Class variables
  late BitmapDescriptor bikeMarker;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  /// Prepare custom [Marker]
  Future<void> setBikeMarkerIcon() async {
    bikeMarker = await getBitmapDescriptorFromAssetBytes("assets/bike-marker.png", 120);
  }

  /// Set camera bounds based on number of [Marker] in the map
  LatLngBounds? bounds(Set<Marker> markers) {
    if (markers.isEmpty) return null;
    return createBounds(markers.map((m) => m.position).toList());
  }

  /// Create bounds based of the [Marker]'s [postions]
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

  /// Create a [Marker] from a [BikeStation]'s information
  Marker createBikeMarker(BikeStation station) {
    return Marker(
      markerId: MarkerId(station.id),
      icon: bikeMarker,
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

  /// Create a [Marker] from a [Place]'s information
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
