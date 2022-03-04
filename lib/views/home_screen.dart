// import 'package:flutter/material.dart';
// import 'package:cycle_planner/processes/application_processes.dart';
// import 'package:cycle_planner/services/bike_station_service.dart';
// import 'package:flutter_mapbox_navigation/library.dart';
// import 'package:flutter_spinbox/material.dart';
// import 'package:cycle_planner/models/groups.dart';
// import 'package:http/http.dart';
// import 'package:provider/provider.dart';
// import 'dart:convert';
// import 'package:cycle_planner/views/nav_bar.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({ Key? key }) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   // Hard coded waypoints for testing purposes
//   final _origin = WayPoint(
//     name: "Big Ben",
//     latitude: 51.500863,
//     longitude: -0.124593
//   );

//   final _stop1 = WayPoint(
//     name: "Buckingham Palace",
//     latitude: 51.50204176039292,
//     longitude: -0.14188788458748477
//   );

//   final _stop2 = WayPoint(
//       name: "British Museum",
//       latitude: 51.521285300295474,
//       longitude: -0.126953347081018
//     );

//   final _stop3 = WayPoint(
//     name: "Trafalgar Square",
//     latitude: 51.50809338374528,
//     longitude: -0.12804891498586773
//   );

//   final _stop4 = WayPoint(
//     name: "London Eye",
//     latitude: 51.50461919293181,
//     longitude: -0.11954631306912968
//   );

//   var wayPoints = <WayPoint>[];
//   late MapBoxNavigation _directions;
//   late MapBoxOptions _options;

//   bool _isMultipleStop = false;

//   late MapBoxNavigationViewController _controller;

//   Groups groupSize = Groups(groupSize: 1);

//   BikeStationService bikeStationService = BikeStationService();

//   @override
//   void initState() {
//     super.initState();
//     initialize();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initialize() async {
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
//     _options = MapBoxOptions(
//       initialLatitude: ApplicationProcesses().currentLocation?.latitude, // Hard coded value: 51.509865
//       initialLongitude: ApplicationProcesses().currentLocation?.longitude, // Hard coded value: -0.118092
//       zoom: 15.0,
//       tilt: 0.0,
//       bearing: 0.0,
//       enableRefresh: false,
//       alternatives: true,
//       voiceInstructionsEnabled: true,
//       bannerInstructionsEnabled: true,
//       allowsUTurnAtWayPoints: true,
//       mode: MapBoxNavigationMode.cycling,
//       units: VoiceUnits.imperial,
//       simulateRoute: false,
//       animateBuildRoute: true,
//       longPressDestinationEnabled: true,
//       language: "en"
//     );
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     final applicationProcesses = Provider.of<ApplicationProcesses>(context);
//     return Scaffold(
//       drawer: const NavBar(),
//       appBar: AppBar(
//         title: const Text("Cycle Planner"),
//       ),
//       body: (applicationProcesses.setCurrentLocation() == null) ? const Center(child: CircularProgressIndicator())
//       :ListView(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: const InputDecoration(
//                 hintText: 'Search Location',
//                 suffixIcon: Icon(Icons.search),
//               ),
//               onChanged: (value) => applicationProcesses.searchPlaces(value),
//             ),
//           ),
//           Column(
//             children: <Widget>[
//               const SizedBox(height: 20.0,),
//               const Text(
//                 "Group Size",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               SpinBox(
//                 min: 1,
//                 max: 8,
//                 value: groupSize.getGroupSize().toDouble(),
//                 onChanged: (value) => setState(() {
//                   groupSize.setGroupSize(value.toInt());
//                 }),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               ElevatedButton(
//                 child: const Text("Start Route"),
//                 onPressed: () async {

//                  final _currentPosition = WayPoint(
//                    name: "Current Position",
//                    latitude: applicationProcesses.currentLocation?.latitude, // Hard coded value: 55.1175275,
//                    longitude: applicationProcesses.currentLocation?.longitude // Hard coded value: 0.4839524
//                  );

//                  _isMultipleStop = true;
                 
//                  wayPoints.clear();
//                  wayPoints.add(_currentPosition);
//                  wayPoints.add(_origin);
//                  wayPoints.add(_stop1);
//                  wayPoints.add(_stop2);
//                  wayPoints.add(_stop3);
//                  wayPoints.add(_stop4);

//                  // Find closest start location
//                  WayPoint start = wayPoints.first;

//                  Future<Map> futureOfStartStation = bikeStationService.getStationWithBikes(start.latitude, start.longitude, groupSize.getGroupSize());
//                  Map startStation = await futureOfStartStation;
//                  //  print("This is an example of map: $startStation");
//                  WayPoint startStationWayPoint = WayPoint(
//                    name: "startStation",
//                    latitude: startStation['lat'],
//                    longitude: startStation['lon']
//                  );

//                  wayPoints.insert(1, startStationWayPoint);
                 
//                  // For debugging -> Prints waypoints & bike station's name, latitude and longitude
//                  // for (int i = 0; i < wayPoints.length; i++){print("Waypoint station are: ${wayPoints[i].name}, ${wayPoints[i]}");}
//                  // for (int i = 1; i < startStation.length; i++){print("Bike station no.$i is: ${startStation}");}
//                  // print("bike station map size: ${startStation.length}");


//                  // Find closest end station
//                  WayPoint end = wayPoints.last;

//                  Future<Map> futureOfEndStation = BikeStationService().getStationWithSpaces(end.latitude, end.longitude, groupSize.getGroupSize());
//                  Map endStation = await futureOfEndStation;
//                  WayPoint endStationWayPoint = WayPoint(
//                    name: "endStation",
//                    latitude: endStation['lat'],
//                    longitude: endStation['lon']
//                  );
//                  wayPoints.add(endStationWayPoint);

//                  // Start navigating
//                  await _directions.startNavigation(
//                    wayPoints: wayPoints,
//                    options: _options
//                  );
//                 }
//               )
//             ],
//           ),
//           const SizedBox(height: 20.0,),
//           Stack(
//             children: [
//               Container(
//                 color: Colors.pink,
//                 height: 300.0,
//                 child: MapBoxNavigationView(
//                   options: _options,
//                   onRouteEvent: _onEmbeddedRouteEvent,
//                   onCreated: (MapBoxNavigationViewController controller) async {
//                     _controller = controller;
//                     controller.initialize();
//                   }
//                 ),
//               ),
//               if (applicationProcesses.searchResults.isNotEmpty)
//               Container(
//                 height: 300.0,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.6),
//                   backgroundBlendMode: BlendMode.darken
//                 ),
//               ),
//               SizedBox(
//                 height: 300.0,
//                 child: ListView.builder(
//                   itemCount: applicationProcesses.searchResults.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(
//                         applicationProcesses.searchResults[index].description,
//                         style: const TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ]
//           ),
//         ],
//       )
//     );
//   }

//   // Currently this does nothing...I think
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

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/services/bike_station_service.dart';
import 'package:cycle_planner/models/groups.dart';
import 'package:cycle_planner/views/nav_bar.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'dart:math';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(-33.852, 151.211), // 51.509865, -0.118092
    zoom: 11.0,
  );

  // Mandem's part of the code:
  final _origin = const LatLng( // Big Ben
    51.500863,
    -0.124593
  );

  final _stop1 = const LatLng( // Buckingham
    51.50204176039292,
    -0.14188788458748477
  );

  final _stop2 = const LatLng( // British Museum
      51.521285300295474,
      -0.126953347081018
    );

  final _stop3 = const LatLng( // Trafalgar Square
    51.50809338374528,
    -0.12804891498586773
  );

  final _stop4 = const LatLng( // London Eye
    51.50461919293181,
    -0.11954631306912968
  );

  var wayPoints = <LatLng>[];

  final bool _isMultipleStop = false;

  Groups groupSize = Groups(groupSize: 1);

  BikeStationService bikeStationService = BikeStationService();

  MapboxMapController? mapController;
  CameraPosition _position = _kInitialPosition;
  bool _isMoving = false;
  bool _compassEnabled = true;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool? _doubleClickToZoomEnabled;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = true;
  bool _telemetryEnabled = true;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.Tracking;
  List<Object>? _featureQueryFilter;
  Fill? _selectedFill;

  @override
  void initState() {
    super.initState();
  }

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  void _extractMapInfo() {
    final position = mapController!.cameraPosition;
    if (position != null) {
      _position = position;
    }
    _isMoving = mapController!.isCameraMoving;
  }

    @override
  void dispose() {
    mapController?.removeListener(_onMapChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationProcesses = Provider.of<ApplicationProcesses>(context);
    final MapboxMap mapboxMap = MapboxMap(
      accessToken: "pk.eyJ1IjoiaW1wYWxhMTIzIiwiYSI6ImNrejV4ZDNxcTA2N2MydW11anFzNDJnOXUifQ.EWZPxqNNOhJEsJ59_PaZzg",
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      trackCameraPosition: true,
      cameraTargetBounds: _cameraTargetBounds,
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      doubleClickZoomEnabled: _doubleClickToZoomEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationTrackingMode: _myLocationTrackingMode,
      myLocationRenderMode: MyLocationRenderMode.GPS,
      onMapClick: (point, latLng) async {
        print("Map click: ${point.x}, ${point.y}   ${latLng.latitude}/${latLng.longitude}");
      },
      onMapLongClick: (point, latLng) async {
        print("Map long press: ${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
        Point convertedPoint = await mapController!.toScreenLocation(latLng);

        LatLng convertedLatLng = await mapController!.toLatLng(point);
        print("Map long press converted: ${convertedPoint.x},${convertedPoint.y}   ${convertedLatLng.latitude}/${convertedLatLng.longitude}");

        double metersPerPixel = await mapController!.getMetersPerPixelAtLatitude(latLng.latitude);
        print("Map long press The distance measured in meters at latitude ${latLng.latitude} is $metersPerPixel m");
      },
      onCameraTrackingDismissed: () {
        setState(() {
          _myLocationTrackingMode = MyLocationTrackingMode.None;
        });
      },
      onUserLocationUpdated: (location) {
        setState(() {
          print("new location: ${location.position}, alt.: ${location.altitude}, bearing: ${location.bearing}, speed: ${location.speed}, horiz. accuracy: ${location.horizontalAccuracy}, vert. accuracy: ${location.verticalAccuracy}");
        });
      },
    );

    final List<Widget> listViewChildren = <Widget>[];

    if (mapController != null) {
      listViewChildren.addAll(
        <Widget>[
          Text('camera bearing: ${_position.bearing}'),
          Text('camera target: ${_position.target.latitude.toStringAsFixed(4)},'
              '${_position.target.longitude.toStringAsFixed(4)}'),
          Text('camera zoom: ${_position.zoom}'),
          Text('camera tilt: ${_position.tilt}'),
          Text(_isMoving ? '(Camera moving)' : '(Camera idle)'),
        ],
      );
    }
    return ChangeNotifierProvider(
      create: (context) => ApplicationProcesses(),
      child: MaterialApp(
        title: 'Mapbox_gl test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          drawer: const NavBar(),
          appBar: AppBar(
            title: const Text('Mapbox_gl Test')
          ),
          body: (applicationProcesses.setCurrentLocation() == null) ? const Center(child: CircularProgressIndicator())
          :ListView(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search Location',
                        icon: Icon(Icons.search)
                      ),
                      onChanged: (value) => applicationProcesses.searchPlaces(value),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    children: <Widget>[
                      const Text(
                        "Group Size",
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      SpinBox(
                        min: 1.0,
                        max: 8.0,
                        value: groupSize.getGroupSize().toDouble(),
                        onChanged: (value) => setState(() {
                          groupSize.setGroupSize(value.toInt());
                        }),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      ElevatedButton(
                        child: const Text("Start Route"),
                        onPressed: () async {
                          final _currentPosition = LatLng(
                            applicationProcesses.currentLocation!.latitude,
                            applicationProcesses.currentLocation!.longitude
                          );

                          wayPoints.clear();
                          wayPoints.add(_currentPosition);
                          wayPoints.add(_origin);
                          wayPoints.add(_stop1);
                          
                          // Find closest start station
                          LatLng start = wayPoints.first;
                          Future<Map> futureOfStartStation = bikeStationService.getStationWithBikes(start.latitude, start.longitude, groupSize.getGroupSize());
                          Map startStation = await futureOfStartStation;
                          LatLng startStationWayPoint = LatLng(
                            startStation['lat'],
                            startStation['lon']
                          );
                          wayPoints.insert(1, startStationWayPoint);

                          // Find closest end station
                          LatLng end = wayPoints.last;
                          Future<Map> futureOfEndStation = BikeStationService().getStationWithSpaces(end.latitude, end.longitude, groupSize.getGroupSize());
                          Map endStation = await futureOfEndStation;
                          LatLng endStationWayPoint = LatLng(
                            endStation['lat'],
                            endStation['lon']
                          );
                          wayPoints.add(endStationWayPoint);
                          
                          // Add navigation here
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Stack(
                    children: [
                      SizedBox(
                        width: 400.0,
                        height: 530.0,
                        child: mapboxMap,
                      ),
                      if (applicationProcesses.searchResults.isNotEmpty)
                      Container(
                        height: 300.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          backgroundBlendMode: BlendMode.darken
                        ),
                      ),
                      SizedBox(
                        height: 300.0,
                        child: ListView.builder(
                          itemCount: applicationProcesses.searchResults.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                applicationProcesses.searchResults[index].description,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                        )
                      ),
                    ]
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController!.addListener(_onMapChanged);
    _extractMapInfo();

    mapController!.getTelemetryEnabled().then((isEnabled) => setState(() {
          _telemetryEnabled = isEnabled;
        }));
  }
}
