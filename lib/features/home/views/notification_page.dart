import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/home/providers/notification_provider.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // Load notifications when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationProvider.notifier).fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationProvider);
    final notifications = state.notifications;
    final unread = state.unreadCount;
    final notifier = ref.read(notificationProvider.notifier);
    final isLoading = state.isLoading;
    final error = state.error;

    // Group notifications by date
    final now = DateTime.now();
    final today = notifications.where((n) {
      final diff = now.difference(n.createdAt);
      return diff.inDays == 0;
    }).toList();

    final yesterday = notifications.where((n) {
      final diff = now.difference(n.createdAt);
      return diff.inDays == 1;
    }).toList();

    final earlier = notifications.where((n) {
      final diff = now.difference(n.createdAt);
      return diff.inDays >= 2 && diff.inDays < 7;
    }).toList();

    final older = notifications.where((n) {
      final diff = now.difference(n.createdAt);
      return diff.inDays >= 7;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  const CustomBackButton(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Notifications',
                          style: text18(fontWeight: FontWeight.bold),
                        ),
                        if (unread > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$unread New',
                              style: text10(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (unread > 0)
                    GestureDetector(
                      onTap: state.isMarkingAll
                          ? null
                          : () => notifier.markAllAsRead(),
                      child: state.isMarkingAll
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : Text(
                              'Mark all read',
                              style: text12(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Error State ─────────────────────────────────────
            if (error != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          error,
                          style: text12(color: AppColors.error),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => notifier.clearError(),
                        child: Icon(
                          Icons.close,
                          color: AppColors.error,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // ── List ────────────────────────────────────────────
            Expanded(
              child: isLoading && notifications.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : notifications.isEmpty
                  ? _EmptyState()
                  : RefreshIndicator(
                      onRefresh: () => notifier.refresh(),
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          if (today.isNotEmpty) ...[
                            _SectionLabel(label: 'Today'),
                            const SizedBox(height: 10),
                            ...today.map(
                              (n) => _NotificationCard(
                                notification: n,
                                onTap: () => notifier.markAsRead(n.id),
                                onDelete: () =>
                                    notifier.deleteNotification(n.id),
                              ),
                            ),
                          ],
                          if (yesterday.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _SectionLabel(label: 'Yesterday'),
                            const SizedBox(height: 10),
                            ...yesterday.map(
                              (n) => _NotificationCard(
                                notification: n,
                                onTap: () => notifier.markAsRead(n.id),
                                onDelete: () =>
                                    notifier.deleteNotification(n.id),
                              ),
                            ),
                          ],
                          if (earlier.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _SectionLabel(label: 'This Week'),
                            const SizedBox(height: 10),
                            ...earlier.map(
                              (n) => _NotificationCard(
                                notification: n,
                                onTap: () => notifier.markAsRead(n.id),
                                onDelete: () =>
                                    notifier.deleteNotification(n.id),
                              ),
                            ),
                          ],
                          if (older.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _SectionLabel(label: 'Older'),
                            const SizedBox(height: 10),
                            ...older.map(
                              (n) => _NotificationCard(
                                notification: n,
                                onTap: () => notifier.markAsRead(n.id),
                                onDelete: () =>
                                    notifier.deleteNotification(n.id),
                              ),
                            ),
                          ],
                          if (isLoading && notifications.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section Label ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: text12(fontWeight: FontWeight.w700, color: AppColors.grey400),
    );
  }
}

// ─── Notification Card ─────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final type = notification.type;
    final isRead = notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.white,
          size: 24,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isRead
                ? AppColors.white
                : AppColors.primary.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isRead
                  ? AppColors.grey200
                  : AppColors.primary.withOpacity(0.2),
              width: isRead ? 1 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isRead ? 0.03 : 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              _NotifIcon(type: type),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: text13(
                              fontWeight: isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: isRead
                                  ? AppColors.textPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: text12(color: AppColors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.timeAgo,
                      style: text10(color: AppColors.grey400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Notification Icon ─────────────────────────────────────────
class _NotifIcon extends StatelessWidget {
  final NotificationType type;
  const _NotifIcon({required this.type});

  IconData get _icon {
    switch (type) {
      case NotificationType.token:
        return Icons.monetization_on_outlined;
      case NotificationType.property:
        return Icons.apartment_outlined;
      case NotificationType.news:
        return Icons.newspaper_outlined;
      case NotificationType.priceAlert:
        return Icons.trending_down_rounded;
      case NotificationType.system:
        return Icons.settings_outlined;
      case NotificationType.unknown:
        return Icons.notifications_outlined;
    }
  }

  Color get _bg {
    switch (type) {
      case NotificationType.token:
        return AppColors.warning.withOpacity(0.12);
      case NotificationType.property:
        return AppColors.primary.withOpacity(0.1);
      case NotificationType.news:
        return AppColors.info.withOpacity(0.1);
      case NotificationType.priceAlert:
        return AppColors.success.withOpacity(0.1);
      case NotificationType.system:
        return AppColors.grey200;
      case NotificationType.unknown:
        return AppColors.grey200;
    }
  }

  Color get _iconColor {
    switch (type) {
      case NotificationType.token:
        return AppColors.warning;
      case NotificationType.property:
        return AppColors.primary;
      case NotificationType.news:
        return AppColors.info;
      case NotificationType.priceAlert:
        return AppColors.success;
      case NotificationType.system:
        return AppColors.grey600;
      case NotificationType.unknown:
        return AppColors.grey600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: _bg, shape: BoxShape.circle),
      child: Icon(_icon, color: _iconColor, size: 20),
    );
  }
}

// ─── Empty State ───────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No notifications yet',
            style: text16(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'We\'ll notify you about tokens,\nlistings & market updates',
            style: text13(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
