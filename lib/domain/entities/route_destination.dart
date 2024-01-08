// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_app/infrastructure/models/models.dart';

class RouteDestination {

  final List<LatLng> points;
  final double duration;
  final double distance;
  final Feature? endPlace;

  RouteDestination({
    required this.points, 
    required this.duration, 
    required this.distance,
    this.endPlace
  });


  RouteDestination copyWith({
    List<LatLng>? points,
    double? duration,
    double? distance,
    Feature? endPlace,
  }) {
    return RouteDestination(
      points: points ?? this.points,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      endPlace: endPlace ?? this.endPlace,
    );
  }
}
