// // import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:trekking_guide/utils/custom_colors.dart';
// import 'package:trekking_guide/utils/size_utils.dart';
// import 'package:trekking_guide/utils/text_styles.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   int index = 0;
//   List<String> imageList = [
//     'assets/annapurna_trek.jpg',
//     'assets/sagarmatha.jpg',
//     'assets/mardi.jpg'
//   ];
//   int index2 = 0;
//   List<String> imageList2 = [
//     'assets/annapurna_trek.jpg',
//     'assets/sagarmatha.jpg',
//     'assets/mardi.jpg'
//   ];

//   final controller = CarouselController();

//   List<String> placeName = ['Pokhara', 'kathmandu', 'Mustang'];
//   List<String> trekName = [
//     'Annapurna Base Camp',
//     'Sagarmatha Base Camp',
//     'Mardi Himal'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Maps",
//           style: Styles.textBlack30B,
//           textAlign: TextAlign.justify,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: getVerticalSize(250),
//               ),
//               Icon(Icons.map,
//                   size: getSize(200),
//                   color: CustomColors.primaryColor.withOpacity(0.7)),
//               Text(
//                 "Maps and locaton here",
//                 style: TextStyle(
//                     fontSize: getSize(20), color: CustomColors.primaryColor),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:html';

import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates().then((_) => {
          getPolyLinePoints()
              .then((coordinates) => {generatePolyLinefromPoints(coordinates)})
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: Text('Loading...'),
            )
          :SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                onMapCreated: ((GoogleMapController controller) =>
                    _mapController.complete(controller)),
                initialCameraPosition:
                    const CameraPosition(target: _boudhaPlex, zoom: 13),
                markers: {
                  Marker(
                      markerId: MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _currentP!),
                  const Marker(
                      markerId: MarkerId("_sourceLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _boudhaPlex),
                  const Marker(
                      markerId: MarkerId("_destinationLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _swyambhuPlex)
                },
                polylines: Set<Polyline>.of(polylines.values),
              ),
            ),
    );
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

  // to show a polyline(connecting lines between source and destination location)
  Future<List<LatLng>> getPolyLinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'Google_API_Key',
        PointLatLng(_boudhaPlex.latitude, _boudhaPlex.longitude),
        PointLatLng(
          _swyambhuPlex.latitude,
          _swyambhuPlex.longitude,
        ),
        travelMode:
            TravelMode.driving); //you can change it to walking , bicycle etc
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  // to show connecting lines between the locations
  void generatePolyLinefromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 6);
    setState(() {
      polylines[id] = polyline;
    });
  }
}

