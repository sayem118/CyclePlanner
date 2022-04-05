/// This class creates a [PlaceSearch] object from a parsed JSON.
/// [PlaceSearch] information is provided by Google Places Autocomplete API.

class PlaceSearch {
  
  // Class Variables
  final String description;
  final String placeId; 
  
  // Class constructor
  PlaceSearch({required this.description, required this.placeId});

  /// Construct a [PlaceSearch] object from [parsedJson]
  factory PlaceSearch.fromJson(Map<String, dynamic> parsedJson) {
    return PlaceSearch(
      description: parsedJson['description'],
      placeId: parsedJson['place_id'],
    );
  }
}