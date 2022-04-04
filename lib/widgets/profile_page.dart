import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycle_planner/widgets/saved_places.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cycle_planner/models/user_model.dart';
import 'package:cycle_planner/views/login_screen.dart';

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
      .then((value) {
        loggedInUser = UserModel.fromMap(value.data());
        setState(() {});
      }
    );
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
                stops: const [0.5, 0.9],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white70,
                      minRadius: 60.0,
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage:
                        AssetImage("assets/CYCLEBAY.gif"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "${loggedInUser.firstName ??"Guest" } ${loggedInUser.secondName ?? "User"}  ",
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(loggedInUser.email ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.deepPurple.shade300,
                  child: Container(
                    color: Colors.deepPurple,
                    child: ListTile(
                      leading: const Icon(Icons.favorite),
                      title: const Text(
                        'Go to your Saved places',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (BuildContext context) => const SavedPlaces())
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "${loggedInUser.firstName ??"Guest" } ${loggedInUser.secondName ?? "User"}  ",
                  style: const TextStyle(
                    fontSize: 18
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  loggedInUser.email ?? "",
                  style: const TextStyle(
                    fontSize: 18
                  ),
                ),
              ),
              const Divider(),
              ActionChip(
                label: const Text("Logout"),
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
              const Divider(),
              ActionChip(
                label: const Text("Delete account"),
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
