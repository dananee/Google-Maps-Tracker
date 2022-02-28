import 'package:dio/dio.dart';
import 'package:map_app/.env.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'directions_models.dart';

class DirectionData {
  static const String baseurl =
      "https://maps.googleapis.com/maps/api/directions/json?";

  // DirectionData(Dio dio) : _dio = dio;

  Future<Directions> directionData({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await Dio().get(baseurl, queryParameters: {
      "origin": '${origin.latitude},${origin.longitude}',
      "destination": '${destination.latitude},${destination.longitude}',
      'key': googleApiKey,
    });

    if (response.statusCode == 200) {
      print('RESPONSE: ' + response.data.toString());
      return Directions.fromJson(response.data);
    } else {
      throw Exception('Failed to load direction data');
    }
  }
}
