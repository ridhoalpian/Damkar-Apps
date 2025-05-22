class ApiUtils {
  static const String baseUrl = 'http://10.0.2.2:8000/';
  // static const String baseUrl = 'https://apakek.com/';

  static String buildUrl(String endpoint) {
    return baseUrl + endpoint;
  }
}