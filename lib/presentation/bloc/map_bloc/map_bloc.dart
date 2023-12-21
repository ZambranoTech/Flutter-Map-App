import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/config/theme/themes.dart';
import 'package:maps_app/presentation/bloc/blocs.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  late StreamSubscription<LocationState> locationStreamSubscription;

  MapBloc(this.locationBloc) : super(const MapState()) {
    on<MapInitializedEvent>(_onInitMap);
    on<FollowUserEvent>(_onFollowUser);
    on<StopFollowUserEvent>(_stopFollowUserEvent);
    on<UpdateUserPolylineEvent>(_updateUserPolylineEvent);
    on<OnToggleUserRoute>(_onToggleUserRoute);



    locationStreamSubscription = locationBloc.stream.listen((locationState) {

      if (locationState.lastKnownLocation == null) return;
      add(UpdateUserPolylineEvent(userLocations: locationState.myLocationHistory));

      if (locationState.lastKnownLocation == null || !state.isFollowingUser) return;

      moveCamera(locationState.lastKnownLocation!);

    });

  }

  @override
  Future<void> close() {
    locationStreamSubscription.cancel();
    return super.close();
  }

  void _onToggleUserRoute(OnToggleUserRoute event, Emitter<MapState> emit) {
    emit(
      state.copyWith(
        showMyRoute: !state.showMyRoute
      )
    );
  }

  void _updateUserPolylineEvent(UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
      polylineId: const PolylineId('myRoute'),
      color: Colors.black,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.userLocations
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;

    emit(
      state.copyWith(
        polylines: currentPolylines
      )
    );
  }

  void _onFollowUser(FollowUserEvent event, Emitter<MapState> emit) {
    emit(
      state.copyWith(
        isFollowingUser: !state.isFollowingUser
      )
    );
    if (state.isFollowingUser && locationBloc.state.lastKnownLocation != null){
      moveCamera(locationBloc.state.lastKnownLocation!);
    }
  } 

  void _stopFollowUserEvent(StopFollowUserEvent event, Emitter<MapState> emit) {
    emit(
      state.copyWith(
        isFollowingUser: false
      )
    );
  } 

  void _onInitMap(MapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;

    _mapController!.setMapStyle(jsonEncode(uberMapTheme));

    emit(
      state.copyWith(
        isMapInitialized: true
      )
    );
  }

  void moveCamera( LatLng newLocation ) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

}
