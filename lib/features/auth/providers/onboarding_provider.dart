import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

// ─── Step 1: Goal Selection ───────────────────────────────────────────────────

enum PropertyGoal { buy, rent, commercial, sell, exploreProjects }

class OnboardingGoalNotifier extends StateNotifier<Set<PropertyGoal>> {
  OnboardingGoalNotifier() : super({});

  void toggle(PropertyGoal goal) {
    final updated = Set<PropertyGoal>.from(state);
    updated.contains(goal) ? updated.remove(goal) : updated.add(goal);
    state = updated;
  }

  bool isSelected(PropertyGoal goal) => state.contains(goal);
}

final onboardingGoalProvider =
    StateNotifierProvider<OnboardingGoalNotifier, Set<PropertyGoal>>(
      (_) => OnboardingGoalNotifier(),
    );

// ─── Step 2: Preferences ─────────────────────────────────────────────────────

enum PropertyType { apartment, villa, house, plot, penthouse, builderFloor }

enum BedroomCount { one, two, three, fourPlus }

class PreferencesState {
  final Set<PropertyType> propertyTypes;
  final RangeValues budgetRange;
  final String city;
  final Set<BedroomCount> bedrooms;

  const PreferencesState({
    this.propertyTypes = const {},
    this.budgetRange = const RangeValues(10, 500),
    this.city = '',
    this.bedrooms = const {},
  });

  PreferencesState copyWith({
    Set<PropertyType>? propertyTypes,
    RangeValues? budgetRange,
    String? city,
    Set<BedroomCount>? bedrooms,
  }) {
    return PreferencesState(
      propertyTypes: propertyTypes ?? this.propertyTypes,
      budgetRange: budgetRange ?? this.budgetRange,
      city: city ?? this.city,
      bedrooms: bedrooms ?? this.bedrooms,
    );
  }

  String get budgetLabel {
    String fmt(double v) =>
        v >= 100 ? '₹${(v / 100).toStringAsFixed(0)}Cr' : '₹${v.toInt()}L';
    return '${fmt(budgetRange.start)} – ${fmt(budgetRange.end)}';
  }

  String get propertyTypesLabel => propertyTypes.map((e) => e.label).join(', ');

  String get bedroomsLabel => bedrooms.map((e) => e.label).join(', ');
}

class PreferencesNotifier extends StateNotifier<PreferencesState> {
  PreferencesNotifier() : super(const PreferencesState());

  void togglePropertyType(PropertyType type) {
    final updated = Set<PropertyType>.from(state.propertyTypes);
    updated.contains(type) ? updated.remove(type) : updated.add(type);
    state = state.copyWith(propertyTypes: updated);
  }

  void setBudgetRange(RangeValues range) =>
      state = state.copyWith(budgetRange: range);

  void setCity(String city) => state = state.copyWith(city: city);

  void toggleBedroom(BedroomCount b) {
    final updated = Set<BedroomCount>.from(state.bedrooms);
    updated.contains(b) ? updated.remove(b) : updated.add(b);
    state = state.copyWith(bedrooms: updated);
  }
}

final preferencesProvider =
    StateNotifierProvider<PreferencesNotifier, PreferencesState>(
      (_) => PreferencesNotifier(),
    );

// ─── Extensions ──────────────────────────────────────────────────────────────

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

class NotificationPrefsState {
  final bool notificationPreferences;
  final bool newListingAlerts;
  final bool tokenAndBooking;
  final bool importantUpdates;

  const NotificationPrefsState({
    this.notificationPreferences = true,
    this.newListingAlerts = false,
    this.tokenAndBooking = true,
    this.importantUpdates = true,
  });

  NotificationPrefsState copyWith({
    bool? notificationPreferences,
    bool? newListingAlerts,
    bool? tokenAndBooking,
    bool? importantUpdates,
  }) {
    return NotificationPrefsState(
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
      newListingAlerts: newListingAlerts ?? this.newListingAlerts,
      tokenAndBooking: tokenAndBooking ?? this.tokenAndBooking,
      importantUpdates: importantUpdates ?? this.importantUpdates,
    );
  }
}

class NotificationPrefsNotifier extends StateNotifier<NotificationPrefsState> {
  NotificationPrefsNotifier() : super(const NotificationPrefsState());

  void toggle(String key) {
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
}

final notificationPrefsProvider =
    StateNotifierProvider<NotificationPrefsNotifier, NotificationPrefsState>(
      (_) => NotificationPrefsNotifier(),
    );
