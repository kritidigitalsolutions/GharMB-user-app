import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/features/home/models/response/notification_detail_response.dart';
import 'package:gharmb_app/features/home/models/response/notification_response_model.dart';
import 'package:gharmb_app/features/home/repo/home_repo.dart';
import 'package:riverpod/legacy.dart';

// ─── Models ───────────────────────────────────────────────────
enum NotificationType { token, property, news, system, priceAlert, unknown }

// Extension to convert string to NotificationType
extension NotificationTypeExtension on String {
  NotificationType toNotificationType() {
    switch (this.toLowerCase()) {
      case 'token':
        return NotificationType.token;
      case 'property':
        return NotificationType.property;
      case 'news':
        return NotificationType.news;
      case 'system':
        return NotificationType.system;
      case 'pricealert':
      case 'price_alert':
        return NotificationType.priceAlert;
      default:
        return NotificationType.unknown;
    }
  }
}

// Extension to get string from NotificationType
extension NotificationTypeString on NotificationType {
  String get string {
    switch (this) {
      case NotificationType.token:
        return 'token';
      case NotificationType.property:
        return 'property';
      case NotificationType.news:
        return 'news';
      case NotificationType.system:
        return 'system';
      case NotificationType.priceAlert:
        return 'priceAlert';
      case NotificationType.unknown:
        return 'unknown';
    }
  }
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String recipient;
  final NotificationType type;
  final bool isRead;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.recipient,
    required this.type,
    required this.isRead,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert from API Notification model
  factory AppNotification.fromApiNotification(Notification notification) {
    return AppNotification(
      id: notification.id,
      title: notification.title,
      message: notification.message,
      recipient: notification.recipient,
      type: notification.type.toNotificationType(),
      isRead: notification.isRead,
      version: notification.version,
      createdAt: notification.createdAt,
      updatedAt: notification.updatedAt,
    );
  }

  // Convert from API NotificationDetail model
  factory AppNotification.fromApiNotificationDetail(
    NotificationDetail notification,
  ) {
    return AppNotification(
      id: notification.id,
      title: notification.title,
      message: notification.message,
      recipient: notification.recipient,
      type: notification.type.toNotificationType(),
      isRead: notification.isRead,
      version: notification.version,
      createdAt: notification.createdAt,
      updatedAt: notification.updatedAt,
    );
  }

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    String? recipient,
    NotificationType? type,
    bool? isRead,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      recipient: recipient ?? this.recipient,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper getters
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) return 'Yesterday';
      if (difference.inDays < 7) return '${difference.inDays} days ago';
      if (difference.inDays < 30) return '${difference.inDays ~/ 7} weeks ago';
      if (difference.inDays < 365)
        return '${difference.inDays ~/ 30} months ago';
      return '${difference.inDays ~/ 365} years ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hr${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String get shortMessage {
    if (message.length <= 50) return message;
    return '${message.substring(0, 50)}...';
  }

  @override
  String toString() {
    return 'AppNotification(id: $id, title: $title, isRead: $isRead)';
  }
}

// ─── Notification State ──────────────────────────────────────
class NotificationState {
  final List<AppNotification> notifications;
  final bool isLoading;
  final bool isMarkingAll;
  final String? error;
  final NotificationDetail? selectedNotification;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.isMarkingAll = false,
    this.error,
    this.selectedNotification,
  });

  NotificationState copyWith({
    List<AppNotification>? notifications,
    bool? isLoading,
    bool? isMarkingAll,
    String? error,
    NotificationDetail? selectedNotification,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      isMarkingAll: isMarkingAll ?? this.isMarkingAll,
      error: error ?? this.error,
      selectedNotification: selectedNotification ?? this.selectedNotification,
    );
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;
  bool get hasNotifications => notifications.isNotEmpty;
  bool get hasError => error != null;
}

// ─── Notifier ─────────────────────────────────────────────────
class NotificationNotifier extends StateNotifier<NotificationState> {
  final HomeRepo _homeRepo;

  NotificationNotifier(this._homeRepo) : super(const NotificationState());

  // Fetch all notifications
  Future<void> fetchNotifications() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _homeRepo.allUserNotification();

      if (response != null && response.status == 'success') {
        final appNotifications = response.data.notifications
            .map(
              (apiNotification) =>
                  AppNotification.fromApiNotification(apiNotification),
            )
            .toList();

        state = state.copyWith(
          notifications: appNotifications,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load notifications',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Mark a single notification as read
  Future<void> markAsRead(String id) async {
    try {
      // Optimistic update
      final updatedNotifications = state.notifications.map((n) {
        if (n.id == id) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      state = state.copyWith(notifications: updatedNotifications);

      // API call
      final response = await _homeRepo.notificationRead(id: id);

      if (response == null || response.status != 'success') {
        // Revert if API fails
        final revertedNotifications = state.notifications.map((n) {
          if (n.id == id) {
            return n.copyWith(isRead: false);
          }
          return n;
        }).toList();
        state = state.copyWith(
          notifications: revertedNotifications,
          error: 'Failed to mark as read',
        );
      }
    } catch (e) {
      // Revert on error
      final revertedNotifications = state.notifications.map((n) {
        if (n.id == id) {
          return n.copyWith(isRead: false);
        }
        return n;
      }).toList();
      state = state.copyWith(
        notifications: revertedNotifications,
        error: e.toString(),
      );
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    if (state.isMarkingAll) return;

    state = state.copyWith(isMarkingAll: true, error: null);
    try {
      // Optimistic update
      final updatedNotifications = state.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();

      state = state.copyWith(notifications: updatedNotifications);

      final success = await _homeRepo.markAllNotification();

      if (!success) {
        // Revert if API fails
        final originalNotifications = state.notifications
            .map((n) => n.copyWith(isRead: false))
            .toList();
        state = state.copyWith(
          notifications: originalNotifications,
          isMarkingAll: false,
          error: 'Failed to mark all as read',
        );
      } else {
        state = state.copyWith(isMarkingAll: false);
      }
    } catch (e) {
      // Revert on error
      final originalNotifications = state.notifications
          .map((n) => n.copyWith(isRead: false))
          .toList();
      state = state.copyWith(
        notifications: originalNotifications,
        isMarkingAll: false,
        error: e.toString(),
      );
    }
  }

  // Get single notification detail
  Future<void> fetchNotificationDetail(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _homeRepo.notificationRead(id: id);

      if (response != null && response.status == 'success') {
        state = state.copyWith(
          selectedNotification: response.data.notification,
          isLoading: false,
        );

        // Also update in list if exists
        final updatedNotifications = state.notifications.map((n) {
          if (n.id == id) {
            return AppNotification.fromApiNotificationDetail(
              response.data.notification,
            );
          }
          return n;
        }).toList();

        state = state.copyWith(notifications: updatedNotifications);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to fetch notification detail',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Delete notification (local only - add API if needed)
  void deleteNotification(String id) {
    final updatedNotifications = state.notifications
        .where((n) => n.id != id)
        .toList();
    state = state.copyWith(notifications: updatedNotifications);
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Refresh notifications
  Future<void> refresh() async {
    await fetchNotifications();
  }

  // Reset state
  void reset() {
    state = const NotificationState();
  }
}

// ─── Providers ────────────────────────────────────────────────

// Provider for HomeRepo
final homeRepoProvider = Provider<HomeRepo>((ref) {
  return HomeRepo();
});

// Main notification provider
final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
      final homeRepo = ref.watch(homeRepoProvider);
      return NotificationNotifier(homeRepo);
    });

// Provider for unread count
final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).unreadCount;
});

// Provider for notification list
final notificationListProvider = Provider<List<AppNotification>>((ref) {
  return ref.watch(notificationProvider).notifications;
});

// Provider for unread notifications
final unreadNotificationsProvider = Provider<List<AppNotification>>((ref) {
  return ref
      .watch(notificationProvider)
      .notifications
      .where((n) => !n.isRead)
      .toList();
});

// Provider for loading state
final notificationLoadingProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider).isLoading;
});

// Provider for error state
final notificationErrorProvider = Provider<String?>((ref) {
  return ref.watch(notificationProvider).error;
});

// Provider for selected notification detail
final selectedNotificationProvider = Provider<NotificationDetail?>((ref) {
  return ref.watch(notificationProvider).selectedNotification;
});

// Provider for marking all status
final isMarkingAllProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider).isMarkingAll;
});
