part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class ActivateManualMarker extends SearchEvent {}
class DesactivateManualMarker extends SearchEvent {}

class OnNewPlacesFoundEvent extends SearchEvent {
  final List<Feature> places;
  const OnNewPlacesFoundEvent({required this.places});
}

class OnNewPlaceFoundEvent extends SearchEvent {
  final Feature place;
  const OnNewPlaceFoundEvent({required this.place});
}
