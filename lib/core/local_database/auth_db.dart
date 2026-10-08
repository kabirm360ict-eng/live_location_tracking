import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:location_tracking/core/constants/app_value.dart';



@lazySingleton
class AuthLocalDB {
  final FlutterSecureStorage storage;

  AuthLocalDB(this.storage);

  //! --- Storage & token ---
  static final String authKey = "authKey_${AppValues.appName}";
  static final String userIdKey = "userIdKey_${AppValues.appName}";
  static final String userTypeKey = "userTypeKey_${AppValues.appName}";
  static final String fcmTokenKey = "fcmTokenKey_${AppValues.appName}";
  static final String getTopicSubscribedKey ="getTopicSubscribedKey_${AppValues.appName}";
  static final String adminChatSessionKey ="adminChatSessionKey_${AppValues.appName}";
  static final String locationKey = "locationKey_${AppValues.appName}";
  static final String matchOtpTokenKey = "matchOtpTokenKey_${AppValues.appName}";
  static final String preferredJobKey = "preferredJobKey_${AppValues.appName}";

  String? tokenInstance;
  String? userIdInstance;
  String? userTypeInstance;
  String? fcmTokenInstance;
  bool? topicSubscribedInstance;
  String? adminChatSessionInstance;
  String? locationInstance;
  String? matchOtpTokenInstance;
  String? preferredJobInstance;

  //! --- Set token ---
  Future<void> setToken(String token) async {
    tokenInstance = token;
    await storage.write(key: authKey, value: token);
    if (kDebugMode) {
      print("Token set successfully");
    }
  }

  Future<void> setMatchOtpToken(String token) async {
    matchOtpTokenInstance = token;
    await storage.write(key: matchOtpTokenKey, value: token);
    if (kDebugMode) {
      print("Match OTP Token set successfully");
    }
  }

  //!set user id
  Future<void> setUserId(String userId) async {
    userIdInstance = userId;
    await storage.write(key: userIdKey, value: userId);
    if (kDebugMode) {
      print("User Id set successfully $userId");
    }
  }

  //! set user type
  Future<void> setUserType(String userType) async {
    userTypeInstance = userType;
    await storage.write(key: userTypeKey, value: userType);
    if (kDebugMode) {
      print("User Type set successfully $userType");
    }
  }

  //! --- Get user Type ---
  Future<String?> getUserType() async {
    if (userTypeInstance != null) return userTypeInstance;

    final userType = await storage.read(key: userTypeKey);
    userTypeInstance = userType;
    return userType;
  }

  //!set FCM token
  Future<void> setFCMToken(String fcmToken) async {
    await storage.write(key: fcmTokenKey, value: fcmToken);
    fcmTokenInstance = fcmToken;
    if (kDebugMode) {
      print("FCM Token set successfully $fcmToken");
    }
  }

  //!set topic subscribed
  Future<void> setTopicSubscribed(bool subscribed) async {
    await storage.write(
      key: getTopicSubscribedKey,
      value: subscribed.toString(),
    );
    topicSubscribedInstance = subscribed;
    if (kDebugMode) {
      print("Topic Subscribed set successfully $subscribed");
    }
  }

  //!set location
  Future<void> setLocation(String location) async {
    await storage.write(key: locationKey, value: location);
    locationInstance = location;
    if (kDebugMode) {
      print("location set successfully DB $location");
    }
  }

  //! --- Get user ID ---

  Future<String?> getUserId() async {
    if (userIdInstance != null) return userIdInstance;

    final userId = await storage.read(key: userIdKey);
    userIdInstance = userId;
    return userId;
  }

  //! --- Get FCM token ---
  Future<String?> getFCMToken() async {
    if (fcmTokenInstance != null) return fcmTokenInstance;

    final fcmToken = await storage.read(key: fcmTokenKey);
    fcmTokenInstance = fcmToken;
    return fcmToken;
  }

  //! --- Get topic subscribed ---
  Future<bool> getTopicSubscribed() async {
    if (topicSubscribedInstance != null) return topicSubscribedInstance!;

    final topicSubscribed = await storage.read(key: getTopicSubscribedKey);
    if (topicSubscribed != null) {
      topicSubscribedInstance = topicSubscribed.toLowerCase() == 'true';
    } else {
      topicSubscribedInstance = false; // default to false if not set
    }
    return topicSubscribedInstance!;
  }

  //! --- Get token ---
  Future<String?> getToken() async {
    if (tokenInstance != null) return tokenInstance;

    final token = await storage.read(key: authKey);
    tokenInstance = token;
    return token;
  }

  //! --- Get Match OTP Token ---
  Future<String?> getMatchOtpToken() async {
    if (matchOtpTokenInstance != null) return matchOtpTokenInstance;

    final matchOtpToken = await storage.read(key: matchOtpTokenKey);
    matchOtpTokenInstance = matchOtpToken;
    return matchOtpToken;
  }

  //! --- Get Location ---
  Future<String?> getLocation() async {
    if (locationInstance != null) return locationInstance;

    final location = await storage.read(key: locationKey);
    locationInstance = location;
    return location;
  }

  //! --- account status ----
  Future<void> setAccountStatus(String status) async {
    await storage.write(key: "accountStatus", value: status);
    if (kDebugMode) {
      print("accountStatus set successfully $status");
    }
  }

  Future<String?> getAccountStatus() async {
    final status = await storage.read(key: "accountStatus");
    return status;
  }

  //! --- Preferred Job ---
  Future<void> setPreferredJob(String? preferredJob) async {
    preferredJobInstance = preferredJob;
    if (preferredJob == null) {
      await storage.delete(key: preferredJobKey);
    } else {
      await storage.write(key: preferredJobKey, value: preferredJob);
    }
    if (kDebugMode) {
      print("preferredJob set successfully: $preferredJob");
    }
  }

  Future<String?> getPreferredJob() async {
    if (preferredJobInstance != null) return preferredJobInstance;
    final preferredJob = await storage.read(key: preferredJobKey);
    preferredJobInstance = preferredJob;
    return preferredJob;
  }

  //! --- Remove token ---
  Future<void> removeToken() async {
    tokenInstance = null;
    userIdInstance = null;
    userTypeInstance = null;
    await storage.delete(key: authKey);
    await storage.delete(key: userTypeKey);
    await storage.delete(key: userIdKey);
    await storage.delete(key: "accountStatus");
    await storage.delete(key: adminChatSessionKey);
    await storage.delete(key: locationKey);
    await storage.delete(key: preferredJobKey);
    preferredJobInstance = null;
    // await storage.delete(key: fcmTokenKey);
    // await storage.delete(key: getTopicSubscribedKey);

    // Clear local category db cache
    // try {
    //   await getIt<CategoryDb>().clearCategoryList();
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("Error clearing category list: $e");
    //   }
    // }

    // // Reset JobCategoryBloc state so it refreshes on next login
    // try {
    //   getIt<JobCategoryBloc>().add(ResetJobCategoryEvent());
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("Error resetting JobCategoryBloc: $e");
    //   }
    // }

    if (kDebugMode) {
      print("Token removed successfully");
    }
  }

  //! --- Deleted Account Emails ---
  Future<void> addDeletedEmail(String email) async {
    await storage.write(key: "deleted_email_$email", value: "true");
    if (kDebugMode) {
      print("Email added to deleted list: $email");
    }
  }

  Future<bool> isEmailDeleted(String email) async {
    final value = await storage.read(key: "deleted_email_$email");
    return value == "true";
  }
}
