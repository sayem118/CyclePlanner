import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:cycle_planner/models/place_search.dart';
import 'package:cycle_planner/models/place.dart';

/// Class description:
/// This class sends user typed search input
/// and sends them as a request.
/// The response is then received as JSON Object 
/// and is then proccessed into a List of results.

class PlacesService {

  // Google API key
  final String key = 'AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY';

  // Return autocompleted user typed search results
  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    // Request URL
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=geocode|establishment&location=51.509865,-0.118092&radius=500&key=$key';
    
    // Get URL response
    http.Response response = await http.get(Uri.parse(url));

    // Convert received JSON String response into JSON Object
    dynamic json = convert.jsonDecode(response.body);

    // Covert JSON Object to List
    List<dynamic> results = json['predictions'] as List;

    return results.map((place) => PlaceSearch.fromJson(place)).toList();

  }

  Future<Place> getPlace(String placeId) async {
    // Request URL
    String url = 'https://maps.googleapis.com/maps/api/place/details/json?key=$key&place_id=$placeId';

    // Get URL Response
    return await getResponse(url, 'result');
  }

  Future<Place> getPlaceMarkers(double? lat, double? lng, String placeId) async {
    // Request URL
    // String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&location=$lat,$lng&key=$key';
    String url = 'https://maps.googleapis.com/maps/api/place/details/json?key=$key&place_id=$placeId';
    // Get URL response
    return await getResponse(url, 'result');
  }

  Future<Place> getResponse(String url, String requestParam) async {
    // Get URL response
    http.Response response = await http.get(Uri.parse(url));
    
    // Convert received JSON String response into JSON Object
    dynamic json = convert.jsonDecode(response.body);
    
    // Covert JSON Object to Map
    Map<String, dynamic> results = json[requestParam] as Map<String,dynamic>;
    
    return Place.fromJson(results);
  }
}


