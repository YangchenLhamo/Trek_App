import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trekking_guide/pages/map/apikey.dart';
import 'package:trekking_guide/pages/map/placeprediction.dart';

Future<void> searchPlace(String query, Function(LatLng) onPlaceSelected) async {
  final apiKey = Google_API_Key;
  final placesApiUrl =
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';

  final response = await http.get(Uri.parse(placesApiUrl));
  final responseData = json.decode(response.body);

  if (responseData['results'] != null) {
    final result = responseData['results'][0];
    final pickedLocation = LatLng(
      result['geometry']['location']['lat'],
      result['geometry']['location']['lng'],
    );
    onPlaceSelected(pickedLocation);
  }
}

Future<List<PlacePrediction>> fetchPlacePredictions(String input) async {
  final apiKey = Google_API_Key;
  final placesAutocompleteUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

  final response = await http.get(Uri.parse(placesAutocompleteUrl));
  final responseData = json.decode(response.body);

  List<PlacePrediction> placePredictions = [];
  if (responseData['predictions'] != null) {
    final predictions = responseData['predictions'] as List;
    placePredictions = predictions
        .map((prediction) => PlacePrediction.fromJson(prediction))
        .toList();
  }
  return placePredictions;
}

Future<void> onPredictionSelected(PlacePrediction prediction, Function(LatLng) onPlaceSelected) async {
  final apiKey = Google_API_Key;
  final placeDetailsUrl =
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=${prediction.placeId}&key=$apiKey';

  final response = await http.get(Uri.parse(placeDetailsUrl));
  final responseData = json.decode(response.body);

  if (responseData['result'] != null) {
    final result = responseData['result'];
    final pickedLocation = LatLng(
      result['geometry']['location']['lat'],
      result['geometry']['location']['lng'],
    );
    onPlaceSelected(pickedLocation);
  }
}
