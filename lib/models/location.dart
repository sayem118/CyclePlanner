/// This class creates a [Location] object from a parsed JSON.
/// [Location] information is provided by Google Places API.

class Location {

  // Class Variables
  final double lat;
  final double lng;

  // Class constructor
  Location({required this.lat, required this.lng});

  /// Construct a [Location] object from [parsedJson]
  factory Location.fromJson(Map<dynamic,dynamic> parsedJson){
    return Location(
      lat: parsedJson['lat'],
      lng: parsedJson['lng']
    );
  }
}