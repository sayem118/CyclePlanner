import 'dart:async';
import 'package:cycle_planner/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State <SplashScreen> with TickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
      vsync: this)..repeat();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  @override
  void initState(){
    super.initState();

    Timer(const Duration(seconds: 4),
        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()))
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x072d5e3e),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
                animation: _controller,
                child: Container(
                  width: 200.0,
                  height: 200.0,

                  child: const Center(
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/cyclebaylogoo.png'),
                    ),
                  ),
                ),
                builder: (BuildContext context, Widget? child) {
                  return Transform.rotate(
                    angle: _controller.value * 2.0 * math.pi,
                        child: child,
                  );
                },
            ),

            SizedBox(height: MediaQuery.of(context).size.height * .08,),
            const Align(
              alignment: Alignment.center,
              child: Text('Take a ride around London!',
                textAlign: TextAlign.center,
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}