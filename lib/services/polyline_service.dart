import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class PolylineService {
  final PolylinePoints _polylinePoints = PolylinePoints();

  Future<PolylineResult> getMarkerPoints(PointLatLng marker1, PointLatLng marker2) async {
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY",
        marker1,
        marker2
    );
    return result;
  }

  // Sayem's Original function
  
  // Future<void> drawRouteOverview() async {
  //   // const marker1 = Marker(
  //   //   markerId: MarkerId("London eye"),
  //   //   position: LatLng(51.50461919293181, -0.11954631306912968)
  //   // );
  
  //   // const marker2 = Marker(
  //   //   markerId: MarkerId("Trafalgar Square"),
  //   //   position: LatLng(51.50809338374528, -0.12804891498586773)
  //   // );
  
  //   // const marker3 = Marker(
  //   //   markerId: MarkerId("museum"),
  //   //   position: LatLng(51.50809338374528, -0.126953347081018)
  //   // );
  
  //   // const marker5 = Marker(
  //   //   markerId: MarkerId("knightsbridge"),
  //   //   position: LatLng(51.50809338374528, -0.16162)
  //   // );
  
  //   // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  
  //   // //some dummy data
  //   // final marker4 = Marker(
  //   //   markerId: const MarkerId("current"),
  //   //   position: LatLng(position.latitude, position.longitude)
  //   // );

  //   //adds markers to the list of markers
  //   // widget._markers.add(marker4);
  //   // widget._markers.add(marker1);
  //   // widget._markers.add(marker2);
  //   // widget._markers.add(marker3);
  //   // widget._markers.add(marker5);

  //   // will go through list of markers
  //   for(var i = 1; i < widget.applicationProcesses.markers.length; i++) {
  //     late PolylinePoints polylinePoints;
  //     polylinePoints = PolylinePoints();
  //     final markerS = widget.applicationProcesses.markers.elementAt(i - 1);
  //     final markerd = widget.applicationProcesses.markers.elementAt(i);
  //     final PointLatLng marker1 = PointLatLng(markerd.position.latitude, markerd.position.longitude);
  //     final PointLatLng marker2 = PointLatLng(markerS.position.latitude, markerS.position.longitude);
    
  //     //gets a set of coordinates between 2 markers
  //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       "AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY",
  //       marker1,
  //       marker2,
  //       travelMode: TravelMode.bicycling,
  //     );

  //     //drawing route to bike stations
  //     late List<LatLng> nPoints = [];
  //     double stuff = 0;
  //     for (var point in result.points) {
  //       nPoints.add(LatLng(point.latitude, point.longitude));
  //       stuff = point.latitude + point.longitude;
  //     }
  
  //     //adds stuff to polyline
  //     //if its a cycle path line is red otherwise line is blue
  //     if (i == 1 || i == widget.applicationProcesses.markers.length - 1){
  //       widget._polyline.add(
  //         Polyline(
  //           polylineId: PolylineId(stuff.toString()),
  //           points: nPoints,
  //           color: Colors.red
  //         )
  //       );
  //     }
  //     else{
  //       widget._polyline.add(
  //         Polyline(
  //           polylineId: PolylineId(stuff.toString()),
  //           points: nPoints,
  //           color: Colors.blue
  //         )
  //       );
  //     }
  //   }
  //   setState(() {
  //   });
  // }
}