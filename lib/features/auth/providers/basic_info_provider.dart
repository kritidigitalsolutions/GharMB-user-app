import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gharmb_app/core/data/exception/app_exception.dart';
import 'package:gharmb_app/features/auth/models/request/user_register_req_model.dart';
import 'package:gharmb_app/features/auth/repo/auth_repo.dart';

class BasicInfoState {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state_;
  final String pincode;
  final double latitude;
  final double longitude;
  final bool isLoading;
  final bool isLocationLoading;
  final String? errorMessage;

  const BasicInfoState({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.city = '',
    this.state_ = '',
    this.pincode = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.isLoading = false,
    this.isLocationLoading = false,
    this.errorMessage,
  });

  BasicInfoState copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? state_,
    String? pincode,
    double? latitude,
    double? longitude,
    bool? passwordVisible,
    bool? isLoading,
    bool? isLocationLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BasicInfoState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state_: state_ ?? this.state_,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,

      isLoading: isLoading ?? this.isLoading,
      isLocationLoading: isLocationLoading ?? this.isLocationLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class BasicInfoNotifier extends StateNotifier<BasicInfoState> {
  final AuthRepo _authRepo;

  BasicInfoNotifier({AuthRepo? authRepo})
    : _authRepo = authRepo ?? AuthRepo(),
      super(const BasicInfoState());

  void setFullName(String v) =>
      state = state.copyWith(fullName: v, clearError: true);
  void setEmail(String v) => state = state.copyWith(email: v, clearError: true);
  void setPhone(String v) => state = state.copyWith(phone: v, clearError: true);
  void setAddress(String v) =>
      state = state.copyWith(address: v, clearError: true);

  bool get isFormValid =>
      state.fullName.trim().isNotEmpty &&
      state.email.trim().isNotEmpty &&
      state.phone.trim().length >= 10 &&
      state.address.trim().isNotEmpty;

  /// GPS se current location fetch karta hai
  Future<void> fetchCurrentLocation() async {
    state = state.copyWith(isLocationLoading: true, clearError: true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(
            isLocationLoading: false,
            errorMessage: 'Location permission denied',
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isLocationLoading: false,
          errorMessage: 'Location permission permanently denied',
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

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
        ].where((e) => e!.isNotEmpty).join(', ');

        state = state.copyWith(
          address: address,
          city: place.locality ?? '',
          state_: place.administrativeArea ?? '',
          pincode: place.postalCode ?? '',
          latitude: position.latitude,
          longitude: position.longitude,
          isLocationLoading: false,
          clearError: true,
        );
        return;
      }
      state = state.copyWith(
        isLocationLoading: false,
        errorMessage: 'Could not determine address',
      );
    } catch (e) {
      state = state.copyWith(
        isLocationLoading: false,
        errorMessage: 'Could not fetch location. Please check GPS/permission.',
      );
    }
  }

  Future<void> submit(void Function() onSuccess) async {
    if (!isFormValid) {
      state = state.copyWith(
        errorMessage: 'Please fill all required fields correctly',
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    final model = UserRegisterReqModel(
      name: state.fullName.trim(),
      email: state.email.trim(),
      phone: state.phone.trim(),
      address: AddressReqModel(
        formattedAddress: state.address.trim(),
        city: state.city,
        state: state.state_,
        pincode: state.pincode,
      ),
      latitude: state.latitude,
      longitude: state.longitude,
      role: '', // required by API — adjust if role should be dynamic
    );

    try {
      await _authRepo.userRegister(model);
      state = state.copyWith(isLoading: false, clearError: true);
      onSuccess();
    } on AppException catch (e) {
      // e.message = real backend/network error text (no prefix)
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }
}

final basicInfoProvider =
    StateNotifierProvider<BasicInfoNotifier, BasicInfoState>(
      (ref) => BasicInfoNotifier(),
    );
