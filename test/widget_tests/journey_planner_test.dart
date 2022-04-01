import 'package:cycle_planner/processes/application_processes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/widgets/journey_planner.dart';
import 'package:provider/provider.dart';

void main() {
  group('Journey Planner -', () {
    late Widget journeyPlanner;

    setUp(() {
      journeyPlanner =  ChangeNotifierProvider(
        create: (context) => ApplicationProcesses(),
        child: MaterialApp(
          title: 'Cycle Planner',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const JourneyPlanner(),
        ),
      );
    });
  });
}