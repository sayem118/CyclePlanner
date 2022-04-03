import 'dart:async';
import 'package:cycle_planner/views/home_screen.dart';
import 'package:cycle_planner/views/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  late String userUid;

  Future getUid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userUid= sharedPreferences.getString('email')!;
    if (kDebugMode) {
      print(userUid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    getUid().whenComplete(() => {
      Timer(
        const Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context,
              PageTransition(
                  child: userUid == null ? const LoginScreen() : const HomeScreen(),
                  type: PageTransitionType.leftToRightWithFade)))
    });
    super.initState();
  }

  startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(context, MaterialPageRoute(
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
            Container(

              child: Image.asset("assets/cyclebaynew.png",
                width: 300,
                height: 300,
               fit: BoxFit.cover,
              ),
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

//
// class _SplashScreenState extends State <SplashScreen> with TickerProviderStateMixin {
//
//   late final AnimationController _controller = AnimationController(
//     duration: const Duration(seconds: 3),
//       vsync: this)..repeat();
//
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _controller.dispose();
//   }
//   @override
//   void initState(){
//     super.initState();
//
//     Timer(const Duration(seconds: 4),
//         () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()))
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0x072d5e3e),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             AnimatedBuilder(
//                 animation: _controller,
//                 child: Container(
//                   width: 200.0,
//                   height: 200.0,
//
//                   child: const Center(
//                     child: Image(
//                       fit: BoxFit.cover,
//                       image: AssetImage('assets/cyclebaylogoo.png'),
//                     ),
//                   ),
//                 ),
//                 builder: (BuildContext context, Widget? child) {
//                   return Transform.rotate(
//                     angle: _controller.value * 2.0 * math.pi,
//                         child: child,
//                   );
//                 },
//             ),
//
//             SizedBox(height: MediaQuery.of(context).size.height * .08,),
//             const Align(
//               alignment: Alignment.center,
//               child: Text('Take a ride around London!',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 25
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }