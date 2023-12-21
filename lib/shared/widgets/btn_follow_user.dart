import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/presentation/bloc/blocs.dart';

class BtnFollowingUser extends StatelessWidget {
  const BtnFollowingUser({super.key});

  @override
  Widget build(BuildContext context) {

    final mapBloc = context.watch<MapBloc>();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.white,
        child: IconButton(
          onPressed: () {

            mapBloc.add(FollowUserEvent());

          }, 
          icon:  mapBloc.state.isFollowingUser
          ? const Icon(Icons.directions_run_rounded, color: Colors.black,)
          : const Icon(Icons.hail_rounded, color: Colors.black,)
        ),
      ),
    );
  }
}