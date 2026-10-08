import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ApiClient2 {
  final Dio _dio;

  ApiClient2(this._dio);

  //for get
  Future<dynamic> get({
    required String url,
    String? tokenAuthorization,
    Map<String, dynamic>? queryParams,
  }) async {
    final options = _buildOptions(tokenAuthorization: tokenAuthorization);

    final response = await _dio.get(
      url,
      queryParameters: queryParams,
      options: options,
    );
    return response.data;
  }

  //for post
  Future<dynamic> post({
    required String url,
    String? tokenAuthorization,
    String? devicetoken,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    final options = _buildOptions(
      tokenAuthorization: tokenAuthorization,
      devicetoken: devicetoken,
    );

    final response = await _dio.post(
      url,
      data: body,
      options: options,
      queryParameters: queryParams,
    );
    return response.data;
  }

  //for patch
  Future<dynamic> patch({
    required String url,
    String? tokenAuthorization,
    Map<String, dynamic>? body,
  }) async {
    final options = _buildOptions(tokenAuthorization: tokenAuthorization);

    final response = await _dio.patch(url, data: body, options: options);
    return response.data;
  }

  //for delete
  Future<dynamic> delete({
    required String url,
    String? tokenAuthorization,
  }) async {
    final options = _buildOptions(tokenAuthorization: tokenAuthorization);

    final response = await _dio.delete(url, options: options);
    return response.data;
  }

  Future<dynamic> multiPartPatch({
    required String url,
    String? tokenAuthorization,
    Map<String, dynamic>? body,
    Map<String, String>? files,
  }) async {
    final options = _buildOptions(
      tokenAuthorization: tokenAuthorization,
      isMultipart: true,
    );
    final formData = FormData();

    if (body != null) {
      formData.fields.addAll(
        body.entries.map((e) => MapEntry(e.key, e.value.toString())),
      );
    }
    if (files != null) {
      for (final file in files.entries) {
        formData.files.add(
          MapEntry(
            file.key,
            MultipartFile.fromFileSync(file.value, filename: file.key),
          ),
        );
      }
    }
    final response = await _dio.patch(url, data: formData, options: options);
    return response.data;
  }

  Future<dynamic> multiPartPost({
    required String url,
    String? tokenAuthorization,
    Map<String, dynamic>? body,
    Map<String, String>? files,
  }) async {
    final options = _buildOptions(
      tokenAuthorization: tokenAuthorization,
      isMultipart: true,
    );
    final formData = FormData();

    if (body != null) {
      formData.fields.addAll(
        body.entries.map((e) => MapEntry(e.key, e.value.toString())),
      );
    }
    if (files != null) {
      for (final file in files.entries) {
        if (file.value.isNotEmpty) {
          formData.files.add(
            MapEntry(
              file.key,
              MultipartFile.fromFileSync(file.value, filename: file.key),
            ),
          );
        }
      }
    }
    final response = await _dio.post(url, data: formData, options: options);
    return response.data;
  }

  Options _buildOptions({
    String? tokenAuthorization,
    String? devicetoken,
    bool isMultipart = false,
  }) {
    return Options(
      headers: {
        if (!isMultipart) 'Content-Type': 'application/json',
        if (isMultipart) 'Content-Type': 'multipart/form-data',
        if (tokenAuthorization != null)
          'Authorization': 'Bearer $tokenAuthorization',
        if (devicetoken != null) 'devicetoken': devicetoken,
      },
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      sendTimeout: Duration(seconds: 30),
    );
  }
}
