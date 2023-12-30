import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/presentation/bloc/blocs.dart';
import 'package:maps_app/presentation/views/views.dart';
import 'package:maps_app/shared/widgets/btn_toggle_user_route.dart';
import 'package:maps_app/shared/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;

  @override
  void initState() {
    super.initState();
    locationBloc = context.read<LocationBloc>();

    locationBloc.getCurrentPosition();
    locationBloc.startFollowingUser();
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final mapBloc = context.watch<MapBloc>();

    Map<String, Polyline> polylines = Map.from(mapBloc.state.polylines);

    if (!mapBloc.state.showMyRoute) {
      polylines.removeWhere((key, value) => key == 'myRoute');
    }

    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          return state.lastKnownLocation == null
              ? const Center(
                  child: Text('Espere por favor'),
                )
              : SingleChildScrollView(
                  child: Stack(
                    children: [
                      MapView(
                        initialLocation: state.lastKnownLocation!,
                        polylines: polylines.values.toSet(),
                        markers: mapBloc.state.markers.values.toSet(),
                      ),
                      CustomSearchBar(),
                      ManualMarker(),

                      

                      //TODO: botones...
                    ],
                  ),
                );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BtnToggleUserRoute(),
          BtnFollowingUser(),
          BtnCurrentLocation(),
          
        ],
        
      ),
    );
  }
}
