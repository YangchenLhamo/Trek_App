import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trekking_guide/pages/map/placeprediction.dart';
import 'package:trekking_guide/pages/map/search_services.dart';
import 'package:trekking_guide/utils/size_utils.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? mapController;
  LatLng? _pickedLocation;
  LatLng? _currentP;
  Marker _userLocationMarker = const Marker(
    markerId: MarkerId('userLocation'),
  );
  List<PlacePrediction> _placePredictions = [];

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width:  MediaQuery.of(context).size.height,
            child: GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              initialCameraPosition: const CameraPosition(
                zoom: 12,
                target: LatLng(27.7056, 85.3343),
              ),
              polylines: _searchController.text ==
                      '''Boudha Stupa (Khasti Chaitya), Kathmandu, Nepal'''
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
                          LatLng(27.7056, 85.3343),
                          LatLng(27.70564965199908, 85.33431116491556),
                          LatLng(27.705770761010275, 85.33463805913925),
                          LatLng(27.707950997053224, 85.336730517447),
                          LatLng(27.708019564695892, 85.34318659454584),
                          LatLng(27.71716064066452, 85.3465510904789),
                          LatLng(27.723640880911763, 85.35606790333986),
                          LatLng(27.7213, 85.3575),
                          LatLng(27.7215, 85.3620),
                        ],
                      ),
                    }
                  : _searchController.text ==
                          '''Swoyambhu Mahachaitya, BHAGANPAU, Nepal'''
                      ? {
                          Polyline(
                            polylineId: const PolylineId('2'),
                            color: Colors.blue,
                            width: 5,
                            patterns: [
                              PatternItem.dash(10),
                              PatternItem.gap(2),
                            ],
                            points: const [
                              LatLng(27.7056, 85.3343),
                              LatLng(27.708173, 85.333382),
                              LatLng(27.709949, 85.326257),
                              LatLng(27.710300, 85.322202),
                              LatLng(27.710672, 85.321992),
                              LatLng(27.713703, 85.322006),
                              LatLng(27.713684, 85.319667),
                              LatLng(27.713285, 85.317875),
                              LatLng(27.713798, 85.315493),
                              LatLng(27.716842, 85.316028),
                              LatLng(27.718185, 85.311806),
                              LatLng(27.718118, 85.310004),
                              LatLng(27.718959, 85.309605),
                              LatLng(27.716731, 85.304178),
                              LatLng(27.713814, 85.303241),
                              LatLng(27.713669, 85.301148),
                              LatLng(27.712568, 85.300558),
                              LatLng(27.712653, 85.300118),
                              LatLng(27.713609, 85.299668),
                              LatLng(27.713733, 85.296792),
                              LatLng(27.713761, 85.296782),
                              LatLng(27.714140, 85.296352),
                              LatLng(27.714304, 85.293560),
                              LatLng(27.714335, 85.293412),
                              LatLng(27.7149, 85.2904),
                            ],
                          ),
                        }
                      : {},
              markers: {
                _userLocationMarker,
                const Marker(
                  markerId: MarkerId("temple"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(27.7056, 85.3343),
                ),
                if (_pickedLocation != null)
                  Marker(
                    markerId: const MarkerId("pickedLocation"),
                    position: _pickedLocation!,
                    icon: BitmapDescriptor.defaultMarker,
                  ),
              },
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(getHorizontalSize(15),
                      getVerticalSize(25), getHorizontalSize(15), 0),
                  child: Container(
                    // height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _fetchPlacePredictions(value);
                        } else {
                          setState(() {
                            _pickedLocation = null;
                            _placePredictions.clear();
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for a place',
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                if (_placePredictions.isNotEmpty)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      itemCount: _placePredictions.length,
                      itemBuilder: (context, index) {
                        final prediction = _placePredictions[index];
                        return ListTile(
                          title: Text(prediction.description),
                          onTap: () {
                            _searchController.text = prediction.description;
                            _onPredictionSelected(prediction);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// to request user location
  void _requestPermission() async {
    var serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    var permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void _getUserLocation() async {
    try {
      var location = await _locationController.getLocation();
      setState(() {
        _currentP = LatLng(location.latitude!, location.longitude!);
        _userLocationMarker = Marker(
          markerId: const MarkerId("userLocation"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: _currentP!,
        );
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _fetchPlacePredictions(String input) async {
    final placePredictions = await fetchPlacePredictions(input);
    setState(() {
      _placePredictions = placePredictions;
    });
  }

  void _onPredictionSelected(PlacePrediction prediction) async {
    await onPredictionSelected(prediction, (pickedLocation) {
      setState(() {
        _pickedLocation = pickedLocation;
        _placePredictions
            .clear(); // Clear predictions when location is selected
      });
      mapController?.animateCamera(
        CameraUpdate.newLatLng(_pickedLocation!),
      );
    });
  }
}
