import 'package:cycle_planner/processes/application_processes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:cycle_planner/services/bike_station_service.dart';
import 'package:provider/provider.dart';

class MapboxNavigation extends StatefulWidget {
  final bike_stations;
  const MapboxNavigation({ Key? key, this.bike_stations }) : super(key: key);

  @override
  State<MapboxNavigation> createState() => _MapboxNavigationState();
}

class _MapboxNavigationState extends State<MapboxNavigation> with WidgetsBindingObserver {
  late MapBoxNavigationViewController _controller;
  late MapBoxOptions _options;
  late MapBoxNavigation _directions;

  final bool _isMultipleStop = false;
  bool _routeBuilt = false;
  bool _isNavigating = false;

  final bikeService = BikeStationService();
  late final appProcesses;

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

    appProcesses = Provider.of<ApplicationProcesses>(context, listen:false);
    appProcesses.addListener(_listener);

    WidgetsBinding.instance!.addObserver(this);

    startNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
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
        } else {
          _controller.finishNavigation();
        }
        break;
      case MapBoxEvent.navigation_finished:
        setState(() {
          _isNavigating = false;
          _directions.finishNavigation();
          _controller.finishNavigation();
          showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Destination reached"),
                content: const Text("You have successfully reached your destination"),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        });
        break;
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
          _directions.finishNavigation();
          _controller.finishNavigation();
          Navigator.pop(context);
        });
        break;
      default:
        break;
    }
    setState(() {});
  }

  void startNavigation() {
    List<WayPoint> wayPoints = [];
    for (var stop in appProcesses.bikeStations) {
      wayPoints.add(WayPoint(name: stop.markerId.toString(), latitude: stop.position.latitude, longitude: stop.position.longitude));
    }
    _directions.startNavigation(wayPoints: wayPoints, options: _options);
  }

  Future<void> _listener() async {
    if(_isNavigating) {
      _directions.finishNavigation();
      List<WayPoint> newWayPoints = [];
      for (var stop in appProcesses.bikeStations) {
        newWayPoints.add(WayPoint(name: stop.markerId.toString(), latitude: stop.position.latitude, longitude: stop.position.longitude));
      }
      _directions.startNavigation(wayPoints: newWayPoints, options: _options);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print("Nav Inactive");
        _isNavigating = false;
        break;
        case AppLifecycleState.paused:
        print("Nav Paused");
        _isNavigating = true;
        break;
        case AppLifecycleState.resumed:
        print("Nav Resumed");
        _isNavigating = false;
        break;
    }
  }
}