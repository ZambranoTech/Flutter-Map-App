
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/domain/entities/entities.dart';
import 'package:maps_app/presentation/bloc/blocs.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {

  SearchDestinationDelegate() : super(
    searchFieldLabel: 'Buscar...'
  );
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '', 
        icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, SearchResult(cancel: true)), 
      icon: const Icon(Icons.arrow_back_ios)
    );
    
  }

  @override
  Widget buildResults(BuildContext context) {

    final locationBloc = context.read<LocationBloc>();
    final searchBloc = context.read<SearchBloc>();

    if (locationBloc.state.lastKnownLocation == null ) return const SizedBox();

    searchBloc.getPlacesByQuery(locationBloc.state.lastKnownLocation!, query);

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return ListView.separated(
          itemCount: state.places.length,
          itemBuilder: (context, index) {
            final place = state.places[index];
            return ListTile(
              title: Text(place.text),
              subtitle: Text(place.placeName),
              leading: const Icon(Icons.place_outlined,),
              onTap: () {
                searchBloc.add(OnNewPlaceFoundEvent(place: place));
                final result = SearchResult(
                  cancel: false, 
                  manual: false,
                  position: LatLng(place.center[1], place.center[0]),
                  name: place.text,
                  description: place.placeName
                );
                close(context, result);
              },
            );
          }, 
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final searchResult = context.watch<SearchBloc>();

    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.location_on_outlined),
          title: Text('Colocar una ubicación'),
          onTap: () => close(context, SearchResult(cancel: false, manual: true)),
        ),

        ...searchResult.state.history.map(
          (place) => ListTile(
            title: Text(place.text) ,
            subtitle: Text(place.placeName),
            leading: const Icon(Icons.history),
            onTap: () => close(context, SearchResult(cancel: false, manual: false, position: LatLng(place.center[1], place.center[0]))),
          ) 
        )
      ],
    );
  }

}