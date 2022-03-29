// import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/models/groups.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'bike_station_service.dart';

// import 'package:cycle_planner/processes/application_processes.dart';
// import 'package:flutter/material.dart';

class MapboxNavigationService {
  static var routeEventHandler;
  late final ApplicationProcesses applicationProcesses;
  final bikeService = BikeStationService();
  bool isNavigating = false;


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
    isNavigating = true;
  }

void updateClosestStations(List<Marker> markers) async {
    if ((markers[1].position.latitude != wayPoints[1].latitude && markers[1].position.longitude != wayPoints[1].longitude)
        || markers[markers.length - 1].position.latitude != wayPoints[wayPoints.length - 1].latitude && markers[markers.length - 1].position.longitude != wayPoints[wayPoints.length - 1].longitude) {
      // exit turn by turn navigation and then start again with new waypoints.
      directions.finishNavigation();
      mapboxBegin(markers);
    }
  }
}
