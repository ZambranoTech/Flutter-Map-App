part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class MapInitializedEvent extends MapEvent {
  final GoogleMapController controller;
  const MapInitializedEvent({required this.controller});
}

class FollowUserEvent extends MapEvent {}
class StopFollowUserEvent extends MapEvent {}
class OnToggleUserRoute extends MapEvent {}

class UpdateUserPolylineEvent extends MapEvent {
  final List<LatLng> userLocations;
  const UpdateUserPolylineEvent({required this.userLocations});
}

class DisplayPolulinesEvent extends MapEvent {
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  const DisplayPolulinesEvent({
    required this.polylines,
    required this.markers
  });
}