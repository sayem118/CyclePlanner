 /// Class description:
 /// This class provides information on locations
 /// entered by the user.
 /// Location's information is provided using Google Places API.

class PlaceSearch {
  
  // Class Variables
  final String description;
  final String placeId;
  
  // Class constructor
  PlaceSearch({required this.description, required this.placeId});

  // Return placeID & description data from Google Places API JSON.
  factory PlaceSearch.fromJson(Map<String, dynamic> json) {
    return PlaceSearch(
      description: json['description'],
      placeId: json['place_id'],
    );
  }
}