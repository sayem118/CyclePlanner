import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';


void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _origin = WayPoint(
      name: "Way Point 1",
      latitude: 51.52233,
      longitude: 0.04330);
  final _stop1 = WayPoint(
      name: "Way Point 2",
      latitude: 51.53769,
      longitude: 0.07006);
  final _stop2 = WayPoint(
      name: "Way Point 3",
      latitude: 51.55418,
      longitude: 0.11457);
  final _stop3 = WayPoint(
      name: "Way Point 4",
      latitude: 51.57794,
      longitude: 0.20648);
  final _stop4 = WayPoint(
      name: "Way Point 5",
      latitude: 51.61078,
      longitude: 0.27956);

  var wayPoints = <WayPoint>[];

  late MapBoxNavigation _directions;
  late MapBoxOptions _options;

  bool _isMultipleStop = false;
  late MapBoxNavigationViewController _controller;

  var groupSize = 1;

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

    // Platform messages may fail, so we use a try/catch PlatformException.


    setState(() {
    });
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
                  TextField(
                    decoration: InputDecoration(hintText: 'Search Location'),
                  ),
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
                          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

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


                          await _directions.startNavigation(
                              wayPoints: wayPoints,
                              options: _options);
                        },
                      )
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