import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../core/dio/injection_container.dart';
import '../../../../../core/local_database/auth_db.dart';
import '../../../../../core/network/api_client2.dart';
import '../model/hotelier_login_response_model.dart';
import '../model/login_request_hotelier_model.dart';

@LazySingleton()
class HotelierAuthRemoteDataSource {
  final AuthLocalDB _localDB;
  HotelierAuthRemoteDataSource(this._localDB);

  // for login
  Future<HotelierLoginResponseModel> login({
    required LoginRequestHotelierModel payload,
  }) async {
    String fcmToken = '';
    try {
      fcmToken = await FirebaseMessaging.instance.getToken() ??
          'dummy_device_token_for_testing';
    } catch (e) {
      debugPrint("FCM Token error: $e");
      fcmToken = 'dummy_device_token_for_testing';
    }

    final result = await getIt<ApiClient2>().post(
      url: AppUrls.loginHiring,
      body: payload.toJson(),
      devicetoken: fcmToken,
    );

    if (result is Map<String, dynamic>) {
      final token = result['token'] ??
          (result['data'] is Map ? result['data']['token'] : null);
      if (token != null && token.toString().isNotEmpty) {
        await _localDB.setToken(token.toString());
      }
    }

    final data = result is Map<String, dynamic>
        ? (result['data'] ?? result)
        : result;
    final response =
        HotelierLoginResponseModel.fromJson(data as Map<String, dynamic>);

    if (response.userId != null) {
      await _localDB.setUserId(response.userId.toString());
    }
    await _localDB.setUserType('HOTELIER');
    if (response.address != null) {
      await _localDB.setLocation(response.address.toString());
    }

    return response;
  }

  // logout
  Future<void> logout() async {
    await getIt<ApiClient2>().post(
      url: AppUrls.logoutHotelier,
      tokenAuthorization: await _localDB.getToken(),
    );
  }
}
