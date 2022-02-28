import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  Directions(
      {required this.bounds,
      required this.polylinePoints,
      required this.totalDistance,
      required this.totalDuration});

  factory Directions.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json['routes'][0]);
    print(data);
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];

    // Boundes
    final bounds = LatLngBounds(
      southwest: LatLng(json['bounds']['southwest']['lat'],
          json['bounds']['southwest']['lng']),
      northeast: LatLng(json['bounds']['northeast']['lat'],
          json['bounds']['northeast']['lng']),
    );

    // Distance & Duration
    String distance = "";
    String duration = "";
    if ((data['legs'] as List).isNotEmpty) {
      distance = data['legs'][0]['distance']['text'];
      duration = data['legs'][0]['duration']['text'];
    }

    return Directions(
      bounds: bounds,
      polylinePoints:
          PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}
