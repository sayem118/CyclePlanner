import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cycle_planner/widgets/iconic_places.dart';
import 'package:app_settings/app_settings.dart';


class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Welcome to Cycle Planner!'),
            accountEmail: const Text(''),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://media1.giphy.com/media/l41lYNASsqlUOt9Xq/giphy.gif',
                  fit: BoxFit.fill,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://media1.giphy.com/media/2Ozjbk786Umdy/giphy.gif?cid=ecf05e47vihcftxs1yzhnt85rsxcs9xhjkka9yalmlet95jd&rid=giphy.gif&ct=g')
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Iconic places'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const IconicScreen(
                );
              },),)
            },
          ),
          ListTile(
            leading: const Icon(Icons.place_sharp),
            title: const Text('Saved places'),
            onTap: () => {null},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => AppSettings.openLocationSettings,
          ),
          ListTile(
            leading:const Icon(Icons.info),
            title: const Text('Info'),
            onTap: () => {null},
          ),
          const Divider(),
          ListTile(
            title: const Text('Exit'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () => exit(0),
          ),
        ],
      ),
    );
  }
}
