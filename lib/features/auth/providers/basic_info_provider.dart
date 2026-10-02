import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gharmb_app/core/data/exception/app_exception.dart';
import 'package:gharmb_app/core/utils/local_storage/auth_storage.dart';
import 'package:gharmb_app/features/auth/models/request/user_register_req_model.dart';
import 'package:gharmb_app/features/auth/models/response/auth_response_model.dart';
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

  void prefillFromGoogle({
    String? name,
    String? email,
    String? phone,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    state = state.copyWith(
      fullName: (name != null && name.isNotEmpty) ? name : state.fullName,
      email: (email != null && email.isNotEmpty) ? email : state.email,
      phone: (phone != null && phone.isNotEmpty) ? phone : state.phone,
      address: (address != null && address.isNotEmpty) ? address : state.address,
      latitude: latitude ?? state.latitude,
      longitude: longitude ?? state.longitude,
      clearError: true,
    );
  }

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
        ].where((e) => e != null && e.isNotEmpty).join(', ');

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

  Future<void> submit({
    required Function(String nextScreen, String? otp) onSuccess,
  }) async {
    if (state.fullName.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter your full name');
      return;
    }
    if (state.email.trim().isEmpty || !state.email.contains('@')) {
      state = state.copyWith(errorMessage: 'Please enter a valid email address');
      return;
    }
    if (state.phone.trim().replaceAll(RegExp(r'\D'), '').length < 10) {
      state = state.copyWith(errorMessage: 'Please enter a valid 10-digit phone number');
      return;
    }
    if (state.address.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter your address or fetch via GPS');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    final model = UserRegisterReqModel(
      name: state.fullName.trim(),
      email: state.email.trim(),
      phone: state.phone.trim().replaceAll(RegExp(r'\D'), ''),
      address: AddressReqModel(
        formattedAddress: state.address.trim(),
        city: state.city.isNotEmpty ? state.city : null,
        state: state.state_.isNotEmpty ? state.state_ : null,
        pincode: state.pincode.isNotEmpty ? state.pincode : null,
      ),
      latitude: state.latitude != 0.0 ? state.latitude : null,
      longitude: state.longitude != 0.0 ? state.longitude : null,
      role: 'user', // Default role
    );

    try {
      final token = await LocalStorageService.getToken();
      AuthResponseModel authRes;

      if (token != null && token.isNotEmpty) {
        // Authenticated Google user completing basic info
        authRes = await _authRepo.submitBasicInfo(model);
      } else {
        final res = await _authRepo.userRegister(model);
        authRes = AuthResponseModel.fromJson(res);
      }

      if (authRes.token != null && authRes.token!.isNotEmpty) {
        await LocalStorageService.saveAuthResponse(authRes);
      }

      state = state.copyWith(isLoading: false, clearError: true);

      final nextScreen = authRes.nextScreen ??
          (token != null && token.isNotEmpty ? 'role_selection' : 'otp');

      onSuccess(nextScreen, authRes.otp);
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
    StateNotifierProvider.autoDispose<BasicInfoNotifier, BasicInfoState>(
      (ref) => BasicInfoNotifier(),
    );

