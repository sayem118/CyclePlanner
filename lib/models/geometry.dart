import 'package:cycle_planner/models/location.dart';

/// This class creates a [Geometry] object from a parsed JSON.
/// [Geometry] information is provided by Google Places API.

class Geometry {
  
  // Class Variables
  final Location location;

  // Class constructor
  Geometry({required this.location});

  /// Construct a [Geometry] object from [parsedJson]
  Geometry.fromJson(Map<dynamic,dynamic> parsedJson) : location = Location.fromJson(parsedJson['location']);
}

