// import 'package:cycle_planner/processes/application_processes.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:cycle_planner/processes/application_processes.dart';
// import 'package:flutter/material.dart';

class MapboxNavigationService {
  static var routeEventHandler;
  late final ApplicationProcesses applicationProcesses;



  // MapboxNavigationService({required Future<void> Function(dynamic e) embedded/*, required ApplicationProcesses bloc*/});

  var wayPoints = <WayPoint>[];

  final directions = MapBoxNavigation(onRouteEvent: routeEventHandler);
  final options = MapBoxOptions(
    initialLatitude: 53.1424,
    initialLongitude: 7.6921,
    zoom: 15,
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


  void addStop(WayPoint waypoint) {
    wayPoints.add(waypoint);
  }

  MapBoxOptions getOptions() {
    return options;
  }

  MapBoxNavigation getDirections() {
    return directions;
  }

  void mapboxBegin(List<Marker> markers) async {
    for (var stop in markers) {
      wayPoints.add(WayPoint(name: stop.markerId.toString(), latitude: stop.position.latitude, longitude: stop.position.longitude));
    }
    await directions.startNavigation(wayPoints: wayPoints, options: options);
  }

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