import 'package:cycle_planner/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart'; // probably should be removed
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:cycle_planner/widgets/search_bar.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:provider/provider.dart';


class MapPage extends StatefulWidget {
  const MapPage({
    Key? key,
    required Completer<GoogleMapController> mapController,
    required Set<Polyline> polyline,
    required Set<Marker> markers,
    required this.applicationProcesses,
    required LatLng center, 
  }) : _mapController = mapController, _polyline = polyline, _markers = markers, _center = center, super(key: key);

  final Completer<GoogleMapController> _mapController;
  final Set<Polyline> _polyline;
  final Set<Marker> _markers;
  final ApplicationProcesses applicationProcesses;
  final LatLng _center;
  

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late StreamSubscription locationSubscription;
  @override
  void initState() {
    final applicationProcesses = Provider.of<ApplicationProcesses>(context,listen: false);
      locationSubscription = applicationProcesses.selectedLocation.stream.listen((place) {
        _goToPlace(place);
      }
    );
    super.initState();
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: GoogleMap(
            onMapCreated: (GoogleMapController controller) => widget._mapController.complete(controller),
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            polylines: widget._polyline,
            markers: widget._markers,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: widget.applicationProcesses.currentLocation != null ? LatLng(
                widget.applicationProcesses.currentLocation!.latitude, 
                widget.applicationProcesses.currentLocation!.longitude,
              )
              : widget._center,
              zoom: 11.0,
            ),
          ),
        ),
        const Positioned(
          top: 50.0,
          left: 0.0,
          right: 0.0,
          child: SearchBar()
        ),
      ],
    );
  }

  Future<void> drawRouteOverview() async {
    const marker1 = Marker(
      markerId: MarkerId("London eye"),
      position: LatLng(51.50461919293181, -0.11954631306912968)
    );

    const marker2 = Marker(
      markerId: MarkerId("Trafalgar Square"),
      position: LatLng(51.50809338374528, -0.12804891498586773)
    );

    const marker3 = Marker(
      markerId: MarkerId("museum"),
      position: LatLng(51.50809338374528, -0.126953347081018)
    );

    const marker5 = Marker(
      markerId: MarkerId("knightsbridge"),
      position: LatLng(51.50809338374528, -0.16162)
    );

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    //some dummy data
    final marker4 = Marker(
      markerId: const MarkerId("current"),
      position: LatLng(position.latitude, position.longitude)
    );

    //adds markers to the list of markers
    widget._markers.add(marker4);
    widget._markers.add(marker1);
    widget._markers.add(marker2);
    widget._markers.add(marker3);
    widget._markers.add(marker5);

    //will go through list of markers
    for(var i = 1; i < widget._markers.length; i++) {
      late PolylinePoints polylinePoints;
      polylinePoints = PolylinePoints();
      final markerS = widget._markers.elementAt(i - 1);
      final markerd = widget._markers.elementAt(i);
      final PointLatLng marker1 = PointLatLng(markerd.position.latitude, markerd.position.longitude);
      final PointLatLng marker2 = PointLatLng(markerS.position.latitude, markerS.position.longitude);

      //gets a set of coordinates between 2 markers
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDHP-Fy593557yNJxow0ZbuyTDd2kJhyCY",
        marker1,
        marker2,
        travelMode: TravelMode.bicycling,
      );

      //drawing route to bike stations
      late List<LatLng> nPoints = [];
      double stuff = 0;
      for (var point in result.points) {
        nPoints.add(LatLng(point.latitude, point.longitude));
        stuff = point.latitude + point.longitude;
      }

      //adds stuff to polyline
      //if its a cycle path line is red otherwise line is blue
      if (i == 1 || i == widget._markers.length - 1){
        widget._polyline.add(
          Polyline(
            polylineId: PolylineId(stuff.toString()),
            points: nPoints,
            color: Colors.red
          )
        );
      }
      else{
        widget._polyline.add(
          Polyline(
            polylineId: PolylineId(stuff.toString()),
            points: nPoints,
            color: Colors.blue
          )
        );
      }
    }
    setState(() {
    });
  }

    Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await widget._mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
              place.geometry.location.lat, place.geometry.location.lng
          ),
          zoom: 14.0,
        ),
      ),
    );
  }
}
