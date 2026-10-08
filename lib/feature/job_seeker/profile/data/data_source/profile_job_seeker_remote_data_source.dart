import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:location_tracking/core/dio/injection_container.dart';
import 'package:location_tracking/feature/job_seeker/profile/data/model/profile_get_job_seeker_model.dart';
import 'package:location_tracking/feature/job_seeker/profile/data/model/profile_update_job_seeker_model.dart';
import 'package:location_tracking/feature/job_seeker/profile/presentation/widget/send_file_model.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/local_database/auth_db.dart';
import '../../../../../core/network/api_client2.dart';

class ProfileJobSeekerRemoteDataSource {
  static Future<Either<Failure, ProfileGetJobSeekerModel>> getProfile() async {
    try {
      final result = await getIt<ApiClient2>().get(
        url: AppUrls.profileJobSeeker,
        tokenAuthorization: await getIt<AuthLocalDB>().getToken(),
      );
      final data = result is Map<String, dynamic> ? (result['data'] ?? result) : result;
      return Right(profileGetJobSeekerModelFromJson(jsonEncode(data)));
    } catch (e, stackTrace) {
      return Left(handleException(e, stackTrace));
    }
  }

  // //!for update profile
  static Future<Either<Failure, ProfileGetJobSeekerModel>> updateProfile({
    required ProfileUpdateJobSeekerModel payload,
    required List<SendFileModel> file,
  }) async {
    try {
      final filesMap = <String, String>{};
      for (final f in file) {
        filesMap[f.key] = f.filePath;
      }
      final result = await getIt<ApiClient2>().multiPartPatch(
        files: filesMap,
        url: AppUrls.profileJobSeeker,
        body: payload.toJson(),
        tokenAuthorization: await getIt<AuthLocalDB>().getToken(),
      );
      final data = result is Map<String, dynamic> ? (result['data'] ?? result) : result;
      return Right(profileGetJobSeekerModelFromJson(jsonEncode(data)));
    } catch (e, stackTrace) {
      return Left(handleException(e, stackTrace));
    }
  }

  // //!for update verify documents (id_copy, work_permit)
  // static Future<Either<Failure, dynamic>> updateVerifyDocuments({
  //   required List<SendFileModel> files,
  // }) async {
  //   try {
  //     final token = await getIt<AuthLocalDB>().getToken();
  //     if (token == null || token.isEmpty) {
  //       return Left(
  //         ApiFailure('Authentication token not found. Please log in again.'),
  //       );
  //     }
  //     final filesMap = <String, String>{};
  //     for (final f in files) {
  //       filesMap[f.key] = f.filePath;
  //     }
  //     final result = await getIt<ApiClient2>().multiPartPatch(
  //       files: filesMap,
  //       url: AppUrls.completeProfileJobSeeker,
  //       tokenAuthorization: token,
  //     );
  //     return Right(result);
  //   } catch (e, stackTrace) {
  //     return Left(handleException(e, stackTrace));
  //   }
  // }
}

