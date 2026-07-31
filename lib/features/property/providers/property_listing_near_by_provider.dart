import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gharmb_app/core/utils/location_service.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';
import 'package:gharmb_app/features/property/repo/property_repo.dart';

// ──────────── Providers ────────────

final propertyRepoProvider = Provider<PropertyRepo>((ref) {
  return PropertyRepo();
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final userPositionProvider = FutureProvider<Position>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  return locationService.determinePosition();
});

final userCityProvider = FutureProvider<String>((ref) async {
  final position = await ref.watch(userPositionProvider.future);
  final placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );
  if (placemarks.isEmpty) return '';
  final place = placemarks.first;
  return place.locality?.isNotEmpty == true
      ? place.locality!
      : (place.subAdministrativeArea ?? '');
});

// ──────────── Notifier ────────────

class NearPropertiesNotifier extends AsyncNotifier<NearPropertiesResponse?> {
  // Default radius and unit – these can be changed per call
  double radius = 50;
  String radiusUnit = 'km';

  @override
  Future<NearPropertiesResponse?> build() async {
    return await _fetch(); refresh();
  }

  // Main fetch with optional radius/unit override
  Future<NearPropertiesResponse?> _fetch({
    double? overrideRadius,
    String? overrideUnit,
  }) async {
    final position = await ref.watch(userPositionProvider.future);
    final lat = position.latitude;
    final lng = position.longitude;

    final city = await ref.watch(userCityProvider.future);

    final repo = ref.read(propertyRepoProvider);
    return repo.nearAllProperties(
      city: city.isNotEmpty ? city : null,
      lat: lat,
      lng: lng,
      radius: overrideRadius ?? radius,
      radiusUnit: overrideUnit ?? radiusUnit,
    );
  }

  // Public refresh – can optionally accept new radius/unit
  Future<void> refresh({
    double? radius,
    String? radiusUnit,
  }) async {
    this.radius = radius ?? this.radius;
    this.radiusUnit = radiusUnit ?? this.radiusUnit;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
          () => _fetch(
        overrideRadius: this.radius,
        overrideUnit: this.radiusUnit,
      ),
    );
  }
}

// ──────────── Provider ────────────

final nearPropertiesProvider =
AsyncNotifierProvider<NearPropertiesNotifier, NearPropertiesResponse?>(
      () => NearPropertiesNotifier(),
);