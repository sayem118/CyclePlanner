import 'dart:async';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/services/marker_service.dart';
import 'package:cycle_planner/services/places_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cycle_planner/models/location.dart';
import 'package:cycle_planner/models/geometry.dart';
import 'package:cycle_planner/models/place.dart';
import 'package:cycle_planner/models/place_search.dart';
import 'package:geolocator/geolocator.dart';

final appProcesses = ApplicationProcesses();

void main(){

  group('ApplicationProcess2', () {

  test('GetGroupSize', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final groupSizeNum = appProcesses.groupSize;

    expect(appProcesses.getGroupSize(), groupSizeNum);


  });

  test('setGroupSize', () async {
    appProcesses.setGroupSize(2);
    //ensure the number 2 is set
    expect(appProcesses.groupSize, 2);
  });

});
}



