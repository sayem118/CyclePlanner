import 'package:geolocator/geolocator.dart';

 /// Class description:
 /// This class uses the geolocator package to locate
 /// the user's current location.

class GeolocatorService {
  
  // Return the user's current location.
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permission are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');

  }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

  }
}



