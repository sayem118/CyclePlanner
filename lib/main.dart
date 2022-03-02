// import 'package:flutter/material.dart';
// import 'package:cycle_planner/views/home_screen.dart';
// import 'package:cycle_planner/processes/application_processes.dart';
// import 'package:provider/provider.dart';


// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => ApplicationProcesses(),
//       child: MaterialApp(
//         title: 'Cycle Planner',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: const HomeScreen(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(home: MapboxExample()));
}

class MapboxExample extends StatefulWidget {
  const MapboxExample({ Key? key }) : super(key: key);

  @override
  State<MapboxExample> createState() => _MapboxExampleState();
}

class _MapboxExampleState extends State<MapboxExample> {

  static const String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN", defaultValue:"pk.eyJ1IjoiaW1wYWxhMTIzIiwiYSI6ImNrejV4ZDNxcTA2N2MydW11anFzNDJnOXUifQ.EWZPxqNNOhJEsJ59_PaZzg");

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(-33.852, 151.211), // 51.509865, -0.118092
    zoom: 11.0,
  );

  MapboxMapController? mapController;
  CameraPosition _position = _kInitialPosition;
  bool _isMoving = false;
  bool _compassEnabled = true;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool? _doubleClickToZoomEnabled;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = true;
  bool _telemetryEnabled = true;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.Tracking;
  List<Object>? _featureQueryFilter;
  Fill? _selectedFill;

  @override
  void initState() {
    super.initState();
  }

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  void _extractMapInfo() {
    final position = mapController!.cameraPosition;
    if (position != null) {
      _position = position;
    }
    _isMoving = mapController!.isCameraMoving;
  }

    @override
  void dispose() {
    mapController?.removeListener(_onMapChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
      accessToken: "pk.eyJ1IjoiaW1wYWxhMTIzIiwiYSI6ImNrejV4ZDNxcTA2N2MydW11anFzNDJnOXUifQ.EWZPxqNNOhJEsJ59_PaZzg",
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      trackCameraPosition: true,
      cameraTargetBounds: _cameraTargetBounds,
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      doubleClickZoomEnabled: _doubleClickToZoomEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationTrackingMode: _myLocationTrackingMode,
      myLocationRenderMode: MyLocationRenderMode.GPS,
      onMapClick: (point, latLng) async {
        print("Map click: ${point.x}, ${point.y}   ${latLng.latitude}/${latLng.longitude}");
      },
      onMapLongClick: (point, latLng) async {
        print("Map long press: ${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
        Point convertedPoint = await mapController!.toScreenLocation(latLng);

        LatLng convertedLatLng = await mapController!.toLatLng(point);
        print("Map long press converted: ${convertedPoint.x},${convertedPoint.y}   ${convertedLatLng.latitude}/${convertedLatLng.longitude}");

        double metersPerPixel = await mapController!.getMetersPerPixelAtLatitude(latLng.latitude);
        print("Map long press The distance measured in meters at latitude ${latLng.latitude} is $metersPerPixel m");
      },
      onCameraTrackingDismissed: () {
        setState(() {
          _myLocationTrackingMode = MyLocationTrackingMode.None;
        });
      },
      onUserLocationUpdated: (location) {
        setState(() {
          print("new location: ${location.position}, alt.: ${location.altitude}, bearing: ${location.bearing}, speed: ${location.speed}, horiz. accuracy: ${location.horizontalAccuracy}, vert. accuracy: ${location.verticalAccuracy}");
        });
      },
    );

    final List<Widget> listViewChildren = <Widget>[];

    if (mapController != null) {
      listViewChildren.addAll(
        <Widget>[
          Text('camera bearing: ${_position.bearing}'),
          Text('camera target: ${_position.target.latitude.toStringAsFixed(4)},'
              '${_position.target.longitude.toStringAsFixed(4)}'),
          Text('camera zoom: ${_position.zoom}'),
          Text('camera tilt: ${_position.tilt}'),
          Text(_isMoving ? '(Camera moving)' : '(Camera idle)'),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapbox_gl Test')
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: SizedBox(
              width: 400.0,
              height: 600.0,
              child: mapboxMap,
            ),
          )
        ],
      ),
    );
  }

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController!.addListener(_onMapChanged);
    _extractMapInfo();

    mapController!.getTelemetryEnabled().then((isEnabled) => setState(() {
          _telemetryEnabled = isEnabled;
        }));
  }
}
