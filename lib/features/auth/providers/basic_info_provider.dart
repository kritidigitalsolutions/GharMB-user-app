import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class BasicInfoState {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String password;
  final bool passwordVisible;
  final bool isLoading;
  final bool isLocationLoading; // GPS fetch ke liye separate loader

  const BasicInfoState({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.password = '',
    this.passwordVisible = false,
    this.isLoading = false,
    this.isLocationLoading = false,
  });

  BasicInfoState copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? password,
    bool? passwordVisible,
    bool? isLoading,
    bool? isLocationLoading,
  }) {
    return BasicInfoState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      password: password ?? this.password,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      isLoading: isLoading ?? this.isLoading,
      isLocationLoading: isLocationLoading ?? this.isLocationLoading,
    );
  }
}

class BasicInfoNotifier extends StateNotifier<BasicInfoState> {
  BasicInfoNotifier() : super(const BasicInfoState());

  void setFullName(String v) => state = state.copyWith(fullName: v);
  void setEmail(String v) => state = state.copyWith(email: v);
  void setPhone(String v) => state = state.copyWith(phone: v);
  void setAddress(String v) => state = state.copyWith(address: v);
  void setPassword(String v) => state = state.copyWith(password: v);
  void togglePasswordVisibility() =>
      state = state.copyWith(passwordVisible: !state.passwordVisible);

  bool get isFormValid =>
      state.fullName.trim().isNotEmpty &&
      state.email.trim().isNotEmpty &&
      state.phone.trim().length >= 10 &&
      state.address.trim().isNotEmpty;
  //   state.password.length >= 6;

  /// GPS se current location fetch karta hai
  Future<String?> fetchCurrentLocation() async {
    state = state.copyWith(isLocationLoading: true);
    try {
      // Permission check
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return 'Location permission denied';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return 'Location permission permanently denied';
      }

      // Position fetch
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Lat/lng → human-readable address
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        final String address = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.postalCode,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        state = state.copyWith(address: address, isLocationLoading: false);
        return null; // null = success, no error
      }
      state = state.copyWith(isLocationLoading: false);
      return 'Could not determine address';
    } catch (e) {
      state = state.copyWith(isLocationLoading: false);
      return e.toString();
    }
  }

  Future<void> submit(VoidCallback onSuccess) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false);
    onSuccess();
  }
}

final basicInfoProvider =
    StateNotifierProvider<BasicInfoNotifier, BasicInfoState>(
      (ref) => BasicInfoNotifier(),
    );
