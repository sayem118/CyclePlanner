import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';





int groupSize = 1;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _origin = WayPoint(
      name: "Big Ben",
      latitude: 51.500863,
      longitude: -0.124593);
  final _stop1 = WayPoint(
      name: "Buckingham Palace",
      latitude: 51.50204176039292,
      longitude: -0.14188788458748477);
  final _stop2 = WayPoint(
      name: "British Museum",
      latitude: 51.521285300295474,
      longitude: -0.126953347081018);
  final _stop3 = WayPoint(
      name: "Trafalgar Square",
      latitude: 51.50809338374528,
      longitude: -0.12804891498586773);
  final _stop4 = WayPoint(
      name: "London Eye",
      latitude: 51.50461919293181,
      longitude: -0.11954631306912968);

  var wayPoints = <WayPoint>[];

  late MapBoxNavigation _directions;
  late MapBoxOptions _options;

  bool _isMultipleStop = false;
  late MapBoxNavigationViewController _controller;

  @override
  void initState() {
    super.initState();
    initialize();
    PermissionStatus _status;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
    _options = MapBoxOptions(
        initialLatitude: 55.1175275,
        initialLongitude: 0.4839524,
        zoom: 15.0,
        tilt: 0.0,
        bearing: 0.0,
        enableRefresh: false,
        alternatives: true,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        allowsUTurnAtWayPoints: true,
        mode: MapBoxNavigationMode.cycling,
        units: VoiceUnits.imperial,
        simulateRoute: false,
        animateBuildRoute: true,
        longPressDestinationEnabled: true,
        language: "en");


  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cycle planner'),
        ),
        body: Center(
          child: Column(children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  const Text(
                    'Group size',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SpinBox(
                    min: 1,
                    max: 8,
                    value: groupSize.toDouble(),
                    onChanged: (value) => setState(() {
                      groupSize = value.toInt();
                    }),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: const Text("Start Route"),
                        onPressed: () async {
                          Position position = await Geolocator
                              .getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high);

                          final _currentPosition = WayPoint(
                              name: "current position",
                              latitude: position.latitude,
                              longitude: position.longitude);

                          _isMultipleStop = true;
                          wayPoints.clear();
                          wayPoints.add(_currentPosition);
                          wayPoints.add(_origin);
                          wayPoints.add(_stop1);
                          wayPoints.add(_stop2);
                          wayPoints.add(_stop3);
                          wayPoints.add(_stop4);

                          // Find closest start station
                          WayPoint start = wayPoints.first;

                          Future<Map> futureOfStartStation = getStationWithBikes(start.latitude, start.longitude);
                          Map startStation = await futureOfStartStation;

                          WayPoint startStationWayPoint = WayPoint(
                              name: "startStation",
                              latitude: startStation['lat'],
                              longitude: startStation['lon']);
                          wayPoints.insert(1, startStationWayPoint);

                          // Find closest end station

                          WayPoint end = wayPoints.last;

                          Future<Map> futureOfEndStation = getStationWithSpaces(end.latitude, end.longitude);
                          Map endStation = await futureOfEndStation;

                          WayPoint endStationWayPoint = WayPoint(
                              name: "endStation",
                              latitude: endStation['lat'],
                              longitude: endStation['lon']);
                          wayPoints.add(endStationWayPoint);

                          // start navigating
                          await _directions.startNavigation(
                              wayPoints: wayPoints,
                              options: _options);
                        }
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.pink,
                child: MapBoxNavigationView(
                    options: _options,
                    onRouteEvent: _onEmbeddedRouteEvent,
                    onCreated:
                        (MapBoxNavigationViewController controller) async {
                      _controller = controller;
                      controller.initialize();
                    }),
              ),
            )
          ]),
        ),
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
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}

Future<Map> getStationWithBikes(double ?lat, double ?lon) async {
  Future<List> futureOfStations = getClosestStations(lat, lon);
  List stations = await futureOfStations;

  for (int i = 0; i < stations.length; i++) {
    if (int.parse(stations[i]['additionalProperties'][6]['value']) >= groupSize) {
      return stations[i];
    }
  }
  return {};
}

Future<Map> getStationWithSpaces(double ?lat, double ?lon) async {
  Future<List> futureOfStations = getClosestStations(lat, lon);
  List stations = await futureOfStations;

  for (int i = 0; i < stations.length; i++) {
    if (int.parse(stations[i]['additionalProperties'][7]['value']) >= groupSize) {
      return stations[i];
    }
  }
  return {};
}

Future<List> getClosestStations(double ?lat, double ?lon) async {
  Response response = await get(Uri.parse('https://api.tfl.gov.uk/Bikepoint?radius=6000&lat=$lat&lon=$lon'));
  List stations = jsonDecode(response.body)['places'];

  return stations;


}