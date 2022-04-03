import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cycle_planner/widgets/iconic_places.dart';
import 'package:cycle_planner/models/user_model.dart';

import '../views/login_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}
  class _NavBarState extends State<NavBar> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
  FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get()
      .then((value)
  {
  this.loggedInUser = UserModel.fromMap(value.data());
  setState(() {});

  });
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("${loggedInUser.firstName} ${loggedInUser.secondName}"),
            // style: TextStyle(
            //  color: Colors.black,
            //  fontWeight: FontWeight.bold,)
            //)
            accountEmail: Text("${loggedInUser.email}"),
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
                  'https://media1.giphy.com/media/2Ozjbk786Umdy/giphy.gif?cid=ecf05e47vihcftxs1yzhnt85rsxcs9xhjkka9yalmlet95jd&rid=giphy.gif&ct=g'
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Profile'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const IconicScreen();
              },),)
            },
          ),
          ListTile(
            leading: const Icon(Icons.place_sharp),
            title: const Text('Iconic places'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const IconicScreen();
              },),)
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Saved places'),
            onTap: () => {}
              // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              //   return SavedPlaces();
              // },),)
            //},
          ),
          const Divider(),
          ListTile(
            leading:const Icon(Icons.info),
            title: const Text('Info'),
            onTap: () => {null},
          ),
          const Divider(),
          ActionChip(
            label: Text("Logout"),
            onPressed: () {
              logout(context);
            },
          ),
        ],
      ),

    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
