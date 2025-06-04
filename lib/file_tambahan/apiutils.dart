class ApiUtils {
  // static const String baseUrl = 'http://10.0.2.2:8000/';
  // static const String baseUrl = 'https://apakek.com/';
  static const String baseUrl = 'http://167.71.221.35:8000/';
  // static const String baseUrl = 'http://192.168.0.102:8000/';

  static String buildUrl(String endpoint) {
    return baseUrl + endpoint;
  }
}
