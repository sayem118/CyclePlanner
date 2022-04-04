import 'dart:async';
import 'package:cycle_planner/views/home_screen.dart';
import 'package:cycle_planner/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      User? currentUser= FirebaseAuth.instance.currentUser;
      if(currentUser == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false
        );
      }
      else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false
        );
      }
    });
  }

  startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => const HomeScreen()
      )
    );
  }

  initScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/CYCLEBAY.gif",
              width: 300,
              height: 295,
              fit: BoxFit.cover,
            ),
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            const Text(
              "Take a ride around London!",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            const CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 1,
            )
          ],
        ),
      ),
    );
  }
}
