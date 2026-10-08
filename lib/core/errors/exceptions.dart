import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_exception_messages.dart';
import '../constants/app_urls.dart';
import 'failures.dart';

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

Failure handleException(dynamic e, StackTrace stackTrace) {
  debugPrint("=" * 30);
  debugPrint("error handleException: $e");
  debugPrint("stackTrace: $stackTrace");
  debugPrint("=" * 30);

  if (e is SocketException) {
    return ApiFailure(AppExceptionMessage.socket);
  } else if (e is TimeoutException) {
    return ApiFailure(AppExceptionMessage.timeout);
  } else if (e is FormatException) {
    return ApiFailure(AppExceptionMessage.format);
  } else if (e is TypeError) {
    return ApiFailure(AppExceptionMessage.type);
  } else if (e is ServerException) {
    return ApiFailure(isLive && e.message.length > 200 ? AppExceptionMessage.unknown : e.message);
  } else if (e is DioException) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return ApiFailure(AppExceptionMessage.timeout);

      case DioExceptionType.connectionError:
        return ApiFailure(AppExceptionMessage.socket);

      case DioExceptionType.badCertificate:
        return ApiFailure(AppExceptionMessage.badCertificate);

      case DioExceptionType.cancel:
        return ApiFailure(AppExceptionMessage.cancel);

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 408 || statusCode == 504) {
          return ApiFailure(AppExceptionMessage.timeout);
        }
        if (statusCode == 502 || statusCode == 503) {
          final serverMsg = _extractErrorMessage(e.response?.data);
          return ApiFailure(serverMsg ?? AppExceptionMessage.serverUnavailable);
        }
        final message = _extractErrorMessage(e.response?.data) ?? AppExceptionMessage.serverDefault;
        return ApiFailure((isLive && message.length > 200) ? AppExceptionMessage.serverDefault : message);

      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return ApiFailure(AppExceptionMessage.socket);
        }
        if (e.error is TimeoutException) {
          return ApiFailure(AppExceptionMessage.timeout);
        }
        if (e.error is FormatException) {
          return ApiFailure(AppExceptionMessage.format);
        }
        final errorStr = (e.error?.toString() ?? e.message ?? '').toLowerCase();
        if (errorStr.contains('timeout') || errorStr.contains('timed out')) {
          return ApiFailure(AppExceptionMessage.timeout);
        }
        if (errorStr.contains('socket') ||
            errorStr.contains('network') ||
            errorStr.contains('failed host lookup') ||
            errorStr.contains('connection refused') ||
            errorStr.contains('network is unreachable')) {
          return ApiFailure(AppExceptionMessage.socket);
        }
        return ApiFailure(AppExceptionMessage.unknown);
    }
  } else {
    final errorStr = e.toString().toLowerCase();
    if (errorStr.contains('timeoutexception') || errorStr.contains('timed out')) {
      return ApiFailure(AppExceptionMessage.timeout);
    }
    if (errorStr.contains('socketexception') ||
        errorStr.contains('network') ||
        errorStr.contains('failed host lookup') ||
        errorStr.contains('network is unreachable')) {
      return ApiFailure(AppExceptionMessage.socket);
    }
    return ApiFailure(AppExceptionMessage.unknown);
  }
}

String? _extractErrorMessage(dynamic data) {
  if (data == null) return null;
  if (data is String) {
    final trimmed = data.trim();
    if (trimmed.isEmpty || trimmed.contains('<html') || trimmed.contains('<!DOCTYPE')) {
      return null;
    }
    return trimmed;
  }
  if (data is Map) {
    if (data['message'] != null && data['message'].toString().trim().isNotEmpty) {
      return data['message'].toString().trim();
    }
    if (data['error'] != null && data['error'].toString().trim().isNotEmpty) {
      return data['error'].toString().trim();
    }
    if (data['msg'] != null && data['msg'].toString().trim().isNotEmpty) {
      return data['msg'].toString().trim();
    }
    if (data['errors'] != null) {
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        return errors.first.toString().trim();
      }
      if (errors is Map && errors.isNotEmpty) {
        final firstVal = errors.values.first;
        if (firstVal is List && firstVal.isNotEmpty) {
          return firstVal.first.toString().trim();
        }
        return firstVal.toString().trim();
      }
    }
  }
  return null;
}
