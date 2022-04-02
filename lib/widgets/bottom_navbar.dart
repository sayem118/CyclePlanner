import 'dart:async';

import 'package:cycle_planner/processes/application_processes.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'journey_planner.dart';
import 'package:cycle_planner/widgets/journey_planner.dart';


class BottomNavBar extends StatefulWidget {
  BottomNavBar({
    Key? key,
    required this.scaffoldKey
  }) : super(key: key);

  int selectedIndex = 3;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  late MapBoxOptions options;
  late MapBoxNavigation _directions;
  final int _selectedIndex = 3;
  List<WayPoint> wayPoints = [];
  final bool _isMultipleStop = false;
  @override
  void initState() {
    super.initState();
    initialize();

  }

  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
    options = MapBoxOptions(
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

  }

  Future<void> _startNavigation(List<Marker> bikeStations) async {
    wayPoints.clear();
    for (var stop in bikeStations){
      wayPoints.add(WayPoint(name: stop.markerId.toString(), latitude: stop.position.latitude, longitude: stop.position.longitude));
    }
    _directions.startNavigation(wayPoints: wayPoints, options: options);
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
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _directions.finishNavigation();
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
        break;
      default:
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var applicationProcesses = Provider.of<ApplicationProcesses>(context, listen:false);
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: const IconThemeData(color: Colors.white)
      ),
      child: CurvedNavigationBar(
        items: const <Widget>[
          Icon(Icons.menu, size: 27.0,),
          Icon(Icons.directions_bike, size: 27.0,),
          Icon(Icons.add, size: 27.0,),
          Icon(Icons.navigation_rounded, size: 27.0,),
          Icon(Icons.directions, size: 27.0,),
          Icon(Icons.group, size: 27.0,),
         // Icon(Icons.info, size: 27.0,),
        ],
        height: 60.0,
        color: (Colors.cyan[300])!,
        buttonBackgroundColor: Colors.orange[400],
        backgroundColor: Colors.transparent,
        index: _selectedIndex,
        animationDuration: const Duration(milliseconds: 330),
        onTap: (screenindex) {
          setState(() {
            switch (screenindex) {
              case 0: {
                widget.scaffoldKey.currentState!.openDrawer();
              }
              break;
              case 1: {
                break;
              }
              case 2: {
                break;
              }
              case 3: {
                // MapboxNavigationService().mapboxBegin(applicationProcesses.bikeStations);
                _startNavigation(applicationProcesses.bikeStations);
                //Navigator.push(context, MaterialPageRoute(builder: (context) => MapboxNavigation(bike_stations: applicationProcesses.bikeStations)));
              }
              break;
              case 4: {
                setState(() {
                  applicationProcesses.drawNewRouteIfPossible(context);
                });
                break;
              }
              case 5: {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JourneyPlanner()),
                );
                break;
              }
            }
          });
        },
      ),
    );
  }
}