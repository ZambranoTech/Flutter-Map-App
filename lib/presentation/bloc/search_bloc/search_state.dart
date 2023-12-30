// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_bloc.dart';

class SearchState extends Equatable {

  final bool displayManualMarker;
  final List<Feature> places;
  final List<Feature> history;

  const SearchState({
    this.displayManualMarker = false,
    this.places = const [],
    this.history = const []
  });

  @override
  List<Object?> get props => [ displayManualMarker, places, history ];

 

  SearchState copyWith({
    bool? displayManualMarker,
    List<Feature>? places,
    List<Feature>? history,
  }) {
    return SearchState(
      displayManualMarker: displayManualMarker ?? this.displayManualMarker,
      places: places ?? this.places,
      history: history ?? this.history,
    );
  }
}
