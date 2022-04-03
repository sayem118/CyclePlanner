import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/widgets/mapbox_navigation.dart';
import 'package:cycle_planner/widgets/search_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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

  final int _selectedIndex = 3;

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
                applicationProcesses.toggleBikeMarker();
                break;
              }
              case 2: {
                showSearch(context: context, delegate: SearchPage());
                break;
              }
              case 3: {
                if(applicationProcesses.polylines.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MapboxNavigation(bike_stations: applicationProcesses.bikeStations)));
                }
              }
              break;
              case 4: {
                applicationProcesses.drawNewRouteIfPossible(context);
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