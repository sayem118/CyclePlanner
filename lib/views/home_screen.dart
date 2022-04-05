import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cycle_planner/widgets/google_map_page.dart';
import 'package:cycle_planner/widgets/bottom_navbar.dart';
import 'package:cycle_planner/widgets/nav_bar.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Main page for routes & direction overview.
/// Display Google Maps UI, Search Bar
/// Navbar and Bottom navbar

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Class variables
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

  @override
  Widget build(BuildContext context) {
    final applicationProcesses = Provider.of<ApplicationProcesses>(context);
    return SafeArea(
      bottom: true,
      child: Scaffold(
        key: scaffoldKey,
        extendBody: true,
        drawer: const NavBar(),
        body: GoogleMapPage(mapController: _mapController),
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
