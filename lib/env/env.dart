import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'VERSION_MANAGER', obfuscate: true)
  static String versionManager = _Env.versionManager;
  
  @EnviedField(varName: 'VERSION_MANAGER2', obfuscate: true)
  static String versionManager2 = _Env.versionManager2;

  @EnviedField(varName: 'IMAGE_URL', obfuscate: true)
  static String imageUrl = _Env.imageUrl;

  @EnviedField(varName: 'STRIPE_PUBLISHABLE_KEY_LIVE', obfuscate: true)
  static String stripePublishableKeyLive = _Env.stripePublishableKeyLive;

  @EnviedField(varName: 'STRIPE_PUBLISHABLE_KEY_LOCAL', obfuscate: true)
  static String stripePublishableKeyLocal = _Env.stripePublishableKeyLocal;

  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY', obfuscate: true)
  static String googleMapsApiKey = _Env.googleMapsApiKey;

  @EnviedField(varName: 'HEIGIT_API_KEY', obfuscate: true)
  static String heigitApiKey = _Env.heigitApiKey;

  @EnviedField(varName: 'PLACE_API', obfuscate: true)
  static String placeApi = _Env.placeApi;

  @EnviedField(varName: 'PLACE_SESSION', obfuscate: true)
  static String placeSession = _Env.placeSession;

  @EnviedField(varName: 'PROD_BASE_URL', obfuscate: true)
  static String prodBaseUrl = _Env.prodBaseUrl;

  @EnviedField(varName: 'DEV_BASE_URL', obfuscate: true)
  static String devBaseUrl = _Env.devBaseUrl;

  @EnviedField(varName: 'PROD_SOCKET_URL', obfuscate: true)
  static String prodSocketUrl = _Env.prodSocketUrl;

  @EnviedField(varName: 'DEV_SOCKET_URL', obfuscate: true)
  static String devSocketUrl = _Env.devSocketUrl;

  @EnviedField(varName: 'LOCAL_BASE_URL', obfuscate: true)
  static String localBaseUrl = _Env.localBaseUrl;

  @EnviedField(varName: 'LOCAL_SOCKET_URL', obfuscate: true)
  static String localSocketUrl = _Env.localSocketUrl;

}