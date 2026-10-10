import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:location_tracking/core/dio/injection_container.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/local_database/auth_db.dart';
import '../../../../../core/network/api_client2.dart';
import 'package:location_tracking/feature/job_seeker/profile/presentation/widget/send_file_model.dart';
import '../model/profile_response_model_hiring.dart';
import '../model/profile_update_request_model_hiring.dart';

class ProfileHotelierRemoteDataSource {
  static Future<Either<Failure, ProfileResponseModelHiring>> getProfile() async {
    try {
      final result = await getIt<ApiClient2>().get(
        url: AppUrls.profileHiring,
        tokenAuthorization: await getIt<AuthLocalDB>().getToken(),
      );
      final data = result is Map<String, dynamic> ? (result['data'] ?? result) : result;
      return Right(profileResponseModelHiringFromJson(jsonEncode(data)));
    } catch (e, stackTrace) {
      return Left(handleException(e, stackTrace));
    }
  }

  static Future<Either<Failure, ProfileResponseModelHiring>> updateProfile({
    required ProfileUpdateRequestModelHiring payload,
    List<SendFileModel> files = const [],
  }) async {
    try {
      final filesMap = <String, String>{};
      for (final f in files) {
        filesMap[f.key] = f.filePath;
      }
      final result = await getIt<ApiClient2>().multiPartPatch(
        url: AppUrls.updateProfileHiring,
        files: filesMap,
        body: payload.toJson(),
        tokenAuthorization: await getIt<AuthLocalDB>().getToken(),
      );
      final data = result is Map<String, dynamic> ? (result['data'] ?? result) : result;
      return Right(profileResponseModelHiringFromJson(jsonEncode(data)));
    } catch (e, stackTrace) {
      return Left(handleException(e, stackTrace));
    }
  }
}
