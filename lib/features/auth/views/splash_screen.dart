import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/core/utils/local_storage/auth_storage.dart';
import 'package:gharmb_app/features/auth/models/response/auth_response_model.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 3));

    final String? token = await LocalStorageService.getToken();
    final AuthUserModel? user = await LocalStorageService.getUser();

    if (!mounted) return;

    final bool isLoggedIn = token != null && token.isNotEmpty;
    final bool isOnboardingCompleted = user?.isOnboardingCompleted ?? false;
    if (isLoggedIn && isOnboardingCompleted) {
      print("token: $token");
      context.pushReplacementNamed(AppPage.myHomeName);
    } else if (!isLoggedIn) {
      context.pushReplacementNamed(AppPage.authName);
      print("token: $token");
      return;
    }

    if (!isOnboardingCompleted) {
      context.pushReplacementNamed(AppPage.roleSelectionName);
      print("token: $token");
      return;
    }

    context.pushReplacementNamed(AppPage.myHomeName);
    print("token: $token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset("assets/auth/background.png", fit: BoxFit.cover),
          ),

          // Content
          Positioned(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Logo
                    Center(
                      child: Image.asset(
                        "assets/logo.png",
                        width: 150,
                        height: 150,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Center(
                      child: Text(
                        'Verified Properties of\nMira-Bhayandar',
                        textAlign: TextAlign.center,
                        style: text13(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Main heading
                    Text(
                      'Your Trusted Real Estate\nPartner in Mira-Bhayandar',
                      style: text26(color: AppColors.white),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Buy • Sell • Rent • Commercial',
                      style: text13(color: AppColors.white70),
                    ),

                    const SizedBox(height: 28),

                    // Feature badges
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _FeatureBadge(
                          icon: Icons.verified,
                          label: '100% Verified\nListings',
                        ),
                        _FeatureBadge(
                          icon: Icons.lock_outline,
                          label: 'Secure Token\nBooking',
                        ),
                        _FeatureBadge(
                          icon: Icons.real_estate_agent,
                          label: 'RERA\nFocused',
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Proudly Made in India
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🇮🇳', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            'Proudly Made in India',
                            style: text14(
                              color: AppColors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    Center(
                      child: Text(
                        'Local for Local • Dedicated to Mira-Bhayandar',
                        style: text12(color: AppColors.white54),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: text10(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
