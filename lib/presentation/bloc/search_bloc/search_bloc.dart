import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/domain/entities/entities.dart';
import 'package:maps_app/infrastructure/mappers/destination_mapper.dart';
import 'package:maps_app/infrastructure/models/places_response.dart';
import 'package:maps_app/shared/services/services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {

  TrafficService trafficService;

  SearchBloc({required this.trafficService}) : super(const SearchState()) {
    on<ActivateManualMarker>(_activateManualMarker);
    on<DesactivateManualMarker>(_desactivateManualMarker);
    on<OnNewPlacesFoundEvent>(_onNewPlacesFoundEvent);
    on<OnNewPlaceFoundEvent>(_onNewPlaceFoundEvent);
  }

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final response = await trafficService.getCoorsStartToEnd(start, end);

    return DestinationMapper.trafficMapBoxToRouteDestination(response);
  }

  Future getPlacesByQuery( LatLng proximity, String query ) async {
    final newPlaces = await trafficService.getResultByQuery(proximity, query);

    add(OnNewPlacesFoundEvent(places: newPlaces));
  }

  void _activateManualMarker(ActivateManualMarker event, Emitter<SearchState> emit) {
    emit(
      state.copyWith(
        displayManualMarker: true
      )
    );
  }
  void _desactivateManualMarker(DesactivateManualMarker event, Emitter<SearchState> emit) {
    emit(
      state.copyWith(
        displayManualMarker: false
      )
    );
  }

  void _onNewPlacesFoundEvent(OnNewPlacesFoundEvent event, Emitter<SearchState> emit) {
    emit(
      state.copyWith(
        places: event.places
      )
    );
  }

   void _onNewPlaceFoundEvent(OnNewPlaceFoundEvent event, Emitter<SearchState> emit) {
    emit(
      state.copyWith(
        history: [event.place, ...state.history]
      )
    );
  }




}
