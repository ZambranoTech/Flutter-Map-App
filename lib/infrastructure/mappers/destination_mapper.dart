
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:maps_app/domain/entities/entities.dart';
import 'package:maps_app/infrastructure/models/traffic_mapbox_response.dart';

class DestinationMapper {

  static RouteDestination trafficMapBoxToRouteDestination(TrafficResponse trafficResponse) {

    final geometry = trafficResponse.routes.first.geometry;

    //Decodificar
    final points = decodePolyline(geometry, accuracyExponent: 6);

    final latLngList = points.map((coor) => LatLng(coor[0].toDouble(), coor[1].toDouble())).toList();

    return RouteDestination(
      points: latLngList, 
      duration: trafficResponse.routes.first.duration, 
      distance: trafficResponse.routes.first.distance
    );
  }

}