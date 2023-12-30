import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/config/helpers/show_loading_message.dart';
import 'package:maps_app/domain/entities/entities.dart';
import 'package:maps_app/presentation/bloc/blocs.dart';
import 'package:maps_app/presentation/delegates/delegates.dart';
import 'package:maps_app/shared/services/traffic_service.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker 
        ? const SizedBox()
        : const _CustomSearchBarBody();
      }, 
    );
  }
}


class _CustomSearchBarBody extends StatelessWidget {
  const _CustomSearchBarBody();

  void onSearchResults(BuildContext context, SearchResult result) async {

    final searchBloc = context.read<SearchBloc>(); 
    final mapBloc = context.read<MapBloc>(); 
    final locationBloc = context.read<LocationBloc>(); 

    if (result.manual) {
      searchBloc.add(ActivateManualMarker());
      return;
    }

    if (result.position != null && locationBloc.state.lastKnownLocation != null) {
      final destination = await searchBloc.getCoorsStartToEnd( locationBloc.state.lastKnownLocation!,  result.position!);
      
      final routeDestination = RouteDestination(points: destination.points, duration: destination.duration, distance: destination.distance);
      
      if (context.mounted) showLoadingMessage(context);

      mapBloc.drawRoutePolyline(routeDestination).then((value) => Navigator.pop(context));
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 300),
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 50),
          width: double.infinity,
       
          child: GestureDetector(
            onTap: () async {
              await showSearch(context: context, delegate: SearchDestinationDelegate()).then(
                (result) {
                  if ( result == null ) return;
      
                  onSearchResults(context, result);
                }
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5)
                  )
                ]
              ),
              child: const Text('¿Dónde quieres ir?', style: TextStyle(color: Colors.black87),),
            ),
          ),
        ),
      ),
    );
  }
}