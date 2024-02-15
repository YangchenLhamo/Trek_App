

// // import 'dart:html';

// import 'dart:async';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   Location _locationController = new Location();

//   final Completer<GoogleMapController> _mapController =
//       Completer<GoogleMapController>();

//   static const LatLng _boudhaPlex = LatLng(27.7213, 85.3575);
//   static const LatLng _swyambhuPlex = LatLng(27.7192, 85.2955);
//   LatLng? _currentP = null;

//   Map<PolylineId, Polyline> polylines = {};

//   @override
//   void initState() {
//     super.initState();
//     getLocationUpdates().then((_) => {
//           getPolyLinePoints()
//               .then((coordinates) => {generatePolyLinefromPoints(coordinates)})
//         });
//   }

  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _currentP == null
//           ? const Center(
//               child: Text('Loading...'),
//             )
//           :SizedBox(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: GoogleMap(
//                 onMapCreated: ((GoogleMapController controller) =>
//                     _mapController.complete(controller)),
//                 initialCameraPosition:
//                     const CameraPosition(target: _boudhaPlex, zoom: 13),
//                 markers: {
//                   Marker(
//                       markerId: MarkerId("_currentLocation"),
//                       icon: BitmapDescriptor.defaultMarker,
//                       position: _currentP!),
//                   const Marker(
//                       markerId: MarkerId("_sourceLocation"),
//                       icon: BitmapDescriptor.defaultMarker,
//                       position: _boudhaPlex),
//                   const Marker(
//                       markerId: MarkerId("_destinationLocation"),
//                       icon: BitmapDescriptor.defaultMarker,
//                       position: _swyambhuPlex)
//                 },
//                 polylines: Set<Polyline>.of(polylines.values),
//               ),
//             ),
//     );
//   }

//   // to point the camera positon to specific position of the user
//   Future<void> _cameraToPosition(LatLng pos) async {
//     final GoogleMapController controller = await _mapController.future;
//     CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);
//     await controller
//         .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
//   }

//   // to ask for user's location
//   Future<void> getLocationUpdates() async {
//     // flag to show that user has enter their location
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//     _serviceEnabled = await _locationController.serviceEnabled();
//     if (_serviceEnabled) {
//       _serviceEnabled = await _locationController.serviceEnabled();
//     } else {
//       return;
//     }

//     // ask permission to use/access the serivce(user's location)
//     _permissionGranted = await _locationController.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       // this create a prompt telling user to allow permission access
//       _permissionGranted = await _locationController.requestPermission();
//       // if not then return or leave
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//     // when we have the access to this
//     _locationController.onLocationChanged
//         .listen((LocationData currentLocation) {
//       if (currentLocation.latitude != null &&
//           currentLocation.longitude != null) {
//         // update entire map with reference to the user's location (_currentP)
//         setState(() {
//           _currentP =
//               LatLng(currentLocation.latitude!, currentLocation.longitude!);
//           _cameraToPosition(_currentP!);
//         });
//       }
//     });
//   }

//   // to show a polyline(connecting lines between source and destination location)
//   Future<List<LatLng>> getPolyLinePoints() async {
//     List<LatLng> polylineCoordinates = [];
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         'Google_API_Key',
//         PointLatLng(_boudhaPlex.latitude, _boudhaPlex.longitude),
//         PointLatLng(
//           _swyambhuPlex.latitude,
//           _swyambhuPlex.longitude,
//         ),
//         travelMode:
//             TravelMode.driving); //you can change it to walking , bicycle etc
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     } else {
//       print(result.errorMessage);
//     }
//     return polylineCoordinates;
//   }

//   // to show connecting lines between the locations
//   void generatePolyLinefromPoints(List<LatLng> polylineCoordinates) async {
//     PolylineId id = const PolylineId('poly');
//     Polyline polyline = Polyline(
//         polylineId: id,
//         color: Colors.blue,
//         points: polylineCoordinates,
//         width: 6);
//     setState(() {
//       polylines[id] = polyline;
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'dart:async';


import'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trekking_guide/pages/map/apikey.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
   List<Marker> markers = [];
   PolylinePoints polylinePoints = PolylinePoints();
   Map<PolylineId, Polyline> polylines = {};
   late GoogleMapController googleMapController;
   final Completer<GoogleMapController> completer = Completer();
     static const LatLng _boudhaPlex = LatLng(27.7213, 85.3575);
  static const LatLng _swyambhuPlex = LatLng(27.7192, 85.2955);

// onMapCreated is a function that takes a mapController and 
// optional parameter called options. The option is used to change // the UI of the map such as rotation gestures, zoom gestures, map // type, etc.The function of mapController is mostly similar to.   // TextEditingController as it is being used to manage the camera  // functions, zoom and animations, etc.
// 2: As mentioned above mapController takes parameters to change  // the functions of the map such as changing position, zoom, etc.
  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    if (!completer.isCompleted) {
      completer.complete(controller);
    }
  }
// Function for adding markers to google map 
// MarkerId should be unique beacuse of define markerId as string of // LatLng(lattitude,longitude), if string of LatLng equals any 
// element of markers List it will be remove
  addMarker(latLng, newSetState) {
    markers.add(
        Marker(
            consumeTapEvents: true,
            markerId: MarkerId(latLng.toString()),
            position: latLng,
// We adding onTap paramater for when click marker, remove from map
            onTap: (){
              markers.removeWhere((element) => element.markerId == MarkerId(latLng.toString()));
// markers length must be greater than 1 because polyline needs two // points
              if(markers.length > 1){
                getDirections(markers,newSetState);
              }
// When we added markers then removed all, this time polylines seems //in map because of we should clear polylines
               else{
                polylines.clear();
              }
// newState parameter of function, we are openin map in alertDialog, // contexts are different in page and alert dialog because of we use // different setState
              newSetState(() {});
            }
        ));
    if(markers.length > 1){
      getDirections(markers,newSetState);
    }

    newSetState(() {});
  }
// This functions gets real road polyline routes
  getDirections(List<Marker> markers,newSetState) async {
    List<LatLng> polylineCoordinates = [];
    List<PolylineWayPoint> polylineWayPoints = [];
    for(var i = 0; i<markers.length;i++){
      polylineWayPoints.add(PolylineWayPoint(location: "${markers[i].position.latitude.toString()},${markers[i].position.longitude.toString()}",stopOver: true));
    }
// result gets little bit late as soon as in video, because package // send http request for getting real road routes
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Google_API_Key, //GoogleMap ApiKey
        PointLatLng(_boudhaPlex.latitude,_boudhaPlex.longitude), //first added marker
        PointLatLng(_swyambhuPlex.latitude, _swyambhuPlex.longitude), //last added marker
// define travel mode driving for real roads 
        travelMode: TravelMode.driving,
// waypoints is markers that between first and last markers        wayPoints: polylineWayPoints 

    ); 
// Sometimes There is no result for example you can put maker to the // ocean, if results not empty adding to polylineCoordinates
if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    newSetState(() {});

    addPolyLine(polylineCoordinates,newSetState);

  }

  addPolyLine(List<LatLng> polylineCoordinates,newSetState) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 4,
    );
    polylines[id] = polyline;

    newSetState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: Container(
            height: 40,
            width: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
            child: Text("Create Route",textAlign: TextAlign.center),
          ),
          onTap: () async {
            await showDialog(
                context: context,
                builder: (context) => StatefulBuilder(builder: (context, newSetState) {
                  return AlertDialog(
                    insetPadding: EdgeInsets.all(10),
                    contentPadding: EdgeInsets.all(5),
                    content: Stack(
                      children: [
                        Container(
                          width: 400,
                          height: 500,
                          child: GoogleMap(
                            mapToolbarEnabled: false,
                            onMapCreated: onMapCreated,
                            polylines: Set<Polyline>.of(polylines.values),
                            initialCameraPosition: const CameraPosition(
                                target: LatLng(38.437532, 27.149606),
                                zoom: 10),
                            markers: markers.toSet(),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            onTap: (newLatLng) async {
                              await addMarker(newLatLng, newSetState);
                              newSetState((){});
                            },
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            setState(() {});
                          },
                          child: Text('Approve Route'),
                        ),
                      ),
                    ],
                  );
                }
                )
            );
          },
        ),
      ),
    );
  }
}
