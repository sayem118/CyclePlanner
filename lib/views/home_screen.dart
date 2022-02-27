import 'package:flutter/material.dart';
import 'package:cycle_planner/processes/application_processes.dart';
// import 'package:cycle_planner/services/bike_station_service.dart';
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

  // Ammar's refactored code, doesn't work for now
  // BikeStationSevice bikeStationSevice = BikeStationSevice();

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

                 // Find closest start location
                 WayPoint start = wayPoints.first;
                
                 // For debugging
                 // print("The closest start location is: $start"); // Output -> The closest start location is: WayPoint{latitude: 55.1175275, longitude: 0.4839524}

                 // Using Ammar's refactored code, doesn't work for now
                 // Future<Map> futureOfStartStation = bikeStationSevice.getStationWithBikes(start.latitude, start.longitude, groupSize.getGroupSize());

                 Future<Map> futureOfStartStation = getStationWithBikes(start.latitude, start.longitude);
                 Map startStation = await futureOfStartStation;
                 //  print("This is an example of map: $startStation");
                 WayPoint startStationWayPoint = WayPoint(
                   name: "startStation",
                   latitude: startStation['lat'],
                   longitude: startStation['lon']
                 );
                 // For debugging
                 // print("The start point way point is:$startStationWayPoint");
                 wayPoints.insert(1, startStationWayPoint);


                 // Find closest end station
                 WayPoint end = wayPoints.last;

                 // Using Ammar's refactored code, doesn't work for now.
                 // Future<Map> futureOfEndStation = bikeStationSevice.getStationWithSpaces(end.latitude, end.longitude, groupSize.getGroupSize());

                 Future<Map> futureOfEndStation = getStationWithSpaces(end.latitude, end.longitude);
                 Map endStation = await futureOfEndStation;
                 WayPoint endStationWayPoint = WayPoint(
                   name: "endStation",
                   latitude: endStation['lat'],
                   longitude: endStation['lon']
                 );
                 wayPoints.add(endStationWayPoint);

                 // Start navigating
                 await _directions.startNavigation(
                   wayPoints: wayPoints,
                   options: _options
                 );
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

  // Currently this does nothing...I think
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

  // To be refactored later...
  Future<Map> getStationWithBikes(double ?lat, double ?lon) async {
    Future<List> futureOfStations = getClosestStations(lat, lon);
    List stations = await futureOfStations;

    for (int i = 0; i < stations.length; i++) {
      if (int.parse(stations[i]['additionalProperties'][6]['value']) >= groupSize.getGroupSize()) {
        return stations[i];
      }
    }
    return{};
  }

  Future<Map> getStationWithSpaces(double ?lat, double ?lon) async {
    Future<List> futureOfStations = getClosestStations(lat, lon);
    List stations = await futureOfStations;

    for (int i = 0; i < stations.length; i++) {
      if (int.parse(stations[i]['additionalProperties'][7]['value']) >= groupSize.getGroupSize()) {
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
}