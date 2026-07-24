import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/auth/providers/onboarding_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';

class StayUpdatedPage extends ConsumerStatefulWidget {
  const StayUpdatedPage({super.key});

  @override
  ConsumerState<StayUpdatedPage> createState() => _StayUpdatedPageState();
}

class _StayUpdatedPageState extends ConsumerState<StayUpdatedPage> {
  bool _isLoading = false;

  Future<void> _handleStartExploring() async {
    setState(() => _isLoading = true);

    final status = await Permission.notification.request();

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (status.isGranted) {
      _navigateToHome();
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Notifications disabled. You can enable them later in Settings.',
            style: text13(color: AppColors.white),
          ),
          backgroundColor: AppColors.textPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    context.pushNamed(AppPage.myHomeName);
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Enable Notifications',
          style: text16(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Notifications are blocked. Please enable them from App Settings to stay updated.',
          style: text13(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToHome();
            },
            child: Text('Skip', style: text13(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              'Open Settings',
              style: text13(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _HeroSection(),
                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Text(
                            'Stay Updated',
                            style: text24(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Choose what updates you\nwant to receive',
                            style: text13(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _NotifToggleRow(
                              title: 'Notification preferences',
                              subtitle: 'Get notified when prices drop',
                              value: state.notificationPreferences,
                              onChanged: (_) => notifier.toggleNotification(
                                'notificationPreferences',
                              ),
                              showDivider: true,
                            ),
                            _NotifToggleRow(
                              title: 'New listing alerts',
                              subtitle: 'Get notified when prices drop',
                              value: state.newListingAlerts,
                              onChanged: (_) => notifier.toggleNotification(
                                'newListingAlerts',
                              ),
                              showDivider: true,
                            ),
                            _NotifToggleRow(
                              title: 'Token & booking updates',
                              subtitle: 'Get updates on your bookings',
                              value: state.tokenAndBooking,
                              onChanged: (_) => notifier.toggleNotification(
                                'tokenAndBooking',
                              ),
                              showDivider: true,
                            ),
                            _NotifToggleRow(
                              title: 'Important updates',
                              subtitle: 'Platform & safety updates',
                              value: state.importantUpdates,
                              onChanged: (_) => notifier.toggleNotification(
                                'importantUpdates',
                              ),
                              showDivider: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: AppButton(
                title: "Start Exploring",
                onTap: state.isLoading
                    ? null
                    : () {
                        notifier.submitOnboarding(() {
                          context.pushReplacementNamed(AppPage.myHomeName);
                        });
                      },
                isLoading: state.isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ─── Hero Section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Blurred city skyline background
          Image.asset("assets/auth/2.png", fit: BoxFit.cover),

          Positioned.fill(
            child: Container(color: AppColors.white.withValues(alpha: 0.7)),
          ),

          // Bell icon circle
          Positioned(
            top: 16,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: AppColors.primary,
                size: 34,
              ),
            ),
          ),

          // Location pin on house
          Positioned(
            bottom: 52,
            right: 95,
            child: Icon(
              Icons.location_on,
              color: AppColors.primary.withOpacity(0.8),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
// ─── City Skyline Painter ─────────────────────────────────────────────────────

// class _CitySkylnePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final bgPaint = Paint()..color = const Color(0xFFF5F5F5);
//     final buildingPaint = Paint()..color = const Color(0xFFEAEAEA);
//     final housePaint = Paint()..color = const Color(0xFFD9D9D9);
//     final roofPaint = Paint()..color = const Color(0xFFCCCCCC);

//     // Background
//     canvas.drawRect(Rect.fromLTWH(0, 20, size.width, size.height), bgPaint);

//     // Left buildings
//     _drawBuilding(canvas, buildingPaint, 10, 60, 40, 80);
//     _drawBuilding(canvas, buildingPaint, 55, 40, 35, 100);
//     _drawBuilding(canvas, buildingPaint, 95, 70, 30, 70);

//     // Center house (main)
//     final hx = size.width / 2 - 40;
//     canvas.drawRect(Rect.fromLTWH(hx, 60, 80, 80), housePaint);
//     // Roof
//     final roofPath = Path()
//       ..moveTo(hx - 10, 60)
//       ..lineTo(hx + 40, 15)
//       ..lineTo(hx + 90, 60)
//       ..close();
//     canvas.drawPath(roofPath, roofPaint);
//     // Door
//     final doorPaint = Paint()..color = const Color(0xFFBBBBBB);
//     canvas.drawRect(Rect.fromLTWH(hx + 30, 100, 20, 40), doorPaint);
//     // Windows
//     canvas.drawRect(Rect.fromLTWH(hx + 8, 72, 20, 16), doorPaint);
//     canvas.drawRect(Rect.fromLTWH(hx + 52, 72, 20, 16), doorPaint);

//     // Right buildings
//     _drawBuilding(canvas, buildingPaint, size.width - 95, 50, 35, 90);
//     _drawBuilding(canvas, buildingPaint, size.width - 55, 30, 30, 110);
//     _drawBuilding(canvas, buildingPaint, size.width - 22, 65, 22, 75);
//   }

//   void _drawBuilding(
//     Canvas canvas,
//     Paint paint,
//     double x,
//     double y,
//     double w,
//     double h,
//   ) {
//     canvas.drawRect(Rect.fromLTWH(x, y, w, h), paint);
//     // Windows
//     final winPaint = Paint()..color = Colors.white.withOpacity(0.5);
//     for (var row = 0; row < 3; row++) {
//       for (var col = 0; col < 2; col++) {
//         canvas.drawRect(
//           Rect.fromLTWH(
//             x + 4 + col * (w / 2 - 2),
//             y + 8 + row * 18,
//             w / 2 - 8,
//             10,
//           ),
//           winPaint,
//         );
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// ─── Toggle Row ───────────────────────────────────────────────────────────────

class _NotifToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const _NotifToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text14(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: text12(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.white,
                activeTrackColor: AppColors.primary,
                inactiveThumbColor: AppColors.white,
                inactiveTrackColor: AppColors.grey300,
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.grey100,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
