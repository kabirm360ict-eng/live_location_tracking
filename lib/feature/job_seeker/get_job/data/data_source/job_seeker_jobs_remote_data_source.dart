import 'package:injectable/injectable.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/local_database/auth_db.dart';
import '../../../../../core/network/api_client2.dart';
import '../models/job_seeker_jobs_response_model.dart';

abstract class JobSeekerJobsRemoteDataSource {
  Future<JobSeekerJobsResponseModel> getJobs({
    String preferredJob = 'ALL',
  });
}

@LazySingleton(as: JobSeekerJobsRemoteDataSource)
class JobSeekerJobsRemoteDataSourceImpl implements JobSeekerJobsRemoteDataSource {
  final AuthLocalDB _localDB;
  final ApiClient2 _apiClient;

  JobSeekerJobsRemoteDataSourceImpl(this._localDB, this._apiClient);

  @override
  Future<JobSeekerJobsResponseModel> getJobs({
    String preferredJob = 'ALL',
  }) async {
    final token = await _localDB.getToken();
    final result = await _apiClient.get(
      url: AppUrls.allJobs,
      queryParams: {
        'preferred_job': preferredJob,
      },
      tokenAuthorization: token,
    );

    return JobSeekerJobsResponseModel.fromJson(result as Map<String, dynamic>);
  }
}
