// import 'dart:html';

// import 'dart:async';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:trekking_guide/pages/map/apikey.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  static const LatLng _boudhaPlex = LatLng(27.7213, 85.3575);
  static const LatLng _swyambhuPlex = LatLng(27.7192, 85.2955);
  LatLng? _currentP = null;
  TextEditingController _searchController = TextEditingController();
  Marker _markers = Marker(
    markerId: MarkerId('12'),
  );

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

  void searchPlace(String query) async {
    final apiKey = Google_API_Key;
    final placesApiUrl = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';

    final response = await http.get(Uri.parse(placesApiUrl));
    final responseData = json.decode(response.body);

    setState(() {
      if (responseData['results'] != null) {
        for (var result in responseData['results']) {
          _markers = (Marker(
            markerId: MarkerId(result['place_id']),
            position: LatLng(
              result['geometry']['location']['lat'],
              result['geometry']['location']['lng'],
            ),
            infoWindow: InfoWindow(
              title: result['name'],
              snippet: result['formatted_address'],
            ),
          ));
        }

        // Move camera to the first marker's position
        if (_markers != null) {
          mapController?.animateCamera(
            CameraUpdate.newLatLng(_markers.position),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log(_pickedLocation.toString());
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            initialCameraPosition: const CameraPosition(
              zoom: 12,
              target: LatLng(
                27.7172,
                85.3240,
              ),
            ),
            polylines: _searchController.text == 'boudha'
                ? {
                    Polyline(
                      polylineId: const PolylineId('1'),
                      color: Colors.black,
                      width: 4,
                      patterns: [
                        PatternItem.dash(14),
                        PatternItem.gap(7),
                      ],
                      points: const [
                        LatLng(27.7052, 85.3349),
                        LatLng(27.70564965199908, 85.33431116491556),
                        LatLng(27.705770761010275, 85.33463805913925),
                        LatLng(27.707950997053224, 85.336730517447),
                        LatLng(27.708019564695892, 85.34318659454584),
                        LatLng(27.71716064066452, 85.3465510904789),
                        LatLng(27.723640880911763, 85.35606790333986),
                        LatLng(27.7213, 85.3575),
                      ],
                    ),
                  }
                : {},
            markers: {
              _markers,
              // Marker(
              //   markerId: MarkerId("_currentLocation"),
              //   icon: BitmapDescriptor.defaultMarker,
              //   position: _currentP ?? LatLng(0, 0), // Provide a default LatLng if _currentP is null
              // ),
              // const Marker(markerId: MarkerId("_sourceLocation"), icon: BitmapDescriptor.defaultMarker, position: _boudhaPlex),
              const Marker(
                markerId: MarkerId("temple"),
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(27.7052, 85.3349),
              ),
              // const Marker(markerId: MarkerId("_destinationLocation"), icon: BitmapDescriptor.defaultMarker, position: _swyambhuPlex),
              // Marker(
              //   onTap: () {
              //     showDialog(
              //         context: context,
              //         builder: (context) {
              //           return AlertDialog(
              //             content: StatefulBuilder(
              //               builder: (BuildContext context, setState1) {
              //                 void _onMapCreated(GoogleMapController controller) {
              //                   mapController = controller;
              //                 }

              //                 void _onMapTapped(LatLng location) {
              //                   setState(() {});
              //                   setState1(() {
              //                     _pickedLocation = location;
              //                   });
              //                 }

              //                 return Container(
              //                   height: 300,
              //                   width: 300,
              //                   color: Colors.white,
              //                   child: GoogleMap(
              //                     initialCameraPosition: const CameraPosition(
              //                       zoom: 12,
              //                       target: LatLng(
              //                         27.7172,
              //                         85.3240,
              //                       ),
              //                     ),
              //                     onMapCreated: _onMapCreated,
              //                     onTap: _onMapTapped,
              //                     markers: _pickedLocation == null
              //                         ? {}
              //                         : {
              //                             Marker(
              //                               markerId: MarkerId('picked-location'),
              //                               position: _pickedLocation ?? LatLng(0.0, 0.0),
              //                             ),
              //                           },
              //                   ),
              //                 );
              //               },
              //             ),
              //           );
              //         });
              //   },
              //   position: const LatLng(
              //     27.7172,
              //     85.3240,
              //   ),
              //   markerId: const MarkerId(
              //     "value",
              //   ),
              // ),
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 20),
          //   child: Text(_pickedLocation.toString()),
          // ),
          Container(
            height: 50,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
            padding: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a place',
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchPlace(_searchController.text);
                  },
                ),
              ),
            ),
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
    await controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
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
    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        // update entire map with reference to the user's location (_currentP)
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP!);
        });
      }
    });
  }
}
