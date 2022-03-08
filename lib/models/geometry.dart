//import 'package:google_maps_webservice/directions.dart';
import 'package:cycle_planner/models/location.dart';

class Geometry {
  final Location location;

  Geometry({required this.location});

 factory Geometry.fromJson(Map<dynamic,dynamic> parsedJson){
    return Geometry(
      location: Location.fromJson(parsedJson['location'])
    );
  }
}