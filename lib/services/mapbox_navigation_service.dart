// import 'package:cycle_planner/processes/application_processes.dart';
import 'package:flutter_mapbox_navigation/library.dart';
// import 'package:cycle_planner/processes/application_processes.dart';
// import 'package:flutter/material.dart';

class MapboxNavigationService {
  static var routeEventHandler;

  // MapboxNavigationService({required Future<void> Function(dynamic e) embedded/*, required ApplicationProcesses bloc*/});

  var wayPoints = <WayPoint>[];

  final _directions = MapBoxNavigation(/*onRouteEvent: routeEventHandler*/);
  final _options = MapBoxOptions(
    initialLatitude: 53.1424,
    initialLongitude: 7.6921,
    zoom: 7.0,
    tilt: 0.0,
    bearing: 0.0,
    enableRefresh: true,
    alternatives: true,
    voiceInstructionsEnabled: true,
    bannerInstructionsEnabled: true,
    allowsUTurnAtWayPoints: true,
    mode: MapBoxNavigationMode.cycling,
    units: VoiceUnits.imperial,
    simulateRoute: false,
    animateBuildRoute: true,
    longPressDestinationEnabled: false,
    language: "en",
  );

  // Hard coded waypoints, to be removed
  final _origin = WayPoint(
    name: "Big Ben",
    latitude: 51.500863,
    longitude: -0.124593
  );

  final _stop1 = WayPoint(
    name: "Buckingham Palace",
    latitude: 51.50204176039292,
    longitude: -0.14188788458748477
  );

  void addStop(WayPoint waypoint) {
    wayPoints.add(waypoint);
  }

  MapBoxOptions getOptions() {
    return _options;
  }

  MapBoxNavigation getDirections() {
    return _directions;
  }

  void mapboxBegin() async {
    addStop(_origin);
    addStop(_stop1);
    await _directions.startNavigation(wayPoints: wayPoints, options: _options);
  }

   // //method to draw route overview
  // //will assume the first 2 and last markers are for getting to the bike stations
  // Future<void> drawRouteOverview()  async {
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   //some dummy data
  //   final marker4 = Marker(
  //       markerId: const MarkerId("current"),
  //       position: LatLng(position.latitude, position.longitude)
  //   );
  //   //adds markers to the list of markers
  //   _markers.add(marker4);
  //   _markers.add(marker1);
  //   _markers.add(marker2);
  //   _markers.add(marker3);
  //   _markers.add(marker5);
  //   //will go through list of markers
  //   for(var i = 1; i < _markers.length; i++){
  //       late PolylinePoints polylinePoints;
  //       polylinePoints = PolylinePoints();
  //       final markerS = _markers.elementAt(i - 1);
  //       final markerd = _markers.elementAt(i);
  //       final PointLatLng marker1 = PointLatLng(markerd.position.latitude, markerd.position.longitude);
  //       final PointLatLng marker2 = PointLatLng(markerS.position.latitude, markerS.position.longitude);
  //       //gets a set of coordinates between 2 markers
  //       PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //           "AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY",
  //           marker1,
  //           marker2,
  //           travelMode: TravelMode.bicycling,);
  //       //drawing route to bike stations
  //       late List<LatLng> nPoints = [];
  //       double stuff = 0;
  //       for (var point in result.points) {
  //         nPoints.add(LatLng(point.latitude, point.longitude));
  //         stuff = point.latitude + point.longitude;
  //       }
  //       //adds stuff to polyline
  //       //if its a cycle path line is red otherwise line is blue
  //       if (i == 1 || i == _markers.length - 1){
  //         _polyline.add(Polyline(
  //           polylineId: PolylineId(stuff.toString()),
  //           points: nPoints,
  //           color: Colors.red
  //       ));
  //     }
  //       else{
  //         _polyline.add(Polyline(
  //             polylineId: PolylineId(stuff.toString()),
  //             points: nPoints,
  //             color: Colors.blue
  //         ));
  //       }

  //   }
  //   setState(() {

  //   });
  // }

  // // Creates alert if there are no available bike stations nearby.
  // Future<void> _showNoStationsAlert(context) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Oh no...'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: const <Widget>[
  //               Text('Looks like there are no available bike stations nearby.'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Ok'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void updateClosestStations() async {
  //   // Find closest start station
  //   WayPoint start = wayPoints.first;
  //   // These are random coords in East that don't have any bike stations nearby.
  //   //Future<Map> futureOfStartStation = bikeStationService.getStationWithBikes(51.54735235426037, 0.08849463623212586, groupSize.getGroupSize());
  //   Future<Map> futureOfStartStation = bikeStationService.getStationWithBikes(start.latitude, start.longitude, groupSize.getGroupSize());
  //   Map startStation = await futureOfStartStation;

  //   // Find closest end station
  //   WayPoint end = wayPoints[wayPoints.length - 2];
  //   Future<Map> futureOfEndStation = BikeStationService().getStationWithSpaces(
  //       end.latitude, end.longitude, groupSize.getGroupSize());
  //   Map endStation = await futureOfEndStation;

  //   // check if there are available bike stations nearby. If not the user is alerted.
  //   if (startStation.isEmpty || endStation.isEmpty) {
  //     // if there are no close available bike stations I was gonna exit the navigation and display an alert,
  //     // but a station might free up in the next time interval so not sure what to do here...
  //   }
  //   else {
  //     // check if stations have changed.
  //     if ((startStation['lat'] != wayPoints[1].latitude && startStation['lon'] != wayPoints[1].longitude) || (endStation['lat'] != wayPoints[wayPoints.length - 1].latitude && endStation['lon'] != wayPoints[wayPoints.length - 1].longitude)) {
  //       // update stations to new stations.
  //       WayPoint startStationWayPoint = WayPoint(
  //           name: "startStation",
  //           latitude: startStation['lat'],
  //           longitude: startStation['lon']
  //       );
  //       wayPoints[1] = startStationWayPoint;

  //       WayPoint endStationWayPoint = WayPoint(
  //           name: "endStation",
  //           latitude: endStation['lat'],
  //           longitude: endStation['lon']
  //       );
  //       wayPoints[wayPoints.length - 1] = endStationWayPoint;

  //       // exit turn by turn navigation and then start again with new waypoints.
  //       _directions.finishNavigation();
  //       _directions.startNavigation(wayPoints: wayPoints, options: _options);
  //     }
  //   }
  // }
}