import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycle_planner/widgets/saved_places.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../models/user_model.dart';
import '../views/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blueGrey,

      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurple.shade200],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.5, 0.9],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.black12,
                      minRadius: 35.0,
                      child: Icon(
                          Icons.call,
                          size: 30.0
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white70,
                      minRadius: 60.0,
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage:
                        AssetImage("assets/cyclebaynew.png"),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.black12,
                      minRadius: 35.0,
                      child: Icon(
                          Icons.message,
                          size: 30.0
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
          Text("${loggedInUser.firstName ??"Guest" } ${loggedInUser.secondName ?? "User"}  ",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
            Text("${loggedInUser.email ?? ""}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.deepPurple.shade300,
              child: Container(
                color: Colors.deepPurple,
                child: ListTile(

                  leading: const Icon(Icons.favorite),
                  title: const Text('Go to your Saved places',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return SavedPlaces();
                    },),)
                  },
                ),
              ),
                ),),

              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Name',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text("${loggedInUser.firstName ??"Guest" } ${loggedInUser.secondName ?? "User"}  ",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${loggedInUser.email ?? ""}",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                ),
                Divider(),
                ActionChip(
                  label: Text("Logout"),
                  onPressed: () {
                    logout(context);
                  },
                ),
                Divider(),
        ActionChip(
          label: Text("Delete account"),
        onPressed: () => showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete account'),
        content: const Text('Are you sure you would like to delete this account?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deleteAccount(context);
            },
            child: const Text('Delete'),

          ),
        ],
      ),
    ),

    ),

              ],
            ),
          )
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

  Future<void> deleteAccount(BuildContext context) async {
    user?.delete();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile"),
//         backgroundColor: Colors.blueGrey,
//
//       ),
//       body: ListView(
//         physics: BouncingScrollPhysics(),
//         children: [
//           Text("${loggedInUser.firstName ??"Guest" } ${loggedInUser.secondName ?? "User"}  ",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
//           ),
//           const SizedBox(height: 4),
//           Text("${loggedInUser.email ?? ""}",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
//           )
//         ],
//       ),
//
//     );
//
//
//   // Widget buildName(User user) => Column(
//   //   children: [
//   // Text("${loggedInUser.firstName ??"Guest" } ${loggedInUser.secondName ?? "User"}  ",
//   //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//   //     ),
//   //     const SizedBox(height: 4),
//   // Text("${loggedInUser.email ?? ""}",
//   //       style: TextStyle(color: Colors.grey),
//   //     )
//   //   ],
//   // );
//
//
// }