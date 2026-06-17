import 'package:gharmb_app/features/auth/views/all_set_page.dart';
import 'package:gharmb_app/features/auth/views/auth_screen.dart';
import 'package:gharmb_app/features/auth/views/basic_info_screen.dart';
import 'package:gharmb_app/features/auth/views/login_screen.dart';
import 'package:gharmb_app/features/auth/views/onboarding_role_page.dart';
import 'package:gharmb_app/features/auth/views/otp_verify_screen.dart';
import 'package:gharmb_app/features/auth/views/preferences_page.dart';
import 'package:gharmb_app/features/auth/views/role_selection_screen.dart';
import 'package:gharmb_app/features/auth/views/stay_update_page.dart';
import 'package:gharmb_app/features/commercial/views/commercial_lists_page.dart';
import 'package:gharmb_app/features/commercial/views/commercial_property_details_page.dart';
import 'package:gharmb_app/features/commercial/views/commercial_space_page.dart';
import 'package:gharmb_app/features/home/views/developer_details_page.dart';
import 'package:gharmb_app/features/home/views/notification_page.dart';
import 'package:gharmb_app/features/home/views/search_on_map.dart';
import 'package:gharmb_app/features/home/views/top_developers_Page.dart';
import 'package:gharmb_app/features/profile/views/dashboard_screen.dart';
import 'package:gharmb_app/features/profile/views/invite_friends_page.dart';
import 'package:gharmb_app/features/profile/views/loan_calculator_Page.dart';
import 'package:gharmb_app/features/profile/views/my_property_page.dart';
import 'package:gharmb_app/features/profile/views/my_property_view_Page.dart';
import 'package:gharmb_app/features/profile/views/profile_edit_page.dart';
import 'package:gharmb_app/features/profile/views/token/decision_page.dart';
import 'package:gharmb_app/features/profile/views/token/token_details.dart';
import 'package:gharmb_app/features/profile/views/token/token_requested_page.dart';
import 'package:gharmb_app/features/profile/views/unit_converter_page.dart';
import 'package:gharmb_app/features/project/views/project_details_page.dart';
import 'package:gharmb_app/features/property/views/add_property/basic_details_Page.dart';
import 'package:gharmb_app/features/property/views/add_property/photo_upload_screen.dart';
import 'package:gharmb_app/features/property/views/add_property/pricing_preference_Page.dart';
import 'package:gharmb_app/features/property/views/add_property/property_submitted_Page.dart';
import 'package:gharmb_app/features/property/views/add_property/review_submit_Page.dart';
import 'package:gharmb_app/features/property/views/show_property/book_with_token_page.dart';
import 'package:gharmb_app/features/property/views/show_property/property_details_page.dart';
import 'package:gharmb_app/features/property/views/add_property/property_list_type.dart';
import 'package:gharmb_app/features/property/views/show_property/property_listing_page.dart';
import 'package:gharmb_app/features/property/views/show_property/property_reserved_page.dart';
import 'package:gharmb_app/features/property/views/add_property/property_specs_page.dart';
import 'package:gharmb_app/features/real_state_news/views/news_details_page.dart';
import 'package:gharmb_app/features/real_state_news/views/news_list_page.dart';
import 'package:gharmb_app/features/quick_access/views/home_loan_page.dart';
import 'package:gharmb_app/features/quick_access/views/interlor_design_page.dart';
import 'package:gharmb_app/features/quick_access/views/legal_service_page.dart';
import 'package:gharmb_app/features/quick_access/views/packers_movers_page.dart';
import 'package:gharmb_app/features/splash/view/splash_screen.dart';
import 'package:gharmb_app/main.dart';
import 'package:go_router/go_router.dart';
import 'app_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppPage.splash,

    routes: [
      // ================= SPLASH =================
      GoRoute(
        name: AppPage.splashName,
        path: AppPage.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        name: AppPage.authName,
        path: AppPage.auth,
        builder: (context, state) => const AuthScreen(),
      ),

      // ================= LOGIN =================
      GoRoute(
        name: AppPage.loginName,
        path: AppPage.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // ================= BASIC INFO =================
      GoRoute(
        name: AppPage.basicInfoName,
        path: AppPage.basicInfo,
        builder: (context, state) => const BasicInfoScreen(),
      ),

      // ================= OTP =================
      GoRoute(
        name: AppPage.otpName,
        path: AppPage.otp,
        builder: (context, state) => const OtpVerificationScreen(),
      ),

      // ================= ROLE SELECTION =================
      GoRoute(
        name: AppPage.roleSelectionName,
        path: AppPage.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),

      // ================= Onboarding final =================
      GoRoute(
        name: AppPage.onboardingFinalName,
        path: AppPage.onboardingFinal,
        builder: (context, state) => const OnboardingGoalPage(),
      ),

      // ================= Preferences page =================
      GoRoute(
        name: AppPage.preferenceName,
        path: AppPage.preference,
        builder: (context, state) => const PreferencesPage(),
      ),

      // ================= All Set =================
      GoRoute(
        name: AppPage.allSetName,
        path: AppPage.allSet,
        builder: (context, state) => const AllSetPage(),
      ),

      // ================= Stay Update =================
      GoRoute(
        name: AppPage.stayUpdateName,
        path: AppPage.stayUpdate,
        builder: (context, state) => const StayUpdatedPage(),
      ),

      // ================= My Home screen =================
      GoRoute(
        name: AppPage.myHomeName,
        path: AppPage.myHome,
        builder: (context, state) {
          final index = state.extra as int?;

          return MyHomePage(initialIndex: index);
        },
      ),

      // ================= Property listing =================
      GoRoute(
        name: AppPage.propertyListName,
        path: AppPage.propertyList,
        builder: (context, state) => VerifiedListingsPage(),
      ),

      // ================= Property Details =================
      GoRoute(
        name: AppPage.propertyDetailsName,
        path: AppPage.propertyDetails,
        builder: (context, state) => PropertyDetailPage(),
      ),

      // ================= book by token page =================
      GoRoute(
        name: AppPage.bookByTokenName,
        path: AppPage.bookByToken,
        builder: (context, state) => BookWithTokenPage(),
      ),

      // ================= Property Reserved page =================
      GoRoute(
        name: AppPage.propertyReservedName,
        path: AppPage.propertyReserved,
        builder: (context, state) => PropertyReservedPage(),
      ),

      GoRoute(
        name: AppPage.listPropertyName,
        path: AppPage.listProperty,
        builder: (_, _) => const PropertyListType(),
      ),

      GoRoute(
        name: AppPage.basicDetailsName,
        path: AppPage.basicDetails,
        builder: (_, _) => const BasicDetailsPage(),
      ),

      GoRoute(
        name: AppPage.propertySpecsName,
        path: AppPage.propertySpecs,
        builder: (_, _) => const PropertySpecsPage(),
      ),

      GoRoute(
        name: AppPage.photosVideoName,
        path: AppPage.photosVideo,
        builder: (_, _) => const PhotosVideoPage(),
      ),

      GoRoute(
        name: AppPage.pricingPreferencesName,
        path: AppPage.pricingPreferences,
        builder: (_, _) => const PricingPreferencesPage(),
      ),

      GoRoute(
        name: AppPage.reviewSubmitName,
        path: AppPage.reviewSubmit,
        builder: (_, _) => const ReviewSubmitPage(),
      ),

      GoRoute(
        name: AppPage.propertySubmittedName,
        path: AppPage.propertySubmitted,
        builder: (_, _) => const PropertySubmittedPage(),
      ),

      // ============ dashboard ========================
      GoRoute(
        name: AppPage.dashboardName,
        path: AppPage.dashboard,
        builder: (_, _) => const DashboardPage(),
      ),

      GoRoute(
        name: AppPage.myPropertyDetailsName,
        path: AppPage.myPropertyDetails,
        builder: (_, _) => const MyPropertyDetailsPage(),
      ),

      // ============ token ========================
      GoRoute(
        name: AppPage.tokenRequestedName,
        path: AppPage.tokenRequested,
        builder: (_, _) => const TokenRequestsPage(),
      ),

      GoRoute(
        name: AppPage.tokenDetailsName,
        path: AppPage.tokenDetails,
        builder: (_, _) => const TokenDetailPage(),
      ),

      GoRoute(
        name: AppPage.decisionName,
        path: AppPage.decision,
        builder: (_, _) => const DecisionPage(),
      ),

      // ============ project details ========================
      GoRoute(
        name: AppPage.projectDetailName,
        path: AppPage.projectDetail,
        builder: (_, _) => const ProjectDetailPage(),
      ),

      // ============ Unit converter ========================
      GoRoute(
        name: AppPage.unitConverterName,
        path: AppPage.unitConverter,
        builder: (_, _) => const UnitConverterPage(),
      ),

      // ============ loan calculater ========================
      GoRoute(
        name: AppPage.loanCalculatorName,
        path: AppPage.loanCalculator,
        builder: (_, _) => const LoanCalculatorPage(),
      ),

      // ============ News list page ========================
      GoRoute(
        name: AppPage.newsListName,
        path: AppPage.newsList,
        builder: (_, _) => const RealEstateNewsPage(),
      ),

      // ============ News details Page ========================
      GoRoute(
        name: AppPage.newsDetailsName,
        path: AppPage.newsDetails,
        builder: (_, _) => const NewsDetailPage(),
      ),

      // ============ Unit converter ========================
      GoRoute(
        name: AppPage.homeLoanName,
        path: AppPage.homeLoan,
        builder: (_, _) => const HomeLoanPage(),
      ),

      // ============ loan calculater ========================
      GoRoute(
        name: AppPage.interiorDesignName,
        path: AppPage.interiorDesign,
        builder: (_, _) => const InteriorDesignPage(),
      ),

      // ============ News list page ========================
      GoRoute(
        name: AppPage.legalAdviseName,
        path: AppPage.legalAdvise,
        builder: (_, _) => const LegalServicesPage(),
      ),

      // ============ News details Page ========================
      GoRoute(
        name: AppPage.packersMoverName,
        path: AppPage.packersMover,
        builder: (_, _) => const PackersMoversPage(),
      ),

      // ============ News details Page ========================
      GoRoute(
        name: AppPage.topDevelopersName,
        path: AppPage.topDevelopers,
        builder: (_, _) => const TopDevelopersPage(),
      ),

      // ============ News details Page ========================
      GoRoute(
        name: AppPage.developerDetailName,
        path: AppPage.developerDetail,
        builder: (_, _) => const DeveloperDetailPage(),
      ),

      // ============ Map Page ========================
      GoRoute(
        name: AppPage.searchOnMapName,
        path: AppPage.searchOnMap,
        builder: (_, _) => const SearchOnMapPage(),
      ),

      // =================== commercial property ========================
      GoRoute(
        name: AppPage.commercialSpacesName,
        path: AppPage.commercialSpacesPath,
        builder: (context, state) => const CommercialSpacesPage(),
      ),

      GoRoute(
        name: AppPage.commercialListingsName,
        path: AppPage.commercialListingsPath,
        builder: (context, state) => const CommercialListingsPage(),
      ),

      GoRoute(
        name: AppPage.commercialPropertyDetailName,
        path: AppPage.commercialPropertyDetails,
        builder: (context, state) => const CommercialPropertyDetailsPage(),
      ),

      // =================== Profile Edit ========================
      GoRoute(
        name: AppPage.profileEditName,
        path: AppPage.profileEdit,
        builder: (context, state) => const ProfileEditPage(),
      ),

      // =================== My Property ========================
      GoRoute(
        name: AppPage.myPropertyName,
        path: AppPage.myProperty,
        builder: (context, state) => const MyPropertyPage(),
      ),

      // =================== Invite friends ========================
      GoRoute(
        name: AppPage.inviteFriendsName,
        path: AppPage.inviteFriends,
        builder: (context, state) => const InviteFriendsPage(),
      ),

      // =================== notification ========================
      GoRoute(
        name: AppPage.notificationName,
        path: AppPage.notification,
        builder: (context, state) => const NotificationsPage(),
      ),
    ],
  );
}
