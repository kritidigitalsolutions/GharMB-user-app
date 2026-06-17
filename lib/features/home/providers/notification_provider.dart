import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// ─── Models ───────────────────────────────────────────────────
enum NotificationType { token, property, news, system, priceAlert }

class AppNotification {
  final String id;
  final String title;
  final String subtitle;
  final String timeAgo;
  final NotificationType type;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
    id: id,
    title: title,
    subtitle: subtitle,
    timeAgo: timeAgo,
    type: type,
    isRead: isRead ?? this.isRead,
  );
}

// ─── Notifier ─────────────────────────────────────────────────
class NotificationNotifier extends StateNotifier<List<AppNotification>> {
  NotificationNotifier()
    : super(const [
        AppNotification(
          id: '1',
          title: 'New token request received!',
          subtitle:
              'Rahul Sharma sent a ₹5,000 token for Skyline Heights – 3 BHK',
          timeAgo: '2 min ago',
          type: NotificationType.token,
          isRead: false,
        ),
        AppNotification(
          id: '2',
          title: 'Token accepted successfully',
          subtitle:
              'You accepted Priya Mehta\'s token for Green Valley Apartment',
          timeAgo: '1 hr ago',
          type: NotificationType.token,
          isRead: false,
        ),
        AppNotification(
          id: '3',
          title: 'Your listing is now Live!',
          subtitle:
              'Skyline Heights – 3 BHK is now visible to buyers on GharMB',
          timeAgo: '3 hrs ago',
          type: NotificationType.property,
          isRead: false,
        ),
        AppNotification(
          id: '4',
          title: 'Property verified ✓',
          subtitle: 'Admin has verified your property at Sector 62, Noida',
          timeAgo: '5 hrs ago',
          type: NotificationType.property,
          isRead: true,
        ),
        AppNotification(
          id: '5',
          title: 'Price drop alert 🔔',
          subtitle: 'Properties in Sector 62 dropped by 8% this week',
          timeAgo: 'Yesterday',
          type: NotificationType.priceAlert,
          isRead: true,
        ),
        AppNotification(
          id: '6',
          title: 'RBI holds repo rate at 6.5%',
          subtitle: 'Home loan EMIs stay stable this quarter – read more',
          timeAgo: 'Yesterday',
          type: NotificationType.news,
          isRead: true,
        ),
        AppNotification(
          id: '7',
          title: 'Complete your profile',
          subtitle: 'Add your Aadhaar & PAN to unlock all features on GharMB',
          timeAgo: '2 days ago',
          type: NotificationType.system,
          isRead: true,
        ),
        AppNotification(
          id: '8',
          title: 'Site visit scheduled',
          subtitle: 'Buyer confirmed site visit for Palm Grove Villa on 15 Jun',
          timeAgo: '2 days ago',
          type: NotificationType.property,
          isRead: true,
        ),
      ]);

  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n,
    ];
  }

  void markAllAsRead() {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }

  void delete(String id) {
    state = state.where((n) => n.id != id).toList();
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, List<AppNotification>>(
      (ref) => NotificationNotifier(),
    );

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).where((n) => !n.isRead).length;
});
