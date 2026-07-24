import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isLoading = ref.watch(authLoadingProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to home / skip onboarding
                    },
                    child: Text(
                      'Skip',
                      style: text14(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Heading
                Text(
                  'Find Verified\nProperties Near You',
                  textAlign: TextAlign.center,
                  style: text24(color: AppColors.textPrimary),
                ),

                const SizedBox(height: 8),

                Text(
                  'Buy, Rent, Resale & Commercial\nAll in One Place',
                  textAlign: TextAlign.center,
                  style: text13(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 12),

                Image.asset(
                  "assets/auth/1.png",
                  width: double.infinity,
                  height: 200,
                ),

                const SizedBox(height: 20),

                // Google button
                _SocialButton(
                  onTap: () {
                    //  ref.read(authLoadingProvider.notifier).state = true;
                    // Trigger Google sign-in
                  },
                  image: "assets/auth/google.png",
                  label: 'Continue with Google',
                ),

                // const SizedBox(height: 12),

                // // Facebook button
                // _SocialButton(
                //   onTap: isLoading
                //       ? null
                //       : () {
                //           // Trigger Facebook sign-in
                //         },
                //   image: "assets/auth/facebook.png",
                //   label: 'Continue with Facebook',
                // ),
                const SizedBox(height: 20),

                // OR divider
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.grey300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: text13(color: AppColors.textSecondary),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.grey300)),
                  ],
                ),

                const SizedBox(height: 20),

                // Continue with Mobile
                AppButton(
                  title: 'Continue with Mobile',
                  onTap: () {
                    context.pushNamed(AppPage.loginName);
                  },
                ),

                const SizedBox(height: 24),

                // Sign in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: text13(color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(AppPage.basicInfoName);
                      },
                      child: Text(
                        'Sign up',
                        style: text13(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _SocialButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String image;
  final String label;

  const _SocialButton({
    required this.onTap,
    required this.image,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.grey300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 26, height: 26),
            const SizedBox(width: 10),
            Text(
              label,
              style: text14(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
