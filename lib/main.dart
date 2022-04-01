import 'package:cycle_planner/services/authentication_provider.dart';
import 'package:cycle_planner/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cycle_planner/views/home_screen.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void>main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class
MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationProvider>(
            create: (_) => AuthenticationProvider(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) => context.read<AuthenticationProvider>().authState,
          )
        ],

    // return ChangeNotifierProvider(
    //   create: (context) => ApplicationProcesses(),
      child: MaterialApp(
        title: 'Cycle Planner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Authenticate(),
      ),
    );
  }
}