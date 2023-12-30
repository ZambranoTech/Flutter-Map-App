import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/infrastructure/models/models.dart';
import 'package:maps_app/infrastructure/models/traffic_mapbox_response.dart';

class TrafficService {

  static String accessToken = 'pk.eyJ1IjoiemFtYnJhbm90ZWNoIiwiYSI6ImNscWZhejkwYzBvY2Uybm80cmE5M2FwMWUifQ.2gGA5rcD8fQVPkj05yl1Bw';

  final _dioTraffic = Dio(
    BaseOptions(
      baseUrl: 'https://api.mapbox.com/directions/v5/mapbox',
      queryParameters: {
        'alternatives' : true,
        'geometries' : 'polyline6',
        'overview' : 'full',
        'steps' : false,
        'access_token' : accessToken,
      }
    )
  );

  final _dioPlaces = Dio(
      BaseOptions(
        baseUrl: 'https://api.mapbox.com/geocoding/v5/mapbox.places',
        queryParameters: {
          'liity': 7,
          'language': 'es',
          'access_token': accessToken,
        }
      )
  );

  Future<TrafficResponse> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final coorsString = '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';

    final response = await _dioTraffic.get('/driving/$coorsString');

    final data = TrafficResponse.fromJson(response.data);

    return data;
  }

  Future<List<Feature>> getResultByQuery( LatLng proximity, String query ) async {

    if ( query.isEmpty ) return [];

    final response = await _dioPlaces.get('/$query.json', 
      queryParameters: {
        'proximity': '${proximity.longitude},${proximity.latitude}'
      }
    );
    final placesResponse = PlacesResponse.fromJson(response.data);

    return placesResponse.features;

  }

}