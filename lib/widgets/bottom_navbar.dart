import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int? index;

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
          Icon(Icons.info, size: 27.0,),
        ],
        height: 60.0,
        color: (Colors.cyan[300])!,
        buttonBackgroundColor: Colors.orange[400],
        backgroundColor: Colors.transparent,
        index: 3,
        animationDuration: const Duration(milliseconds: 330),
        onTap: (index) => setState(() => this.index = index),
      ),
    );
  }
}