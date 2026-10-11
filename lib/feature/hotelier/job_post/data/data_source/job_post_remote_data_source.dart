import 'package:injectable/injectable.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/local_database/auth_db.dart';
import '../../../../../core/network/api_client2.dart';
import '../model/hotelier_job_posts_response_model.dart';
import '../model/hotelier_single_job_post_response_model.dart';
import '../model/job_post_request_model.dart';
import '../model/job_post_response_model.dart';

abstract class JobPostRemoteDataSource {
  Future<JobPostResponseModel> createJobPost({
    required JobPostRequestModel payload,
  });

  Future<HotelierJobPostsResponseModel> getHotelierJobPosts();

  Future<HotelierSingleJobPostResponseModel> getHotelierJobPostDetails(int id);
}

@LazySingleton(as: JobPostRemoteDataSource)
class JobPostRemoteDataSourceImpl implements JobPostRemoteDataSource {
  final AuthLocalDB _localDB;
  final ApiClient2 _apiClient;

  JobPostRemoteDataSourceImpl(this._localDB, this._apiClient);

  @override
  Future<JobPostResponseModel> createJobPost({
    required JobPostRequestModel payload,
  }) async {
    final token = await _localDB.getToken();
    final result = await _apiClient.post(
      url: AppUrls.jobPostsHiring,
      body: payload.toJson(),
      tokenAuthorization: token,
    );

    return JobPostResponseModel.fromJson(result as Map<String, dynamic>);
  }

  @override
  Future<HotelierJobPostsResponseModel> getHotelierJobPosts() async {
    final token = await _localDB.getToken();
    final result = await _apiClient.get(
      url: AppUrls.jobPostsHiring,
      tokenAuthorization: token,
    );

    return HotelierJobPostsResponseModel.fromJson(
      result as Map<String, dynamic>,
    );
  }

  @override
  Future<HotelierSingleJobPostResponseModel> getHotelierJobPostDetails(
    int id,
  ) async {
    final token = await _localDB.getToken();
    final result = await _apiClient.get(
      url: '${AppUrls.jobPostsHiring}/$id',
      tokenAuthorization: token,
    );

    return HotelierSingleJobPostResponseModel.fromJson(
      result as Map<String, dynamic>,
    );
  }
}
