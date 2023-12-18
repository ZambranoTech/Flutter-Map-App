// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'gps_bloc.dart';

class GpsState extends Equatable {

  final bool isGpsEnable;
  final bool isGpsPermissionGranted;

  bool get isAllGranted => isGpsEnable && isGpsPermissionGranted;

  const GpsState({
    this.isGpsEnable = false, 
    this.isGpsPermissionGranted = false
  });


  @override
  List<Object?> get props => [ isGpsEnable, isGpsPermissionGranted ];


  @override
  bool get stringify => true;

  GpsState copyWith({
    bool? isGpsEnable,
    bool? isGpsPermissionGranted,
  }) {
    return GpsState(
      isGpsEnable: isGpsEnable ?? this.isGpsEnable,
      isGpsPermissionGranted: isGpsPermissionGranted ?? this.isGpsPermissionGranted,
    );
  }
}
