part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class NewUserLocationEvent extends LocationEvent {
  final LatLng newLocation;
  const NewUserLocationEvent(this.newLocation);
}

class StartFollowingUser extends LocationEvent {}
class StopFollowingUser extends LocationEvent {}