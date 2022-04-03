import 'package:cycle_planner/processes/application_processes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:cycle_planner/services/bike_station_service.dart';

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

  final bikeService = BikeStationService();

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

    final model = ApplicationProcesses();
    model.addListener(_listener);
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
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
        setState(() {
          AlertDialog(
            title: const Text("Destination reached"),
            content: const Text("You have reached your destination"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
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

  void _listener() {
    print('Model changed!');
  }
}