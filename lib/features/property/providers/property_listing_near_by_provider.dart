import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gharmb_app/core/utils/location_service.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';
import 'package:gharmb_app/features/property/repo/property_repo.dart';

// ──────────── Location Model ────────────

class AppLocation {
  final String city;
  final String state;
  final String displayName;
  final double lat;
  final double lng;
  final bool isGps;

  const AppLocation({
    required this.city,
    this.state = '',
    required this.displayName,
    required this.lat,
    required this.lng,
    this.isGps = false,
  });

  AppLocation copyWith({
    String? city,
    String? state,
    String? displayName,
    double? lat,
    double? lng,
    bool? isGps,
  }) {
    return AppLocation(
      city: city ?? this.city,
      state: state ?? this.state,
      displayName: displayName ?? this.displayName,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      isGps: isGps ?? this.isGps,
    );
  }
}

const kDefaultLocation = AppLocation(
  city: 'Noida',
  state: 'UP',
  displayName: 'Noida, UP',
  lat: 28.5355,
  lng: 77.3910,
  isGps: false,
);

// ──────────── Popular Cities Data ────────────

class CityPreset {
  final String name;
  final String state;
  final double lat;
  final double lng;

  const CityPreset({
    required this.name,
    required this.state,
    required this.lat,
    required this.lng,
  });

  String get displayName => state.isNotEmpty ? '$name, $state' : name;
}

const kPopularCities = [
  CityPreset(name: 'Noida', state: 'UP', lat: 28.5355, lng: 77.3910),
  CityPreset(name: 'Greater Noida', state: 'UP', lat: 28.4744, lng: 77.5040),
  CityPreset(name: 'Delhi', state: 'DL', lat: 28.6139, lng: 77.2090),
  CityPreset(name: 'Gurgaon', state: 'HR', lat: 28.4595, lng: 77.0266),
  CityPreset(name: 'Ghaziabad', state: 'UP', lat: 28.6692, lng: 77.4538),
  CityPreset(name: 'Faridabad', state: 'HR', lat: 28.4089, lng: 77.3178),
  CityPreset(name: 'Mumbai', state: 'MH', lat: 19.0760, lng: 72.8777),
  CityPreset(name: 'Bengaluru', state: 'KA', lat: 12.9716, lng: 77.5946),
  CityPreset(name: 'Hyderabad', state: 'TS', lat: 17.3850, lng: 78.4867),
  CityPreset(name: 'Pune', state: 'MH', lat: 18.5204, lng: 73.8567),
  CityPreset(name: 'Kolkata', state: 'WB', lat: 22.5726, lng: 88.3639),
  CityPreset(name: 'Jaipur', state: 'RJ', lat: 26.9124, lng: 75.7873),
  CityPreset(name: 'Lucknow', state: 'UP', lat: 26.8467, lng: 80.9462),
  CityPreset(name: 'Chandigarh', state: 'CH', lat: 30.7333, lng: 76.7794),
  CityPreset(name: 'Ahmedabad', state: 'GJ', lat: 23.0225, lng: 72.5714),
  CityPreset(name: 'Chennai', state: 'TN', lat: 13.0827, lng: 80.2707),
];

// ──────────── Providers ────────────

final propertyRepoProvider = Provider<PropertyRepo>((ref) {
  return PropertyRepo();
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// Location State Notifier
class UserLocationNotifier extends StateNotifier<AppLocation> {
  final Ref _ref;
  UserLocationNotifier(this._ref) : super(kDefaultLocation) {
    detectLocationSilently();
  }

  Future<void> detectLocationSilently() async {
    try {
      final locationService = _ref.read(locationServiceProvider);
      final position = await locationService.determinePosition();
      await _updateFromPosition(position);
    } catch (_) {
      // Keep default location if permission denied/disabled
    }
  }

  Future<bool> detectLocationFromGps() async {
    try {
      final locationService = _ref.read(locationServiceProvider);
      final position = await locationService.determinePosition();
      await _updateFromPosition(position);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _updateFromPosition(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality?.isNotEmpty == true
            ? place.locality!
            : (place.subAdministrativeArea?.isNotEmpty == true
                  ? place.subAdministrativeArea!
                  : 'Current Location');
        final adminArea = place.administrativeArea ?? '';
        final stateShort = adminArea.length > 3
            ? adminArea.substring(0, 2).toUpperCase()
            : adminArea;
        final displayName = stateShort.isNotEmpty ? '$city, $stateShort' : city;

        state = AppLocation(
          city: city,
          state: stateShort,
          displayName: displayName,
          lat: position.latitude,
          lng: position.longitude,
          isGps: true,
        );
      } else {
        state = AppLocation(
          city: 'Current Location',
          displayName: 'Current Location',
          lat: position.latitude,
          lng: position.longitude,
          isGps: true,
        );
      }
    } catch (_) {
      state = AppLocation(
        city: 'Current Location',
        displayName: 'Current Location',
        lat: position.latitude,
        lng: position.longitude,
        isGps: true,
      );
    }
  }

  Future<void> selectCity(CityPreset preset) async {
    state = AppLocation(
      city: preset.name,
      state: preset.state,
      displayName: preset.displayName,
      lat: preset.lat,
      lng: preset.lng,
      isGps: false,
    );
  }

  Future<void> searchAndSelectCustomLocation(String query) async {
    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final placemarks = await placemarkFromCoordinates(
          loc.latitude,
          loc.longitude,
        );
        String cityName = query;
        String stateName = '';
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          cityName = p.locality?.isNotEmpty == true
              ? p.locality!
              : (p.subAdministrativeArea ?? query);
          stateName = p.administrativeArea ?? '';
        }
        state = AppLocation(
          city: cityName,
          state: stateName,
          displayName: stateName.isNotEmpty
              ? '$cityName, $stateName'
              : cityName,
          lat: loc.latitude,
          lng: loc.longitude,
          isGps: false,
        );
      } else {
        state = AppLocation(
          city: query,
          displayName: query,
          lat: 28.5355,
          lng: 77.3910,
          isGps: false,
        );
      }
    } catch (_) {
      state = AppLocation(
        city: query,
        displayName: query,
        lat: 28.5355,
        lng: 77.3910,
        isGps: false,
      );
    }
  }
}

final userLocationProvider =
    StateNotifierProvider<UserLocationNotifier, AppLocation>((ref) {
      return UserLocationNotifier(ref);
    });

final userCityProvider = FutureProvider<String>((ref) async {
  return ref.watch(userLocationProvider).city;
});

final userPositionProvider = FutureProvider<Position>((ref) async {
  final location = ref.watch(userLocationProvider);
  return Position(
    longitude: location.lng,
    latitude: location.lat,
    timestamp: DateTime.now(),
    accuracy: 10.0,
    altitude: 0.0,
    altitudeAccuracy: 0.0,
    heading: 0.0,
    headingAccuracy: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  );
});

// ──────────── Notifier ────────────

class NearPropertiesNotifier extends AsyncNotifier<NearPropertiesResponse?> {
  double radius = 50;
  String radiusUnit = 'km';

  @override
  Future<NearPropertiesResponse?> build() async {
    final location = ref.watch(userLocationProvider);
    final repo = ref.read(propertyRepoProvider);

    try {
      final res = await repo.nearAllProperties(
        city: location.city.isNotEmpty && location.city != 'Current Location'
            ? location.city
            : null,
        lat: location.lat,
        lng: location.lng,
        radius: radius,
        radiusUnit: radiusUnit,
      );
      return res;
    } catch (e) {
      return null;
    }
  }

  Future<void> refresh({double? radius, String? radiusUnit}) async {
    if (radius != null) this.radius = radius;
    if (radiusUnit != null) this.radiusUnit = radiusUnit;
    ref.invalidateSelf();
  }
}

final nearPropertiesProvider =
    AsyncNotifierProvider<NearPropertiesNotifier, NearPropertiesResponse?>(
      () => NearPropertiesNotifier(),
    );
