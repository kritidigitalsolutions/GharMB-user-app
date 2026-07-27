class AppUrls {
  static const baseUrl = "http://192.168.1.13:5001/api/app";

  // --------------------------------------
  // Auth
  // ---------------------------------

  static const register = "$baseUrl/auth/register";
  static const login = "$baseUrl/auth/send-otp";
  static const verifyOtp = "$baseUrl/auth/verify-otp";
  static const addProperties = "$baseUrl/properties";
  static const dashBoardUrl = "$baseUrl/properties/my-dashboard";
  static const getProfile = "$baseUrl/users/me";
  static const agentRegister = "$baseUrl/users/register-agent";
  static const uploadFile = "$baseUrl/upload/multiple";
  static const developerRegister = "$baseUrl/users/register-developer";
}
