import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycle_planner/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cycle_planner/widgets/google_map_page.dart';
import 'package:cycle_planner/widgets/bottom_navbar.dart';
import 'package:cycle_planner/widgets/nav_bar.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    final applicationProcesses = Provider.of<ApplicationProcesses>(context);
    return SafeArea(
      bottom: true,
      child: Scaffold(
        key: scaffoldKey,
        extendBody: true,
        drawer: const NavBar(),
        body: /*(applicationProcesses.currentLocation == null) ? const Center(child: CircularProgressIndicator())
        :*/GoogleMapPage(mapController: _mapController, applicationProcesses: applicationProcesses),
        floatingActionButton: FloatingActionButton(
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
        bottomNavigationBar: BottomNavBar(scaffoldKey: scaffoldKey),
      ),
    );
  }
}



  // // Creates alert if there are no available bike stations nearby.
  // Future<void> _showNoStationsAlert(context) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Oh no...'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: const <Widget>[
  //               Text('Looks like there are no available bike stations nearby.'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Ok'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
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