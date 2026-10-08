import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/app.dart';
import '../../app/route/app_routes.dart';
import '../local_database/auth_db.dart';
import 'injection_container.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
      ),
    );
    dio.interceptors.add(
      PrettyDioLogger(requestHeader: true, requestBody: true),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          final path = error.requestOptions.path.toLowerCase();
          final isAuthOrPublic = path.contains('/auth/') ||
              path.contains('/public/') ||
              path.contains('/login');

          if (!isAuthOrPublic &&
              (error.response?.statusCode == 401 ||
                  error.response?.statusCode == 403)) {
            final authDb = getIt<AuthLocalDB>();
            final token = await authDb.getToken();

            // Only perform auto-logout redirect if the user was actually logged in with an active token
            if (token != null && token.isNotEmpty) {
              final userType = await authDb.getUserType();

              // Clear storage
              await authDb.removeToken();

              final navigator = MyApp.navigatorKey.currentState;
              if (navigator != null) {
                String redirectRoute = AppRoutes.roleSelectionPage;
                final upperType = userType?.toUpperCase().trim();

                if (upperType == 'JOB_SEEKER') {
                  redirectRoute = AppRoutes.jobSeekerLogin;
                } else if (upperType == 'HOTELIER') {
                  // redirectRoute = AppRoutes.loginPageHiringManager;
                } else if (upperType == 'RESIDENTIAL') {
                  // redirectRoute = AppRoutes.loginPageRes;
                }

                navigator.pushNamedAndRemoveUntil(
                  redirectRoute,
                  (route) => false,
                );
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
    return dio;
  }

  @preResolve
  Future<SharedPreferences> get sharedPreferences async {
    return SharedPreferences.getInstance();
  }

  @lazySingleton
  FlutterSecureStorage get storage =>
      FlutterSecureStorage(aOptions: _getAndroidOptions());
}

AndroidOptions _getAndroidOptions() => const AndroidOptions();
