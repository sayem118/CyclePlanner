import 'package:cycle_planner/models/geometry.dart';

/// This class creates a [Place] object from a parsed JSON.
/// [Place] information is provided by Google Places API.

class Place {

  // Class Variables
  final Geometry geometry;
  final String name;
  final String? vicinity;

  // Class constructor
  Place({required this.geometry, required this.name, this.vicinity});

  /// Construct a [Place] object from [parsedJson]
  factory Place.fromJson(Map<dynamic,dynamic> parsedJson){
    return Place(
      geometry: Geometry.fromJson(parsedJson['geometry']),
      name: parsedJson['formatted_address'],
      vicinity: parsedJson['vicinity']
    );
  }
}