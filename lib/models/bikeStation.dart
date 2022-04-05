/// This class creates a [BikeStation] object from a parsed JSON.
/// [BikeStation] information is provided by TFL BikePoint API.

class BikeStation {
  
  // Class Variables
  final String id;
  final String commonName;
  final double lat;
  final double lon;

  // Class constructor
  BikeStation ({required this.id, required this.commonName, required this.lat, required this.lon});

  /// Construct a [BikeStation] object from [parsedJson]
  factory BikeStation.fromJson(Map<dynamic, dynamic> parsedJson) {
    return BikeStation(
      id: parsedJson['id'].toString(),
      commonName: parsedJson['commonName'].toString(), 
      lat: parsedJson['lat'],
      lon: parsedJson['lon']
    );
  }
}