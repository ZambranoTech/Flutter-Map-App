import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {

  StreamSubscription? positionStream;

  LocationBloc() : super(LocationState()) {
    on<NewUserLocationEvent>(_newUserLocation); 
    on<StartFollowingUser>(_startFollowingUser); 
    on<StopFollowingUser>(_stopFollowingUser); 
    
  }

  Future getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    print('Position: $position');
    // TODO: retornar un objeto de LatLong
  }

  _newUserLocation(NewUserLocationEvent event, Emitter<LocationState> emit ) {
    emit(
      state.copyWith(
        lastKnownLocation: event.newLocation,
        myLocationHistory: [...state.myLocationHistory, event.newLocation]
      )
    );
  }

  _startFollowingUser(StartFollowingUser event, Emitter<LocationState> emit ) {
    emit(
      state.copyWith(
        followingUser: true, 
      )
    );
  }

  _stopFollowingUser(StopFollowingUser event, Emitter<LocationState> emit ) {
    emit(
      state.copyWith(
        followingUser: false, 
      )
    );
  }

  void startFollowingUser() {
    add(StartFollowingUser());
    positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;
      add(NewUserLocationEvent(LatLng(position.latitude, position.longitude)));
    });
  }

  void stopFollowingUser() {
    add(StopFollowingUser());
    positionStream?.cancel();
  }

  @override
  Future<void> close() {
    positionStream?.cancel();
    return super.close();
  }

}
