import 'package:cycle_planner/services/mapbox_navigation_service.dart';
import 'package:cycle_planner/widgets/group_size.dart';
// import 'package:cycle_planner/widgets/mapbox_navigation-COMMENTED.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:cycle_planner/Widgets/nav_bar.dart';


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
            switch (screenindex) {
              case 0: {
                _selectedIndex = screenindex;
                widget.scaffoldKey.currentState!.openDrawer();
              }
              break;
              case 1: {
                _selectedIndex = screenindex;
                break;
              }
              case 2: {
                _selectedIndex = screenindex;
                break;
              }
              case 3: {
                _selectedIndex = screenindex;
                MapboxNavigationService().mapboxBegin();
              }
              break;
              case 4: {
                _selectedIndex = screenindex;
                break;
              }
              case 5: {
                _selectedIndex = screenindex;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GroupSize()),
                );
                break;
              }
            }
            print(_selectedIndex);
          });
        },
      ),
    );
  }
}