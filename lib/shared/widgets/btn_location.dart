import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/presentation/bloc/blocs.dart';
import 'package:maps_app/presentation/bloc/location_bloc/location_bloc.dart';

class BtnCurrentLocation extends StatelessWidget {
  const BtnCurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {

    final locationBloc = context.read<LocationBloc>();
    final mapBloc = context.watch<MapBloc>();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.white,
        child: IconButton(
          onPressed: () {
            final userLocation = locationBloc.state.lastKnownLocation;
            if (userLocation == null) return;

            mapBloc.moveCamera(userLocation);
          }, 
          icon: Icon(Icons.my_location_outlined, color: Colors.black,)
        ),
      ),
    );
  }
}