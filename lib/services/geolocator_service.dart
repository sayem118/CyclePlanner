import 'package:geolocator/geolocator.dart';

 /// Class description:
 /// This class uses the geolocator package to locate
 /// the user's current location and handles app permissions.

class GeolocatorService {
  
  // Return the user's current location.
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check User's location services setting
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    
    // Give the user an error message on disabled location service.
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check user's app permissions settings
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Check user's permission again
      permission = await Geolocator.requestPermission();

      // If user's app permissions is still not granted, give an error message.
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }

    // Give an error message on permanently disabled location permission
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.'
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
  }
}



