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

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  // static const LatLng _boudhaPlex = LatLng(27.7213, 85.3575);
  // static const LatLng _swyambhuPlex = LatLng(27.7192, 85.2955);
  LatLng? _currentP = null;
  TextEditingController _searchController = TextEditingController();
  Marker _markers = const Marker(
    markerId: MarkerId('12'),
  );

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _getUserLocation();
  }

  GoogleMapController? mapController;
  LatLng? _pickedLocation;

  void searchPlace(String query) async {
    final apiKey = Google_API_Key;
    final placesApiUrl =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';

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
        mapController?.animateCamera(
          CameraUpdate.newLatLng(_markers.position),
        );
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
              target: LatLng(27.7056, 85.3343),
            ),
            polylines: _searchController.text == 'boudha'
                ? {
                    Polyline(
                      polylineId: const PolylineId('1'),
                      color: Colors.blue,
                      width: 5,
                      patterns: [
                        PatternItem.dash(10),
                        PatternItem.gap(2),
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
              const Marker(
                markerId: MarkerId("temple"),
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(27.7056, 85.3343),
              ),
              if (_currentP != null)
                Marker(
                  markerId: MarkerId("userLocation"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                  position: _currentP!,
                ),
            },
          ),
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
    );
  }

// request for user location
  void _requestPermission() async {
    var _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }


// condition when permission is given
    var _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

// get current location
  void _getUserLocation() async {
    try {
      var location = await _locationController.getLocation();
      setState(() {
        _currentP = LatLng(location.latitude!, location.longitude!);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }
}
