class AppUrls {
  static const baseUrl = "http://192.168.1.13:5001/api/app";

  // --------------------------------------
  // Auth
  // ---------------------------------

  static const register = "$baseUrl/auth/register";
  static const login = "$baseUrl/auth/send-otp";
  static const verifyOtp = "$baseUrl/auth/verify-otp";
}
