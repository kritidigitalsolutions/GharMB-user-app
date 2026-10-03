// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';
import 'package:gharmb_app/features/property/models/visit_request_model.dart';
import 'package:gharmb_app/features/property/repo/visit_request_repo.dart';
import 'package:gharmb_app/shared/snakebar/custom_snakebar.dart';

// ─── Repository Provider ───────────────────────────────────────────────────────
final visitRequestRepoProvider = Provider<VisitRequestRepo>((ref) {
  return VisitRequestRepo();
});

// ─── Received Visit Requests Provider (Owner view) ─────────────────────────────
final receivedVisitRequestsProvider =
    FutureProvider.family<VisitRequestListData?, ({String status, int page})>((
      ref,
      params,
    ) async {
      final repo = ref.watch(visitRequestRepoProvider);
      final res = await repo.getReceivedVisitRequests(
        status: params.status,
        page: params.page,
        limit: 30,
      );
      return res?.data;
    });

// ─── My Booked Visit Requests Provider (User view) ─────────────────────────────
final myVisitRequestsProvider =
    FutureProvider.family<VisitRequestListData?, ({String status, int page})>((
      ref,
      params,
    ) async {
      final repo = ref.watch(visitRequestRepoProvider);
      final res = await repo.getMyVisitRequests(
        status: params.status,
        page: params.page,
        limit: 30,
      );
      return res?.data;
    });

// ─── Schedule Visit State & Notifier (Bottom Sheet) ───────────────────────────
class ScheduleVisitState {
  final DateTime? selectedDate;
  final String? selectedTimeSlot;
  final String notes;
  final bool isLoading;
  final String? error;
  final VisitRequestModel? createdVisit;

  const ScheduleVisitState({
    this.selectedDate,
    this.selectedTimeSlot,
    this.notes = '',
    this.isLoading = false,
    this.error,
    this.createdVisit,
  });

  ScheduleVisitState copyWith({
    DateTime? selectedDate,
    String? selectedTimeSlot,
    String? notes,
    bool? isLoading,
    String? error,
    VisitRequestModel? createdVisit,
    bool clearError = false,
  }) {
    return ScheduleVisitState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      createdVisit: createdVisit ?? this.createdVisit,
    );
  }
}

class ScheduleVisitNotifier extends StateNotifier<ScheduleVisitState> {
  final VisitRequestRepo _repo;
  final Ref _ref;

  ScheduleVisitNotifier(this._repo, this._ref)
    : super(
        ScheduleVisitState(
          selectedDate: DateTime.now().add(const Duration(days: 1)),
          selectedTimeSlot: '11:00 AM - 12:00 PM',
        ),
      );

  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: date, clearError: true);
  }

  void setTimeSlot(String slot) {
    state = state.copyWith(selectedTimeSlot: slot, clearError: true);
  }

  void setNotes(String note) {
    state = state.copyWith(notes: note);
  }

  void reset() {
    state = ScheduleVisitState(
      selectedDate: DateTime.now().add(const Duration(days: 1)),
      selectedTimeSlot: '11:00 AM - 12:00 PM',
    );
  }

  Future<bool> submitVisitRequest({
    required BuildContext context,
    required String propertyId,
  }) async {
    if (state.selectedDate == null) {
      state = state.copyWith(error: 'Please select a preferred visit date.');
      return false;
    }

    if (state.selectedTimeSlot == null || state.selectedTimeSlot!.isEmpty) {
      state = state.copyWith(error: 'Please select a preferred time slot.');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final formattedDate =
          "${state.selectedDate!.year.toString().padLeft(4, '0')}-${state.selectedDate!.month.toString().padLeft(2, '0')}-${state.selectedDate!.day.toString().padLeft(2, '0')}";

      final payload = ScheduleVisitPayload(
        propertyId: propertyId,
        visitDate: formattedDate,
        visitTime: state.selectedTimeSlot!,
        notes: state.notes,
      );

      final res = await _repo.scheduleVisit(payload: payload);

      state = state.copyWith(isLoading: false, createdVisit: res?.visitRequest);

      // Invalidate visits providers so lists refresh automatically
      _ref.invalidate(myVisitRequestsProvider);
      _ref.invalidate(receivedVisitRequestsProvider);

      return true;
    } catch (e) {
      final msg = e.toString().replaceAll('Exception:', '').trim();
      state = state.copyWith(isLoading: false, error: msg);
      return false;
    }
  }
}

final scheduleVisitProvider =
    StateNotifierProvider.autoDispose<
      ScheduleVisitNotifier,
      ScheduleVisitState
    >((ref) {
      return ScheduleVisitNotifier(ref.watch(visitRequestRepoProvider), ref);
    });

// ─── Owner Decision Notifier (Accept / Reject) ─────────────────────────────────
class OwnerDecisionState {
  final Set<String> loadingIds;
  final String? error;

  const OwnerDecisionState({this.loadingIds = const {}, this.error});

  bool isLoading(String id) => loadingIds.contains(id);

  OwnerDecisionState copyWith({Set<String>? loadingIds, String? error}) {
    return OwnerDecisionState(
      loadingIds: loadingIds ?? this.loadingIds,
      error: error,
    );
  }
}

class OwnerDecisionNotifier extends StateNotifier<OwnerDecisionState> {
  final VisitRequestRepo _repo;
  final Ref _ref;

  OwnerDecisionNotifier(this._repo, this._ref)
    : super(const OwnerDecisionState());

  Future<bool> acceptRequest({
    required BuildContext context,
    required String requestId,
    String? message,
  }) async {
    final nextLoading = Set<String>.from(state.loadingIds)..add(requestId);
    state = state.copyWith(loadingIds: nextLoading, error: null);

    try {
      final res = await _repo.acceptVisitRequest(requestId, message: message);

      nextLoading.remove(requestId);
      state = state.copyWith(loadingIds: Set.from(nextLoading));

      _ref.invalidate(receivedVisitRequestsProvider);
      _ref.invalidate(myVisitRequestsProvider);

      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          title: 'Visit Request Accepted ✅',
          message: 'The visitor has been notified of your confirmation.',
        );
      }
      return true;
    } catch (e) {
      nextLoading.remove(requestId);
      final msg = e.toString().replaceAll('Exception:', '').trim();
      state = state.copyWith(loadingIds: Set.from(nextLoading), error: msg);

      if (context.mounted) {
        AppSnackBar.showError(
          context,
          title: 'Action Failed',
          message: msg.isNotEmpty ? msg : 'Failed to accept visit request.',
        );
      }
      return false;
    }
  }

  Future<bool> rejectRequest({
    required BuildContext context,
    required String requestId,
    required String ownerMessage,
  }) async {
    final nextLoading = Set<String>.from(state.loadingIds)..add(requestId);
    state = state.copyWith(loadingIds: nextLoading, error: null);

    try {
      final res = await _repo.rejectVisitRequest(
        requestId,
        ownerMessage: ownerMessage,
      );

      nextLoading.remove(requestId);
      state = state.copyWith(loadingIds: Set.from(nextLoading));

      _ref.invalidate(receivedVisitRequestsProvider);
      _ref.invalidate(myVisitRequestsProvider);

      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          title: 'Visit Declined',
          message: 'Your message has been sent to the visitor.',
        );
      }
      return true;
    } catch (e) {
      nextLoading.remove(requestId);
      final msg = e.toString().replaceAll('Exception:', '').trim();
      state = state.copyWith(loadingIds: Set.from(nextLoading), error: msg);

      if (context.mounted) {
        AppSnackBar.showError(
          context,
          title: 'Action Failed',
          message: msg.isNotEmpty ? msg : 'Failed to decline visit request.',
        );
      }
      return false;
    }
  }
}

final ownerDecisionProvider =
    StateNotifierProvider<OwnerDecisionNotifier, OwnerDecisionState>((ref) {
      return OwnerDecisionNotifier(ref.watch(visitRequestRepoProvider), ref);
    });
