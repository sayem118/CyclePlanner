import 'package:cycle_planner/services/mapbox_navigation_service.dart';
// import 'package:cycle_planner/widgets/mapbox_navigation-COMMENTED.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cycle_planner/Widgets/nav_bar.dart';


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

  int _selectedIndex = 3;

  // Templates
  final screens = [
    const NavBar(),
    const Text("Bike stations"),
    const Text("Add stop"),
    MapboxNavigationService(),
    const Text("Directions"),
    const Text("Groups"),
    const Text("Info"),
  ];

  @override
  Widget build(BuildContext context) {

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
            screenindex == 0 ? widget.scaffoldKey.currentState!.openDrawer()
            : _selectedIndex = screens.indexOf(screens.elementAt(screenindex));

            switch (screenindex) {
              case 0: {
                widget.scaffoldKey.currentState!.openDrawer();
                _selectedIndex = screens.indexOf(screens.elementAt(screenindex));
              }
              break;
              case 3: {
                // print("open mapbox");
                MapboxNavigationService().mapboxBegin();
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => screens[screenindex]));
                _selectedIndex = screens.indexOf(screens.elementAt(screenindex));
              }
              break;
            }
          });
        },
      ),
    );
  }
}