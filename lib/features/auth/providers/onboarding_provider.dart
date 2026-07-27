import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/data/exception/app_exception.dart';
import 'package:gharmb_app/core/utils/local_storage/auth_storage.dart';
import 'package:gharmb_app/features/auth/models/request/user_register_req_model.dart';
import 'package:gharmb_app/features/auth/repo/auth_repo.dart';

// ─── Enums ───────────────────────────────────────────────────────────────────

enum UserRole {
  buyer,
  tenant,
  propertyOwner,
  realEstateAgent,
  builderDeveloper,
}

enum PropertyGoal { buy, rent, commercial, sell, exploreProjects }

enum PropertyType { apartment, villa, house, plot, penthouse, builderFloor }

enum BedroomCount { one, two, three, fourPlus }

// ─── Extensions: labels + icons + colors (UI ke liye) ───────────────────────

extension UserRoleExtension on UserRole {
  String get title => switch (this) {
    UserRole.buyer => 'Buyer',
    UserRole.tenant => 'Tenant',
    UserRole.propertyOwner => 'Property Owner',
    UserRole.realEstateAgent => 'Real Estate Agent',
    UserRole.builderDeveloper => 'Builder / Developer',
  };

  String get subtitle => switch (this) {
    UserRole.buyer => 'I want to buy a property',
    UserRole.tenant => 'I want to rent a property',
    UserRole.propertyOwner => 'I want to list my property',
    UserRole.realEstateAgent => 'I help clients find properties',
    UserRole.builderDeveloper => 'I am a builder or developer',
  };

  IconData get icon => switch (this) {
    UserRole.buyer => Icons.person_outline,
    UserRole.tenant => Icons.key_outlined,
    UserRole.propertyOwner => Icons.home_outlined,
    UserRole.realEstateAgent => Icons.badge_outlined,
    UserRole.builderDeveloper => Icons.construction_outlined,
  };

  Color get color => switch (this) {
    UserRole.buyer => AppColors.button,
    UserRole.tenant => AppColors.error,
    UserRole.propertyOwner => AppColors.yellow,
    UserRole.realEstateAgent => AppColors.blue,
    UserRole.builderDeveloper => AppColors.success,
  };
}

extension PropertyTypeLabel on PropertyType {
  String get label => switch (this) {
    PropertyType.apartment => 'Apartment',
    PropertyType.villa => 'Villa',
    PropertyType.house => 'House',
    PropertyType.plot => 'Plot',
    PropertyType.penthouse => 'Penthouse',
    PropertyType.builderFloor => 'Builder Floor',
  };
}

extension BedroomLabel on BedroomCount {
  String get label => switch (this) {
    BedroomCount.one => '1 BHK',
    BedroomCount.two => '2 BHK',
    BedroomCount.three => '3 BHK',
    BedroomCount.fourPlus => '4+ BHK',
  };
}

// ─── Extensions: API values ──────────────────────────────────────────────────

extension UserRoleValue on UserRole {
  String get value => switch (this) {
    UserRole.buyer => 'buyer',
    UserRole.tenant => 'tenant',
    UserRole.propertyOwner => 'propertyOwner',
    UserRole.realEstateAgent => 'realEstateAgent',
    UserRole.builderDeveloper => 'builderDeveloper',
  };
}

extension PropertyGoalValue on PropertyGoal {
  String get value => switch (this) {
    PropertyGoal.buy => 'buy',
    PropertyGoal.rent => 'rent',
    PropertyGoal.commercial => 'commercial',
    PropertyGoal.sell => 'sell',
    PropertyGoal.exploreProjects => 'exploreProjects',
  };
}

extension PropertyTypeValue on PropertyType {
  String get value => switch (this) {
    PropertyType.apartment => 'apartment',
    PropertyType.villa => 'villa',
    PropertyType.house => 'house',
    PropertyType.plot => 'plot',
    PropertyType.penthouse => 'penthouse',
    PropertyType.builderFloor => 'builderFloor',
  };
}

extension BedroomValue on BedroomCount {
  String get value => switch (this) {
    BedroomCount.one => '1',
    BedroomCount.two => '2',
    BedroomCount.three => '3',
    BedroomCount.fourPlus => '4+',
  };
}

String mapRoleForApi(String selectedRole) {
  switch (selectedRole) {
    case "propertyOwner":
      return "owner";

    case "propertyBuyer":
      return "buyer";

    case "tenant":
      return "tenant";

    case "agent":
      return "agent";

    case "builder":
      return "builder";

    default:
      return "buyer";
  }
}

// ─── Single combined state ───────────────────────────────────────────────────

class OnboardingState {
  // Role
  final UserRole? selectedRole;

  // Goals
  final Set<PropertyGoal> goals;

  // Preferences
  final Set<PropertyType> propertyTypes;
  final RangeValues budgetRange;
  final String city;
  final Set<BedroomCount> bedrooms;

  // Notifications
  final bool notificationPreferences;
  final bool newListingAlerts;
  final bool tokenAndBooking;
  final bool importantUpdates;

  // Submit status
  final bool isLoading;
  final String? errorMessage;

  const OnboardingState({
    this.selectedRole,
    this.goals = const {},
    this.propertyTypes = const {},
    this.budgetRange = const RangeValues(10, 500),
    this.city = '',
    this.bedrooms = const {},
    this.notificationPreferences = true,
    this.newListingAlerts = false,
    this.tokenAndBooking = true,
    this.importantUpdates = true,
    this.isLoading = false,
    this.errorMessage,
  });

  OnboardingState copyWith({
    UserRole? selectedRole,
    Set<PropertyGoal>? goals,
    Set<PropertyType>? propertyTypes,
    RangeValues? budgetRange,
    String? city,
    Set<BedroomCount>? bedrooms,
    bool? notificationPreferences,
    bool? newListingAlerts,
    bool? tokenAndBooking,
    bool? importantUpdates,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OnboardingState(
      selectedRole: selectedRole ?? this.selectedRole,
      goals: goals ?? this.goals,
      propertyTypes: propertyTypes ?? this.propertyTypes,
      budgetRange: budgetRange ?? this.budgetRange,
      city: city ?? this.city,
      bedrooms: bedrooms ?? this.bedrooms,
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
      newListingAlerts: newListingAlerts ?? this.newListingAlerts,
      tokenAndBooking: tokenAndBooking ?? this.tokenAndBooking,
      importantUpdates: importantUpdates ?? this.importantUpdates,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  // ── Derived labels for UI ──
  String get budgetLabel {
    String fmt(double v) =>
        v >= 100 ? '₹${(v / 100).toStringAsFixed(0)}Cr' : '₹${v.toInt()}L';
    return '${fmt(budgetRange.start)} – ${fmt(budgetRange.end)}';
  }

  String get propertyTypesLabel => propertyTypes.map((e) => e.label).join(', ');

  String get bedroomsLabel => bedrooms.map((e) => e.label).join(', ');

  bool get isRoleValid => selectedRole != null;
  bool get isGoalsValid => goals.isNotEmpty;
  bool get isPreferencesValid =>
      propertyTypes.isNotEmpty && city.trim().isNotEmpty;
}

// ─── Single notifier ─────────────────────────────────────────────────────────

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final AuthRepo _authRepo;

  OnboardingNotifier({AuthRepo? authRepo})
    : _authRepo = authRepo ?? AuthRepo(),
      super(const OnboardingState());

  // Role
  void selectRole(UserRole role) =>
      state = state.copyWith(selectedRole: role, clearError: true);

  // Goals
  void toggleGoal(PropertyGoal goal) {
    final updated = Set<PropertyGoal>.from(state.goals);
    updated.contains(goal) ? updated.remove(goal) : updated.add(goal);
    state = state.copyWith(goals: updated, clearError: true);
  }

  bool isGoalSelected(PropertyGoal goal) => state.goals.contains(goal);

  // Preferences
  void togglePropertyType(PropertyType type) {
    final updated = Set<PropertyType>.from(state.propertyTypes);
    updated.contains(type) ? updated.remove(type) : updated.add(type);
    state = state.copyWith(propertyTypes: updated, clearError: true);
  }

  void setBudgetRange(RangeValues range) =>
      state = state.copyWith(budgetRange: range);

  void setCity(String city) =>
      state = state.copyWith(city: city, clearError: true);

  void toggleBedroom(BedroomCount b) {
    final updated = Set<BedroomCount>.from(state.bedrooms);
    updated.contains(b) ? updated.remove(b) : updated.add(b);
    state = state.copyWith(bedrooms: updated);
  }

  // Notifications
  void toggleNotification(String key) {
    state = switch (key) {
      'notificationPreferences' => state.copyWith(
        notificationPreferences: !state.notificationPreferences,
      ),
      'newListingAlerts' => state.copyWith(
        newListingAlerts: !state.newListingAlerts,
      ),
      'tokenAndBooking' => state.copyWith(
        tokenAndBooking: !state.tokenAndBooking,
      ),
      'importantUpdates' => state.copyWith(
        importantUpdates: !state.importantUpdates,
      ),
      _ => state,
    };
  }

  // ── Submit: sab kuch ek hi PATCH call mein ──
  Future<bool> submitOnboarding(VoidCallback onSuccess) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final model = UserRegisterReqModel(
      role: mapRoleForApi(state.selectedRole?.value ?? ''),
      intents: state.goals.map((g) => g.value).toList(),
      preferences: PreferencesReqModel(
        propertyTypes: state.propertyTypes.map((e) => e.value).toList(),
        minBudget: state.budgetRange.start,
        maxBudget: state.budgetRange.end,
        preferredCities: state.city.isNotEmpty ? [state.city] : null,
        bedrooms: state.bedrooms.map((e) => e.value).toList(),
      ),
      notificationSettings: NotificationSettingsReqModel(
        priceDropAlerts: state.notificationPreferences,
        newListingAlerts: state.newListingAlerts,
        bookingUpdates: state.tokenAndBooking,
        platformUpdates: state.importantUpdates,
      ),
    );

    try {
      await _authRepo.completedRegister(model);

      // Persist onboarding completion so SplashScreen reads fresh state
      await LocalStorageService.updateOnboardingStatus(true);

      state = state.copyWith(isLoading: false, clearError: true);

      onSuccess();
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
      (_) => OnboardingNotifier(),
    );
