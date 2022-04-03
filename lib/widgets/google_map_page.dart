import 'package:cycle_planner/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:cycle_planner/widgets/search_bar.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'package:provider/provider.dart';


class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({
    Key? key,
    required Completer<GoogleMapController> mapController,
    required this.applicationProcesses, 
  }) : _mapController = mapController, super(key: key);

  final Completer<GoogleMapController> _mapController;
  final ApplicationProcesses applicationProcesses;
  

  @override
  State<GoogleMapPage> createState() => _MapPageState();
}

class _MapPageState extends State<GoogleMapPage> {
  late StreamSubscription locationSubscription;
  late StreamSubscription boundsSubscription;
  final LatLng _center = const LatLng(51.509865, -0.118092);

  @override
  void initState() {
    final applicationProcesses = Provider.of<ApplicationProcesses>(context,listen: false);
      locationSubscription = applicationProcesses.selectedLocation.stream.listen((place) {
        _goToPlace(place);
      }
    );
    applicationProcesses.bounds.stream.listen((bounds) async {
      final GoogleMapController controller = await widget._mapController.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    });
    super.initState();
  }

  @override
  void dispose() {
    final applicationProcesses = Provider.of<ApplicationProcesses>(context, listen:false);
    applicationProcesses.dispose();
    locationSubscription.cancel();
    boundsSubscription.cancel();
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
            polylines: widget.applicationProcesses.polylines,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: widget.applicationProcesses.currentLocation != null ? LatLng(
                widget.applicationProcesses.currentLocation!.latitude, 
                widget.applicationProcesses.currentLocation!.longitude,
              )
              : _center,
              zoom: 11.0,
            ),
            markers: (widget.applicationProcesses.publicBikeStations.isNotEmpty) ? Set<Marker>.of(widget.applicationProcesses.publicBikeStations)
            :Set<Marker>.of(widget.applicationProcesses.markers),
            //onTap: _handleTap,
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

  // _handleTap(LatLng tappedPoint){
  //   print(tappedPoint);
  //   setState(() {
  //     myMarker = [];
  //     myMarker.add(
  //         Marker(
  //           markerId: MarkerId(tappedPoint.toString()),
  //           position: tappedPoint,
  //           draggable: true,
  //           onDragEnd: (dragEndPosition){
  //             print(dragEndPosition);
  //           }
  //         )
  //     );
  //   });
  // }

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
