import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:cycle_planner/models/place_search.dart';

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
    var url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=geocode|establishment&location=51.509865,-0.118092&radius=500&key=$key';
    
    // Get URL response
    var response = await http.get(Uri.parse(url));

    // Convert received JSON String response into JSON Object
    var json = convert.jsonDecode(response.body);

    // Covert JSON Object to List
    var results = json['predictions'] as List;

    return results.map((place) => PlaceSearch.fromJson(place)).toList();
  }
}