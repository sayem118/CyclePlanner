import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycle_planner/widgets/saved_places.dart';
import 'package:cycle_planner/widgets/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cycle_planner/widgets/iconic_places.dart';
import 'package:cycle_planner/models/user_model.dart';
import 'package:cycle_planner/views/login_screen.dart';
import 'package:cycle_planner/widgets/info_page.dart';

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
            accountName: Text("${loggedInUser.firstName ??"Guest" } ${loggedInUser.secondName ?? "User"}  " ,
            style: const TextStyle(
             color: Colors.black,
             fontWeight: FontWeight.bold,)
            ),
            accountEmail: Text("${loggedInUser.email ?? ""}" ,
              style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,)
    ),

            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  "assets/CYCLEBAY.gif",
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
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => {
              if(!(user!.isAnonymous)) {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => const ProfilePage())
                )
              }
              else {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Sorry you can't view this page"),
                      content: const Text("Sign up or login to view your profile!"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            logout(context);
                          },
                          child: const Text('Login'),

                        ),
                      ],
                    );
                  },
                )
              }
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
            onTap: () => {
              if(!(user!.isAnonymous)) {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) =>  SavedPlaces())
                )
              }
              else {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Sorry you can't view this page"),
                      content: const Text("Sign up or login to view your saved places!"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            logout(context);
                          },
                          child: const Text('Login'),

                        ),
                      ],
                    );
                  },
                )
              }
            },
          ),
          const Divider(),
          ListTile(
            leading:const Icon(Icons.info),
            title: const Text('Info'),
            onTap: () => { Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) =>  InfoPage())
            )},
          ),
          const Divider(),
          ActionChip(
            label: Text("Logout"),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Logout from this account'),
                content: const Text('Are you sure you would like to Logout?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      logout(context);
                    },
                    child: const Text('Logout'),

                  ),
                ],
              ),
            ),

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
