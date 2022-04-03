class BikeStation {
  final String id;
  final String commonName;
  final double lat;
  final double lon;

  BikeStation ({required this.id, required this.commonName, required this.lat, required this.lon});

  factory BikeStation.fromJson(Map<dynamic, dynamic> parsedJson) {
    return BikeStation(
      id: parsedJson['id'].toString(),
      commonName: parsedJson['commonName'].toString(), 
      lat: parsedJson['lat'],
      lon: parsedJson['lon']
    );
  }
}