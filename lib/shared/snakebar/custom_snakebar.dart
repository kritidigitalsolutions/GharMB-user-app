import 'package:flutter/material.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';

enum SnackBarType { success, error, warning, info }

class AppSnackBar {
  AppSnackBar._();

  /// 🌟 General Show Method
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final config = _getConfig(type);

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E232A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: config.accentColor.withOpacity(0.3),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: config.accentColor.withOpacity(0.15),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left Accent Strip
                  Container(
                    width: 5,
                    color: config.accentColor,
                  ),

                  // Icon & Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Badge Icon
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: config.accentColor.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              config.icon,
                              color: config.accentColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Text Info
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (title != null && title.isNotEmpty) ...[
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                ],
                                Text(
                                  message,
                                  style: TextStyle(
                                    color: (title != null && title.isNotEmpty)
                                        ? const Color(0xFF94A3B8)
                                        : Colors.white,
                                    fontSize: 13,
                                    fontWeight: (title != null && title.isNotEmpty)
                                        ? FontWeight.w400
                                        : FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Optional Action Button
                          if (actionLabel != null && onAction != null) ...[
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                messenger.hideCurrentSnackBar();
                                onAction();
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                actionLabel,
                                style: TextStyle(
                                  color: config.accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🟢 Success SnackBar
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackBarType.success,
      duration: duration,
    );
  }

  /// 🔴 Error SnackBar
  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackBarType.error,
      duration: duration,
    );
  }

  /// 🟠 Warning SnackBar
  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackBarType.warning,
      duration: duration,
    );
  }

  /// 🔵 Info SnackBar
  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackBarType.info,
      duration: duration,
    );
  }

  // 🔹 Configuration helper
  static _SnackBarConfig _getConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarConfig(
          accentColor: const Color(0xFF10B981), // Emerald Green
          icon: Icons.check_circle_rounded,
        );
      case SnackBarType.error:
        return _SnackBarConfig(
          accentColor: const Color(0xFFEF4444), // Crimson Red
          icon: Icons.cancel_rounded,
        );
      case SnackBarType.warning:
        return _SnackBarConfig(
          accentColor: const Color(0xFFF59E0B), // Amber Yellow
          icon: Icons.warning_rounded,
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          accentColor: AppColors.primary, // GharMB Brand Orange
          icon: Icons.info_rounded,
        );
    }
  }
}

class _SnackBarConfig {
  final Color accentColor;
  final IconData icon;

  _SnackBarConfig({required this.accentColor, required this.icon});
}

/// 🚀 Extension on BuildContext for effortless usage:
/// `context.showSuccessSnackBar("Logged in successfully!")`
extension SnackBarContextExtension on BuildContext {
  void showSuccessSnackBar(String message, {String? title}) {
    AppSnackBar.showSuccess(this, message: message, title: title);
  }

  void showErrorSnackBar(String message, {String? title}) {
    AppSnackBar.showError(this, message: message, title: title);
  }

  void showWarningSnackBar(String message, {String? title}) {
    AppSnackBar.showWarning(this, message: message, title: title);
  }

  void showInfoSnackBar(String message, {String? title}) {
    AppSnackBar.showInfo(this, message: message, title: title);
  }
}
