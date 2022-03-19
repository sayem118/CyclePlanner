import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cycle_planner/widgets/bottom_navbar.dart';
import 'package:cycle_planner/widgets/nav_bar.dart';
import 'package:cycle_planner/widgets/search_bar.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/services/bike_station_service.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:cycle_planner/models/groups.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cycle_planner/models/place.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _mapController= Completer();
  late StreamSubscription locationSubscription;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  late List<LatLng> nPoints = [];

  @override
  void initState() {
    final applicationProcesses = Provider.of<ApplicationProcesses>(context,listen: false);
      locationSubscription = applicationProcesses.selectedLocation.stream.listen((place) {
        _goToPlace(place);
      }
    );
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    final applicationProcesses = Provider.of<ApplicationProcesses>(context, listen:false);
    applicationProcesses.dispose();
    locationSubscription.cancel();
    super.dispose();
  }

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

  final marker1 = const Marker(
    markerId: MarkerId("London eye"),
    position: LatLng(51.50461919293181, -0.11954631306912968)
  );

  final marker2 = const Marker(
    markerId: MarkerId("Trafalgar Square"),
    position: LatLng(51.50809338374528, -0.12804891498586773)
  );

  final marker3 = const Marker(
    markerId: MarkerId("museum"),
    position: LatLng(51.50809338374528, -0.126953347081018)
  );

  final marker5 = const Marker(
    markerId: MarkerId("knightsbridge"),
    position: LatLng(51.50809338374528, -0.16162)
  );



  var wayPoints = <WayPoint>[];
  late MapBoxNavigation _directions;
  late MapBoxOptions _options;

  bool _isMultipleStop = false;

  final LatLng _center = const LatLng(53.1424, 7.6921);
  late MapBoxNavigationViewController _controller;
  late GoogleMapController mapController;
  Groups groupSize = Groups(groupSize: 1);

  BikeStationService bikeStationService = BikeStationService();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
    _options = MapBoxOptions(
      initialLatitude: position.latitude,
      initialLongitude: position.longitude,
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
  
  @override
  Widget build(BuildContext context) {
    final applicationProcesses = Provider.of<ApplicationProcesses>(context);
    // String? searchLabel;
    return SafeArea(
      bottom: true,
      child: Scaffold(
        extendBody: true,
        drawer: const NavBar(),
        // appBar: AppBar(
        //   title: const Text("Cycle Planner"),
        // ),
        body: (applicationProcesses.currentLocation == null) ? const Center(child: CircularProgressIndicator())
        :Stack(
          children: <Widget>[
            Positioned.fill(
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) => _mapController.complete(controller),
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                polylines: _polyline,
                markers: _markers,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: applicationProcesses.currentLocation != null ? LatLng(
                    applicationProcesses.currentLocation!.latitude, 
                    applicationProcesses.currentLocation!.longitude,
                  )
                  : _center,
                  zoom: 11.0,
                ),
              ),
            ),
            const Positioned(
              top: 50.0,
              left: 0.0,
              right: 0.0,
              child: SearchBar()
            ),
    
    
            // Previous cycle planner app, code commented for reference purposes.
    
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextField(
            //     decoration: const InputDecoration(
            //       hintText: 'Search Location',
            //       suffixIcon: Icon(Icons.search),
            //     ),
            //     onChanged: (value) => applicationProcesses.searchPlaces(value)
            //   ),
            // ),
            // Column(
            //   children: <Widget>[
            //     const SizedBox(height: 20.0,),
            //     const Text(
            //       "Group Size",
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     ),
    
            //     SpinBox(
            //       min: 1,
            //       max: 8,
            //       value: groupSize.getGroupSize().toDouble(),
            //       onChanged: (value) => setState(() {
            //         groupSize.setGroupSize(value.toInt());
            //       }),
            //     ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     ElevatedButton(
            //       child: const Text("Start Route"),
            //       onPressed: () async {
    
            //        final _currentPosition = WayPoint(
            //          name: "Current Position",
            //          latitude: applicationProcesses.currentLocation!.latitude, // Hard coded value: 55.1175275,
            //          longitude: applicationProcesses.currentLocation!.longitude // Hard coded value: 0.4839524
            //        );
    
            //        _isMultipleStop = true;
                   
            //        wayPoints.clear();
            //        wayPoints.add(_currentPosition);
            //        wayPoints.add(_origin);
            //        wayPoints.add(_stop1);
            //        wayPoints.add(_stop2);
            //        wayPoints.add(_stop3);
            //        wayPoints.add(_stop4);
    
            //        // Find closest start station
            //        WayPoint start = wayPoints.first;
            //        // These are random coords in East that don't have any bike stations nearby. So uncomment if you wanna see the 'no available bike stations alert.
            //        // Future<Map> futureOfStartStation = bikeStationService.getStationWithBikes(51.54735235426037, 0.08849463623212586, groupSize.getGroupSize());
            //        Future<Map> futureOfStartStation = bikeStationService.getStationWithBikes(start.latitude, start.longitude, groupSize.getGroupSize());
            //        Map startStation = await futureOfStartStation;
    
            //        // Find closest end station
            //        WayPoint end = wayPoints.last;
            //        Future<Map> futureOfEndStation = BikeStationService().getStationWithSpaces(end.latitude, end.longitude, groupSize.getGroupSize());
            //        Map endStation = await futureOfEndStation;
    
            //        // check if there are available bike stations nearby. If not the user is alerted.
            //        if(startStation.isEmpty || endStation.isEmpty) {
            //          _showNoStationsAlert(context);
            //        }
            //        else {
            //          WayPoint startStationWayPoint = WayPoint(
            //             name: "startStation",
            //             latitude: startStation['lat'],
            //             longitude: startStation['lon']
            //          );
            //          wayPoints.insert(1, startStationWayPoint);
    
            //          WayPoint endStationWayPoint = WayPoint(
            //             name: "endStation",
            //             latitude: endStation['lat'],
            //             longitude: endStation['lon']
            //          );
            //          wayPoints.add(endStationWayPoint);
    
            //          // Start navigating
            //          await _directions.startNavigation(
            //             wayPoints: wayPoints,
            //             options: _options
            //          );
            //          setState(() {
            //          });
            //        }
            //       }
            //     ),
            //     const SizedBox(width: 10.0,),
            //     ElevatedButton(
            //       onPressed: () {
            //         drawRouteOverview();
            //       },
            //       child: const Text("Draw Route")
            //     )
            //   ],
            // ),
            // const SizedBox(height: 10.0,),
            // Container(
            //   color: Colors.pink,
            //   height: 455.0,
            //   child: GoogleMap(
            //     onMapCreated: (GoogleMapController controller) => _mapController.complete(controller),
            //     myLocationButtonEnabled: true,
            //     myLocationEnabled: true,
            //     polylines: _polyline,
            //     markers: _markers,
            //     initialCameraPosition: CameraPosition(
            //       target: applicationProcesses.currentLocation != null ? LatLng(
            //         applicationProcesses.currentLocation!.latitude, 
            //         applicationProcesses.currentLocation!.longitude,
            //       )
            //       : _center,
            //       zoom: 10.0,
            //     ),
            //   ),
            // ),
            // if (applicationProcesses.searchResults.isNotEmpty)
            // Container(
            //   height: 300.0,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.black.withOpacity(0.6),
            //     backgroundBlendMode: BlendMode.darken
            //   ),
            // ),
            // if (applicationProcesses.searchResults.isNotEmpty)
            // SizedBox(
            //   height: 200.0,
            //   child: ListView.builder(
            //     itemCount: applicationProcesses.searchResults.length,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         title: Text(
            //           applicationProcesses.searchResults[index].description,
            //           style: const TextStyle(
            //             color: Colors.white,
            //           ),
            //         ),
            //         onTap: () {
            //           applicationProcesses.setSelectedLocation(
            //             applicationProcesses.searchResults[index].placeId
            //           );
            //         }
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat, // To change floatingActionButton's location
        floatingActionButton: FloatingActionButton( // Set camera to the user's current location , will be removed in the future?
          onPressed: () async {
            final GoogleMapController controller = await _mapController.future;
            setState(() {
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(
                      applicationProcesses.currentLocation!.latitude,
                      applicationProcesses.currentLocation!.longitude
                    ),
                    zoom: 14.0,
                  ),
                ),
              );
            });
          },
          child: const Icon(Icons.my_location),
          backgroundColor: Colors.redAccent,
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }

  //method to draw route overview
  //will assume the first 2 and last markers are for getting to the bike stations
  Future<void> drawRouteOverview()  async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //some dummy data
    final marker4 = Marker(
        markerId: const MarkerId("current"),
        position: LatLng(position.latitude, position.longitude)
    );
    //adds markers to the list of markers
    _markers.add(marker4);
    _markers.add(marker1);
    _markers.add(marker2);
    _markers.add(marker3);
    _markers.add(marker5);
    //will go through list of markers
    for(var i = 1; i < _markers.length; i++){
        late PolylinePoints polylinePoints;
        polylinePoints = PolylinePoints();
        final markerS = _markers.elementAt(i - 1);
        final markerd = _markers.elementAt(i);
        final PointLatLng marker1 = PointLatLng(markerd.position.latitude, markerd.position.longitude);
        final PointLatLng marker2 = PointLatLng(markerS.position.latitude, markerS.position.longitude);
        //gets a set of coordinates between 2 markers
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
            "AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY",
            marker1,
            marker2,
            travelMode: TravelMode.bicycling,);
        //drawing route to bike stations
        late List<LatLng> nPoints = [];
        double stuff = 0;
        for (var point in result.points) {
          nPoints.add(LatLng(point.latitude, point.longitude));
          stuff = point.latitude + point.longitude;
        }
        //adds stuff to polyline
        //if its a cycle path line is red otherwise line is blue
        if (i == 1 || i == _markers.length - 1){
          _polyline.add(Polyline(
            polylineId: PolylineId(stuff.toString()),
            points: nPoints,
            color: Colors.red
        ));
      }
        else{
          _polyline.add(Polyline(
              polylineId: PolylineId(stuff.toString()),
              points: nPoints,
              color: Colors.blue
          ));
        }

    }
    setState(() {

    });
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

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
              place.geometry.location.lat, place.geometry.location.lng
          ),
          zoom: 14.0,
        ),
      ),
    );
  }
}
