import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/presentation/bloc/blocs.dart';

class MapView extends StatelessWidget {

  final LatLng initialLocation;
  final Set<Polyline> polylines;

  const MapView({super.key, required this.initialLocation, required this.polylines});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final mapBloc = context.read<MapBloc>();

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerMove: (event) => mapBloc.add(StopFollowUserEvent()),
        child: GoogleMap(
                mapType: MapType.normal ,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: initialLocation,
                  zoom: 15
                ),
                polylines: polylines,
        
                onMapCreated: (controller) => mapBloc.add(MapInitializedEvent(controller: controller)),
        
                // TODO: Markers
        
                
        
              ),
      ),
    );
  }
}