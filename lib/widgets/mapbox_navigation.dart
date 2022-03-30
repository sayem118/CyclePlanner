import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/services/mapbox_navigation_service.dart';
import 'package:cycle_planner/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:cycle_planner/models/groups.dart';
import 'package:cycle_planner/services/bike_station_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// class MapboxNavigation extends StatefulWidget {
//   const MapboxNavigation({ Key? key }) : super(key: key);

//   @override
//   State<MapboxNavigation> createState() => _MapboxNavigationState();
// }

// class _MapboxNavigationState extends State<MapboxNavigation> {
//   var wayPoints = <WayPoint>[];
//   late MapBoxNavigation _directions;
//   late MapBoxOptions _options;

//   bool _isMultipleStop = false;

//   ApplicationProcesses applicationProcesses = ApplicationProcesses();

//   Groups groupSize = Groups(groupSize: 1);

//   BikeStationService bikeStationService = BikeStationService();

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initialize() async {
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
//     _options = MapBoxOptions(
//       initialLatitude: applicationProcesses.currentLocation!.latitude,
//       initialLongitude: applicationProcesses.currentLocation!.longitude,
//       zoom: 15.0,
//       tilt: 1.0,
//       bearing: 1.0,
//       enableRefresh: true,
//       alternatives: true,
//       voiceInstructionsEnabled: true,
//       bannerInstructionsEnabled: true,
//       allowsUTurnAtWayPoints: true,
//       mode: MapBoxNavigationMode.cycling,
//       units: VoiceUnits.imperial,
//       simulateRoute: false,
//       animateBuildRoute: false,
//       longPressDestinationEnabled: false,
//       language: "en",
//     );
//   }

//   late MapBoxNavigationViewController _controller;
//   @override
//   Widget build(BuildContext context) {
//     // final applicationProcesses = Provider.of<ApplicationProcesses>(context);
//     return Container(
//       color: Colors.pink,
//       child: MapBoxNavigationView(
//         options: _options,
//         onCreated: ,
//         onRouteEvent: _onEmbeddedRouteEvent,
//       ),
//     );
//   }

//   Future<void> _onEmbeddedRouteEvent(e) async {
//     switch (e.eventType) {
//       case MapBoxEvent.progress_change:
//         var progressEvent = e.data as RouteProgressEvent;
//         if (progressEvent.currentStepInstruction != null) {
//         }
//         break;
//       case MapBoxEvent.route_building:
//       case MapBoxEvent.route_built:
//         setState(() {
//         });
//         break;
//       case MapBoxEvent.route_build_failed:
//         setState(() {
//         });
//         break;
//       case MapBoxEvent.navigation_running:
//         setState(() {
//         });
//         break;
//       case MapBoxEvent.on_arrival:
//         if (!_isMultipleStop) {
//           await Future.delayed(const Duration(seconds: 3));
//           await _controller.finishNavigation();
//         } else {}
//         break;
//       case MapBoxEvent.navigation_finished:
//       case MapBoxEvent.navigation_cancelled:
//         setState(() {
//         });
//         break;
//       default:
//         break;
//     }
//     setState(() {});
//   }
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

class MapboxNavigation extends StatefulWidget {
  final bike_stations;
  const MapboxNavigation({ Key? key, this.bike_stations }) : super(key: key);

  @override
  State<MapboxNavigation> createState() => _MapboxNavigationState();
}

class _MapboxNavigationState extends State<MapboxNavigation> {
  late MapBoxNavigationViewController _controller;
  late MapBoxOptions _options;
  late MapBoxNavigation _directions;

  List<WayPoint> wayPoints = [];
  final bool _isMultipleStop = false;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  String? _instruction;

  final bikeService = BikeStationService();
  // final applicationProcesses = ApplicationProcesses();

  @override
  void initState() {
    super.initState();
    initialize();
    
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
    _options = MapBoxOptions(
      zoom: 15.0,
      tilt: 1.0,
      bearing: 1.0,
      enableRefresh: true,
      alternatives: true,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      allowsUTurnAtWayPoints: true,
      mode: MapBoxNavigationMode.cycling,
      units: VoiceUnits.imperial,
      simulateRoute: false,
      animateBuildRoute: false,
      longPressDestinationEnabled: false,
      language: "en",
    );

    for (var stop in widget.bike_stations) {
      wayPoints.add(WayPoint(name: stop.markerId.toString(), latitude: stop.position.latitude, longitude: stop.position.longitude));
    }
    await _directions.startNavigation(wayPoints: wayPoints, options: _options);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink,
      child: MapBoxNavigationView(
        options: _options,
        onRouteEvent: _onEmbeddedRouteEvent,
        onCreated: (MapBoxNavigationViewController controller) async {
          _controller = controller;
        },
      ),
    );
  }

  Future<void> _onEmbeddedRouteEvent(e) async {

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
        setState(() {
        });
        break;
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
          Navigator.pop(context);
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}