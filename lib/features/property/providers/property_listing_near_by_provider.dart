// providers/near_properties_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gharmb_app/core/utils/location_service.dart';

import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';
import 'package:gharmb_app/features/property/repo/property_repo.dart';

// 1. Repo provider
final propertyRepoProvider = Provider<PropertyRepo>((ref) {
  return PropertyRepo();
});

// 2. Location service provider
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// 3. Raw device position
final userPositionProvider = FutureProvider<Position>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  return locationService.determinePosition();
});

// 4. Reverse-geocode position -> city name
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

// 5. AsyncNotifier that fetches near properties based on detected city
class NearPropertiesNotifier extends AsyncNotifier<NearPropertiesResponse?> {
  @override
  Future<NearPropertiesResponse?> build() async {
    final city = await ref.watch(userCityProvider.future);
    return _fetch(city);
  }

  Future<NearPropertiesResponse?> _fetch(String city) async {
    final repo = ref.read(propertyRepoProvider);
    return repo.nearAllProperties(city: city.isEmpty ? null : city);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final city = await ref.read(userCityProvider.future);
      return _fetch(city);
    });
  }
}

final nearPropertiesProvider =
    AsyncNotifierProvider<NearPropertiesNotifier, NearPropertiesResponse?>(
      () => NearPropertiesNotifier(),
    );
