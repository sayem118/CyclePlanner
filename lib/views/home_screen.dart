import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/services/bike_station_service.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:cycle_planner/models/groups.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:cycle_planner/views/nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Hard coded waypoints for testing purposes
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

  final _stop2 = WayPoint(
      name: "British Museum",
      latitude: 51.521285300295474,
      longitude: -0.126953347081018
    );

  final _stop3 = WayPoint(
    name: "Trafalgar Square",
    latitude: 51.50809338374528,
    longitude: -0.12804891498586773
  );

  final _stop4 = WayPoint(
    name: "London Eye",
    latitude: 51.50461919293181,
    longitude: -0.11954631306912968
  );


  var wayPoints = <WayPoint>[];
  late MapBoxNavigation _directions;
  late MapBoxOptions _options;

  bool _isMultipleStop = false;

  late MapBoxNavigationViewController _controller;

  Groups groupSize = Groups(groupSize: 1);

  BikeStationService bikeStationService = BikeStationService();

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
      initialLatitude: ApplicationProcesses().currentLocation?.latitude, // Hard coded value: 51.509865
      initialLongitude: ApplicationProcesses().currentLocation?.longitude, // Hard coded value: -0.118092
      zoom: 15.0,
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
      longPressDestinationEnabled: true,
      language: "en"
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final applicationProcesses = Provider.of<ApplicationProcesses>(context);
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text("Cycle Planner"),
      ),
      body: (applicationProcesses.setCurrentLocation() == null) ? const Center(child: CircularProgressIndicator())
      :ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              key: const Key("Search Location"),
              decoration: const InputDecoration(
                hintText: 'Search Location',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => applicationProcesses.searchPlaces(value),
            ),
          ),
          Column(
            children: <Widget>[
              const SizedBox(height: 20.0,),
              const Text(
                "Group Size",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SpinBox(
                min: 1,
                max: 8,
                value: groupSize.getGroupSize().toDouble(),
                onChanged: (value) => setState(() {
                  groupSize.setGroupSize(value.toInt());
                }),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Text("Start Route"),
                onPressed: () async {

                 final _currentPosition = WayPoint(
                   name: "Current Position",
                   latitude: applicationProcesses.currentLocation?.latitude, // Hard coded value: 55.1175275,
                   longitude: applicationProcesses.currentLocation?.longitude // Hard coded value: 0.4839524
                 );

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
                 // These are random coords in East that don't have any bike stations nearby. So uncomment if you wanna see the 'no available bike stations alert.
                 // Future<Map> futureOfStartStation = bikeStationService.getStationWithBikes(51.54735235426037, 0.08849463623212586, groupSize.getGroupSize());
                 Future<Map> futureOfStartStation = bikeStationService.getStationWithBikes(start.latitude, start.longitude, groupSize.getGroupSize());
                 Map startStation = await futureOfStartStation;

                 // Find closest end station
                 WayPoint end = wayPoints.last;
                 Future<Map> futureOfEndStation = BikeStationService().getStationWithSpaces(end.latitude, end.longitude, groupSize.getGroupSize());
                 Map endStation = await futureOfEndStation;

                 // check if there are available bike stations nearby. If not the user is alerted.
                 if(startStation.isEmpty || endStation.isEmpty) {
                   _showNoStationsAlert(context);
                 }
                 else {
                   WayPoint startStationWayPoint = WayPoint(
                       name: "startStation",
                       latitude: startStation['lat'],
                       longitude: startStation['lon']
                   );
                   wayPoints.insert(1, startStationWayPoint);

                   WayPoint endStationWayPoint = WayPoint(
                       name: "endStation",
                       latitude: endStation['lat'],
                       longitude: endStation['lon']
                   );
                   wayPoints.add(endStationWayPoint);

                   // update stations every 3 minutes.
                   Timer timer = Timer.periodic(const Duration(minutes: 3), (Timer t) => updateClosestStations());

                   // Start navigating
                   await _directions.startNavigation(
                       wayPoints: wayPoints,
                       options: _options
                   );
                 }

                 //  print("This is an example of map: $startStation");
                 
                 // For debugging -> Prints waypoints & bike station's name, latitude and longitude
                 // for (int i = 0; i < wayPoints.length; i++){print("Waypoint station are: ${wayPoints[i].name}, ${wayPoints[i]}");}
                 // for (int i = 1; i < startStation.length; i++){print("Bike station no.$i is: ${startStation}");}
                 // print("bike station map size: ${startStation.length}");

                }
              )
            ],
          ),
          const SizedBox(height: 20.0,),
          Stack(
            children: [
              Container(
                color: Colors.pink,
                height: 300.0,
                child: MapBoxNavigationView(
                  options: _options,
                  onRouteEvent: _onEmbeddedRouteEvent,
                  onCreated: (MapBoxNavigationViewController controller) async {
                    _controller = controller;
                    controller.initialize();
                  }
                ),
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
                  },
                ),
              ),
            ]
          ),
        ],
      )
    );
  }

  // Creates alert if there are no available bike stations nearby.
  Future<void> _showNoStationsAlert(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Oh no...'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Looks like there are no available bike stations nearby.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // This acts as a listener for events during the navigation
  // so in different cases we can set the code to do different things I.E case mapbox.navigation_cancelled means if route is cancelled
  //we do whatever
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

  void updateClosestStations() async {
    // Find closest start station
    WayPoint start = wayPoints.first;
    // These are random coords in East that don't have any bike stations nearby.
    //Future<Map> futureOfStartStation = bikeStationService.getStationWithBikes(51.54735235426037, 0.08849463623212586, groupSize.getGroupSize());
    Future<Map> futureOfStartStation = bikeStationService.getStationWithBikes(start.latitude, start.longitude, groupSize.getGroupSize());
    Map startStation = await futureOfStartStation;

    // Find closest end station
    WayPoint end = wayPoints[wayPoints.length - 2];
    Future<Map> futureOfEndStation = BikeStationService().getStationWithSpaces(
        end.latitude, end.longitude, groupSize.getGroupSize());
    Map endStation = await futureOfEndStation;

    // check if there are available bike stations nearby. If not the user is alerted.
    if (startStation.isEmpty || endStation.isEmpty) {
      // if there are no close available bike stations I was gonna exit the navigation and display an alert,
      // but a station might free up in the next time interval so not sure what to do here...
    }
    else {
      // check if stations have changed.
      if ((startStation['lat'] != wayPoints[1].latitude && startStation['lon'] != wayPoints[1].longitude) || (endStation['lat'] != wayPoints[wayPoints.length - 1].latitude && endStation['lon'] != wayPoints[wayPoints.length - 1].longitude)) {
        // update stations to new stations.
        WayPoint startStationWayPoint = WayPoint(
            name: "startStation",
            latitude: startStation['lat'],
            longitude: startStation['lon']
        );
        wayPoints[1] = startStationWayPoint;

        WayPoint endStationWayPoint = WayPoint(
            name: "endStation",
            latitude: endStation['lat'],
            longitude: endStation['lon']
        );
        wayPoints[wayPoints.length - 1] = endStationWayPoint;

        // exit turn by turn navigation and then start again with new waypoints.
        _directions.finishNavigation();
        _directions.startNavigation(wayPoints: wayPoints, options: _options);
      }
    }
  }
}


