import 'package:geolocator/geolocator.dart';

 /// Class description:
 /// This class uses the geolocator package to locate
 /// the user's current location.

class GeolocatorService {
  
  // Return the user's current location.
  Future<Position> getCurrentLocation() async {  
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
  }
}