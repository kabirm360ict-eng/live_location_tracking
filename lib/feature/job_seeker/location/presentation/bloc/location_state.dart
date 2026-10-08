part of 'location_bloc.dart';

sealed class LocationState {}

final class LocationInitial extends LocationState {}

//for suggestion
final class LocationSuggestionsSuccessState extends LocationState {
  final List<PredictionListResponseModel> suggestions;
  LocationSuggestionsSuccessState({required this.suggestions});
}

final class LocationSuggestionsFailureState extends LocationState {
  final String message;
  LocationSuggestionsFailureState({required this.message});
}

final class LocationSuggestionsLoadingState extends LocationState {}

//for place details
final class LocationPlaceDetailsSuccessState extends LocationState {
  final FullAddress placeDetails;
  LocationPlaceDetailsSuccessState({required this.placeDetails});
}

final class LocationPlaceDetailsFailureState extends LocationState {
  final String message;
  LocationPlaceDetailsFailureState({required this.message});
}

final class LocationPlaceDetailsLoadingState extends LocationState {}
