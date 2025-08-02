class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);

  // For Android Emulator
  static const String serverAddress = "http://10.0.2.2:5050";
  // For iOS Simulator
  //static const String serverAddress = "http://localhost:5050";

  static const String baseUrl = "$serverAddress/api";
  static const String imageUrl = "$baseUrl/uploads/";

  // Auth endpoints
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String forgotPassword = "/auth/forgot-password";
  static const String resetPassword = "/auth/reset-password";
  static const String getMe = "/auth/me";

  // User endpoints
  static const String bidHistory = "/auth/bid-history";
}
