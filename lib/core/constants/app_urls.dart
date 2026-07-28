class AppUrls {
  static const serverUrl = "http://192.168.1.18:5001";
  static const baseUrl = "$serverUrl/api";

  // --------------------------------------
  // Auth
  // ---------------------------------

  static const register = "$baseUrl/user/auth/register";
  static const login = "$baseUrl/user/auth/send-otp";
  static const verifyOtp = "$baseUrl/user/auth/verify-otp";
  static const addProperties = "$baseUrl/user/properties";
  static const dashBoardUrl = "$baseUrl/user/properties/my-dashboard";
  static const getProfile = "$baseUrl/users/me";
  static const agentRegister = "$baseUrl/user/users/register-agent";
  static const uploadFile = "$baseUrl/user/upload/multiple";
  static const developerRegister = "$baseUrl/user/users/register-developer";
  static const allProperties = "$baseUrl/properties";
  static const legalTerms = "$serverUrl/api/legal/terms";
  static const legalPrivacyPolicy = "$serverUrl/api/legal/privacy-policy";
  static const legalAboutUs = "$serverUrl/api/pages/about-us";
  static const legalHelp = "$serverUrl/api/pages/help-support";
  static const updateUser = "$baseUrl/users/update-me";
  static const allDeveloper = "$baseUrl/users/developers";
  static nearProperties(String? city) =>
      "$baseUrl/properties/near-me?city=$city";
  static const allNotifications = "$baseUrl/notifications";
  static readNotification({required String id}) =>
      "$baseUrl/notifications/$id/read";
  static const markAllNofication = "$baseUrl/notifications/mark-all-read";
  static const allNews = "$baseUrl/news";
  static categoryNews({required String id}) => "$baseUrl/news/category/$id";
  static const featuredNews = "$baseUrl/news/featured";
  static newsDetail({required String id}) => "$baseUrl/news/$id";
}
