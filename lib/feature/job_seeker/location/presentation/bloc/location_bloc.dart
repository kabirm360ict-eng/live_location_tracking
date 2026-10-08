import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/core/model/full_address.dart';
import 'package:location_tracking/feature/job_seeker/location/data/data_source/location_remote_data_source.dart';
import 'package:location_tracking/feature/job_seeker/location/data/model/prediction_list_response_model.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<GetSuggestionListEvent>(_getSuggestionList);
    on<GetPlaceDetailsEvent>(_getPlaceDetails);
  }

  //for suggestion
  void _getSuggestionList(
    GetSuggestionListEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationSuggestionsLoadingState());
    final result = await LocationRemoteDataSource().fetchSuggestionList(
      input: event.input,
    );
    result.fold(
      (l) => emit(LocationSuggestionsFailureState(message: l.toString())),
      (r) => emit(LocationSuggestionsSuccessState(suggestions: r)),
    );
  }

  //for place details
  void _getPlaceDetails(
    GetPlaceDetailsEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationPlaceDetailsLoadingState());
    final result = await LocationRemoteDataSource().getPlaceDetails(
      placeId: event.placeId,
    );
    result.fold(
      (l) => emit(LocationPlaceDetailsFailureState(message: l.toString())),
      (r) {
        emit(LocationPlaceDetailsSuccessState(
          placeDetails: r.copyWith(street: event.description),
        ));
      },
    );
  }
}
