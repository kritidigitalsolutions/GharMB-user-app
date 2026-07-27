class AppUrls {
  static const serverUrl = "http://192.168.1.16:5001";
  static const baseUrl = "$serverUrl/api/user";

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
  static const allProperties = "$baseUrl/properties";
  static const legalTerms = "$serverUrl/api/legal/terms";
  static const legalPrivacyPolicy = "$serverUrl/api/legal/privacy-policy";
  static const legalAboutUs = "$serverUrl/api/pages/about-us";
  static const legalHelp = "$serverUrl/api/pages/help-support";
}
