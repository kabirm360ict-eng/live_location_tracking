import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracking/core/constants/app_urls.dart';
import 'package:location_tracking/core/errors/exceptions.dart';
import 'package:location_tracking/core/model/full_address.dart';
import 'package:location_tracking/feature/job_seeker/location/data/model/prediction_list_response_model.dart';

import '../../../../../core/errors/failures.dart';
import '../../presentation/service/places_service.dart';


class LocationRemoteDataSource {
  final _service = PlacesService(
    AppUrls.placeApi,
    session: AppUrls.placeSession,
  );
  Future<Either<Failure, List<PredictionListResponseModel>>>
  fetchSuggestionList({required String input}) async {
    try {
      final result = await _service.getSuggestions(input);
      return Right(predictionListResponseModelFromJson(jsonEncode(result)));
    } catch (e, k) {
      return Left(handleException(e, k));
    }
  }

  //for getting place details
  Future<Either<Failure, FullAddress>> getPlaceDetails({
    required String placeId,
  }) async {
    try {
      final result = await _service.getPlaceDetails(placeId);
      return Right(result);
    } catch (e, k) {
      return Left(handleException(e, k));
    }
  }

  /// High-accuracy geocoding resolution using Google APIs
  Future<LatLng?> getCoordinatesFromAddress({
    required String address,
  }) async {
    try {
      return await _service.getCoordinatesFromAddress(address);
    } catch (e) {
      return null;
    }
  }
}
