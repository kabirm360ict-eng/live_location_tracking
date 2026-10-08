import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/dio/injection_container.dart';
import '../../../../../core/local_database/auth_db.dart';

import '../../../../../core/network/api_client2.dart';

import '../models/fcm_token_model.dart';
import '../models/job_seeker_login_response_model.dart';
import '../models/login_request_model_job.dart';

@LazySingleton()
class AuthRemoteDataSourceJob {
  final AuthLocalDB _localDB;
  AuthRemoteDataSourceJob(this._localDB);

  //for login
  Future<JobSeekerLoginResponseModel> login({required LoginRequestJobModel payload}) async {
    // Get FCM token
    String fcmToken = '';
    try {
      fcmToken = await FirebaseMessaging.instance.getToken() ?? 'dummy_device_token_for_testing';
    } catch (e) {
      debugPrint("FCM Token error: $e");
      fcmToken = 'dummy_device_token_for_testing';
    }

    final result = await getIt<ApiClient2>().post(url: AppUrls.loginJob, body: payload.toJson(), devicetoken: fcmToken);

    if (result is Map<String, dynamic>) {
      final token = result['token'] ?? (result['data'] is Map ? result['data']['token'] : null);
      if (token != null && token.toString().isNotEmpty) {
        await _localDB.setToken(token.toString());
      }
    }

    final data = result is Map<String, dynamic> ? (result['data'] ?? result) : result;
    final response = JobSeekerLoginResponseModel.fromJson(data as Map<String, dynamic>);

    if (response.userId != null) {
      await _localDB.setUserId(response.userId.toString());
    }
    await _localDB.setUserType('JOB_SEEKER');
    if (response.accountStatus != null) {
      await _localDB.setAccountStatus(response.accountStatus.toString());
    }
    if (response.preferredJob != null) {
      await _localDB.setPreferredJob(response.preferredJob.toString());
    }

    return response;
  }

  //for fcm token
  Future<bool> fcmToken({required FcmTokenModel fcmToken}) async {
    final result = await getIt<ApiClient2>().multiPartPatch(
      url: AppUrls.profileJobSeeker,
      body: fcmToken.toJson(),
      tokenAuthorization: await _localDB.getToken(),
    );
    return result != null;
  }

  // //for send otp
  // Future<bool> sendOtp(SendEmailOtpModel payload) async {
  //   final result = await getIt<ApiClient2>().post(url: AppUrls.sendEmailOtp, body: payload.toJson());
  //   return result != null;
  // }

  // //for register
  // Future<bool> register({required RegistrationRequestJobModel payload, required List<SendFileModel> file}) async {
  //   final filesMap = <String, String>{};
  //   for (final f in file) {
  //     filesMap[f.key] = f.filePath;
  //   }
  //   final result = await getIt<ApiClient2>().multiPartPost(
  //     url: AppUrls.registrationJob,
  //     files: filesMap,
  //     body: payload.toJson(),
  //     tokenAuthorization: await _localDB.getToken(),
  //   );
  //   return result != null;
  // }

  //for match otp
  // Future<bool> matchOtp(MatchOtpRequestModel payload) async {
  //   final result = await getIt<ApiClient2>().post(
  //     url: AppUrls.matchEmailOtp,
  //     body: payload.toJson(),
  //     devicetoken: payload.type == OtpType.verifyJobSeeker2Fa.value ? await FirebaseMessaging.instance.getToken() : null,
  //   );
  //   if (result is Map<String, dynamic>) {
  //     final token = result['token'] ?? (result['data'] is Map ? result['data']['token'] : null);
  //     if (token != null && token.toString().isNotEmpty) {
  //       if (payload.type == OtpType.resetJobSeeker.value) {
  //         await _localDB.setMatchOtpToken(token.toString());
  //       } else {
  //         await _localDB.setToken(token.toString());
  //         await _localDB.setUserType('JOB_SEEKER');
  //       }
  //     }
  //   }
  //   return result != null;
  // }

  // //for forget password
  // Future<bool> forgetPasswordJob({required ChangePasswordRequestModel payload}) async {
  //   final result = await getIt<ApiClient2>().post(
  //     url: AppUrls.forgetPasswordJob,
  //     body: payload.toJson(),
  //     tokenAuthorization: await _localDB.getToken(),
  //   );
  //   return result != null;
  // }

  // // password change
  // Future<void> changePassword(PasswordChangeModel payload) async {
  //   await getIt<ApiClient2>().post(url: AppUrls.changePasswordJob, body: payload.toJson(), tokenAuthorization: await _localDB.getToken());
  // }

  // log out
  Future<void> logoutJobSeeker() async {
    await getIt<ApiClient2>().post(url: AppUrls.logoutJobSeeker, tokenAuthorization: await _localDB.getToken());
  }
}
