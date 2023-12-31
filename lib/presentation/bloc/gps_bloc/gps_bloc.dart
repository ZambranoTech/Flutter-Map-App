import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {

  StreamSubscription? gpsServiceSubscription;

  GpsBloc() : super(const GpsState()) {
    on<GpsAndPermissionEvent>(_gpsAndPermissionEvent);

    _init();
  }

  void _gpsAndPermissionEvent(GpsAndPermissionEvent event, Emitter<GpsState> emit) {
    emit(state.copyWith(
      isGpsEnable: event.isGpsEnabled,
      isGpsPermissionGranted: event.isGpsPermissionGranted
    ));
  }

  Future<void> _init() async {

    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _isPermissionGranted()
    ]);

    add(GpsAndPermissionEvent(
      isGpsEnabled: gpsInitStatus[0],
      isGpsPermissionGranted: gpsInitStatus[1],
    ));
  }

  Future<bool> _checkGpsStatus() async {

    final isEnable = await Geolocator.isLocationServiceEnabled();

    gpsServiceSubscription = Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = (event.index == 1) ? true : false;
      add(GpsAndPermissionEvent(
        isGpsEnabled: isEnabled,
        isGpsPermissionGranted: state.isGpsPermissionGranted,
      ));
    });

    return isEnable;

  }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();

    switch ( status ) {
      
      case PermissionStatus.granted:
        add(GpsAndPermissionEvent(isGpsEnabled: state.isGpsEnable, isGpsPermissionGranted: true));
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.provisional:
        add(GpsAndPermissionEvent(isGpsEnabled: state.isGpsEnable, isGpsPermissionGranted: false));
        openAppSettings();

    }
  }

  Future<bool> _isPermissionGranted() {
    final isGranted = Permission.location.isGranted;
    return isGranted;
  }

  @override
  Future<void> close() {
    gpsServiceSubscription?.cancel();
    return super.close();
  }

}


