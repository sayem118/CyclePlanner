import 'package:cycle_planner/views/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../views/login_screeen.dart';
import '../views/login_screen.dart';

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Instance to know the authentication state.
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      //Means that the user is logged in already and hence navigate to HomePage
      return HomeScreen();
    }
    //The user isn't logged in and hence navigate to SignInPage.
    return LoginScreen();
  }
}