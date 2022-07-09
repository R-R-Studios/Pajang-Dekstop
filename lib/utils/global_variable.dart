
class GlobalVariable {

  static const bool RELEASE = false;

  static const bool DEBUG = true;

  static const String PARAMS_AUTHORIZATION = "Authorization";

  static const String URL_PRODUCTION = "";

  static const String URL_STAGING = "";

  static const Duration TIME_REQUEST_API = Duration(minutes: 3);

  //? Encrypt Atributte (sample)
  static const String CYPHER_INSTANCE = "AES/CBC/PKCS5Padding";
  static const String SECRET_KEY_INSTANCE = "PBKDF2WithHmacSHA1";
  static const String PASSWORD_KEY = "12S_09dxfcAjKABsa";
  static const String SALT = "LKMBx3cP8Tt37w6XF61U";

  static const String APPS_ORIGIN = "consumer";
  static const String CACHE_CONTROL = "no-cache";
  static const String CONTENT_TYPE = "application/json";

  static const String DEVICE_AGEN = "ios";
  static const String USER_AGENT = "android";
  static const String APPS_VERSION_ANDROID = "v1.0.4";
  static const String APPS_VERSION_IOS = "v1.0.4";
  static const String CLIENT_KEY = RELEASE ? CLIENT_KEY_PRODUCTION : CLIENT_KEY_STAGGING;
  static const String CLIENT_KEY_PRODUCTION = "b86798974f97";
  static const String CLIENT_KEY_STAGGING = "b86798974f97";
  // static const String BASIC_URL_STAGGING = "https://stg-api.bfireship.com/api/pos/";
  // static const String BASIC_URL_PRODUCTION = "https://stg-api.bfireship.com/api/pos/";
  static const String BASIC_URL_STAGGING = "https://stg-api.bfireship.com/";
  static const String BASIC_URL_PRODUCTION = "https://beta-api.bfireship.com";
}