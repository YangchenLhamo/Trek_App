// import 'dart:html';

// import 'dart:async';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _boudhaPlex = LatLng(27.7213, 85.3575);
  static const LatLng _swyambhuPlex = LatLng(27.7192, 85.2955);
  LatLng? _currentP = null;

  // Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    // getLocationUpdates().then((_) => {
    //       getPolyLinePoints()
    //           .then((coordinates) => {generatePolyLinefromPoints(coordinates)})
    //     });
  }

  GoogleMapController? mapController;
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              zoom: 12,
              target: LatLng(
                27.7172,
                85.3240,
              ),
            ),
            markers: {
              Marker(
                markerId: MarkerId("_currentLocation"),
                icon: BitmapDescriptor.defaultMarker,
                position: _currentP ??
                    LatLng(
                        0, 0), // Provide a default LatLng if _currentP is null
              ),
              const Marker(
                  markerId: MarkerId("_sourceLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _boudhaPlex),
              const Marker(
                  markerId: MarkerId("_destinationLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _swyambhuPlex),
              Marker(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: StatefulBuilder(
                            builder: (BuildContext context, setState1) {
                              void _onMapCreated(
                                  GoogleMapController controller) {
                                mapController = controller;
                              }

                              void _onMapTapped(LatLng location) {
                                setState(() {});
                                setState1(() {
                                  _pickedLocation = location;
                                });
                              }

                              return Container(
                                height: 300,
                                width: 300,
                                color: Colors.white,
                                child: GoogleMap(
                                  initialCameraPosition: const CameraPosition(
                                    zoom: 12,
                                    target: LatLng(
                                      27.7172,
                                      85.3240,
                                    ),
                                  ),
                                  onMapCreated: _onMapCreated,
                                  onTap: _onMapTapped,
                                  markers: _pickedLocation == null
                                      ? {}
                                      : {
                                          Marker(
                                            markerId:
                                                MarkerId('picked-location'),
                                            position: _pickedLocation ??
                                                LatLng(0.0, 0.0),
                                          ),
                                        },
                                ),
                              );
                            },
                          ),
                        );
                      });
                },
                position: const LatLng(
                  27.7172,
                  85.3240,
                ),
                markerId: const MarkerId(
                  "value",
                ),
              ),
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 20),
            child: Text(_pickedLocation.toString()),
          ),
        ],
      ),

      // Center(
      //   child: Text("Loading........."),
      // ),
    );

    //   return Scaffold(
    //     body: _currentP == null
    //         ? const Center(
    //             child: Text('Loading...'),
    //           )
    //         :SizedBox(
    //             height: MediaQuery.of(context).size.height,
    //             width: MediaQuery.of(context).size.width,
    //             child: GoogleMap(
    //               onMapCreated: ((GoogleMapController controller) =>
    //                   _mapController.complete(controller)),
    //               initialCameraPosition:
    //                   const CameraPosition(target: _boudhaPlex, zoom: 13),
    //               markers: {
    //                 Marker(
    //                     markerId: MarkerId("_currentLocation"),
    //                     icon: BitmapDescriptor.defaultMarker,
    //                     position: _currentP!),
    //                 const Marker(
    //                     markerId: MarkerId("_sourceLocation"),
    //                     icon: BitmapDescriptor.defaultMarker,
    //                     position: _boudhaPlex),
    //                 const Marker(
    //                     markerId: MarkerId("_destinationLocation"),
    //                     icon: BitmapDescriptor.defaultMarker,
    //                     position: _swyambhuPlex)
    //               },
    //               polylines: Set<Polyline>.of(polylines.values),
    //             ),
    //           ),
    //   );
    // }

    // // to point the camera positon to specific position of the user
    // Future<void> _cameraToPosition(LatLng pos) async {
    //   final GoogleMapController controller = await _mapController.future;
    //   CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);
    //   await controller
    //       .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
    // }

    // // to ask for user's location
    // Future<void> getLocationUpdates() async {
    //   // flag to show that user has enter their location
    //   bool _serviceEnabled;
    //   PermissionStatus _permissionGranted;
    //   _serviceEnabled = await _locationController.serviceEnabled();
    //   if (_serviceEnabled) {
    //     _serviceEnabled = await _locationController.serviceEnabled();
    //   } else {
    //     return;
    //   }

    //   // ask permission to use/access the serivce(user's location)
    //   _permissionGranted = await _locationController.hasPermission();
    //   if (_permissionGranted == PermissionStatus.denied) {
    //     // this create a prompt telling user to allow permission access
    //     _permissionGranted = await _locationController.requestPermission();
    //     // if not then return or leave
    //     if (_permissionGranted != PermissionStatus.granted) {
    //       return;
    //     }
    //   }
    //   // when we have the access to this
    //   _locationController.onLocationChanged
    //       .listen((LocationData currentLocation) {
    //     if (currentLocation.latitude != null &&
    //         currentLocation.longitude != null) {
    //       // update entire map with reference to the user's location (_currentP)
    //       setState(() {
    //         _currentP =
    //             LatLng(currentLocation.latitude!, currentLocation.longitude!);
    //         _cameraToPosition(_currentP!);
    //       });
    //     }
    //   });
    // }

    // // to show a polyline(connecting lines between source and destination location)
    // Future<List<LatLng>> getPolyLinePoints() async {
    //   List<LatLng> polylineCoordinates = [];
    //   PolylinePoints polylinePoints = PolylinePoints();
    //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //       'Google_API_Key',
    //       PointLatLng(_boudhaPlex.latitude, _boudhaPlex.longitude),
    //       PointLatLng(
    //         _swyambhuPlex.latitude,
    //         _swyambhuPlex.longitude,
    //       ),
    //       travelMode:
    //           TravelMode.driving); //you can change it to walking , bicycle etc
    //   if (result.points.isNotEmpty) {
    //     result.points.forEach((PointLatLng point) {
    //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //     });
    //   } else {
    //     print(result.errorMessage);
    //   }
    //   return polylineCoordinates;
    // }

    // // to show connecting lines between the locations
    // void generatePolyLinefromPoints(List<LatLng> polylineCoordinates) async {
    //   PolylineId id = const PolylineId('poly');
    //   Polyline polyline = Polyline(
    //       polylineId: id,
    //       color: Colors.blue,
    //       points: polylineCoordinates,
    //       width: 6);
    //   setState(() {
    //     polylines[id] = polyline;
    //   });
  }

  // to point the camera positon to specific position of the user
  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  // to ask for user's location
  Future<void> getLocationUpdates() async {
    // flag to show that user has enter their location
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.serviceEnabled();
    } else {
      return;
    }

    // ask permission to use/access the serivce(user's location)
    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      // this create a prompt telling user to allow permission access
      _permissionGranted = await _locationController.requestPermission();
      // if not then return or leave
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    // when we have the access to this
    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        // update entire map with reference to the user's location (_currentP)
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP!);
        });
      }
    });
  }
}
