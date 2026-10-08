part of 'location_bloc.dart';

sealed class LocationEvent {}

final class GetSuggestionListEvent extends LocationEvent {
  final String input;
  GetSuggestionListEvent({required this.input});
}

final class GetPlaceDetailsEvent extends LocationEvent {
  final String placeId, description;
  GetPlaceDetailsEvent({required this.placeId, required this.description});
}
