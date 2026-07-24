import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/auth/providers/basic_info_provider.dart';
import 'package:gharmb_app/features/auth/providers/otp_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

class BasicInfoScreen extends ConsumerWidget {
  const BasicInfoScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(basicInfoProvider);
    final notifier = ref.read(basicInfoProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              Text('Basic Info', style: text24(color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text(
                "Let's set up your profile",
                style: text13(color: AppColors.textSecondary),
              ),

              const SizedBox(height: 28),

              _FormField(
                label: 'Full name',
                hint: 'Enter your full name',
                icon: Icons.person_outline,
                onChanged: notifier.setFullName,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              _FormField(
                label: 'Email address',
                hint: 'Enter your email address',
                icon: Icons.mail_outline,
                onChanged: notifier.setEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              _FormField(
                label: 'Phone number',
                hint: 'Enter your mobile number',
                icon: Icons.phone_outlined,
                onChanged: notifier.setPhone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              // Address with dropdown arrow
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address',
                    style: text12(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          onTap: state.isLocationLoading
                              ? null
                              : () async {
                                  await notifier.fetchCurrentLocation();
                                },
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.my_location,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Use current location',
                                  style: text13(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                if (state.isLocationLoading)
                                  const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 1, color: AppColors.grey200),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 14),
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Icon(
                                Icons.location_on_outlined,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller:
                                    TextEditingController(text: state.address)
                                      ..selection = TextSelection.collapsed(
                                        offset: state.address.length,
                                      ),
                                onChanged: notifier.setAddress,
                                maxLines: 3,
                                minLines: 2,
                                style: text13(color: AppColors.textPrimary),
                                decoration: InputDecoration(
                                  hintText: 'Or type your address manually',
                                  hintStyle: text13(color: AppColors.hintText),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // --- Inline error banner ---
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: state.errorMessage != null
                    ? Container(
                        key: ValueKey(state.errorMessage),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.35),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 18,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                state.errorMessage!,
                                style: text13(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 8),

              // Terms text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: text11(color: AppColors.textSecondary),
                  children: [
                    const TextSpan(text: 'By continuing you agree to our '),
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: text11(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: text11(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Continue button
              AppButton(
                title: "Continue",
                onTap: (notifier.isFormValid && !state.isLoading)
                    ? () {
                        ref.read(otpPhoneProvider.notifier).state = state.phone
                            .trim();
                        notifier.submit(() {
                          context.pushNamed(AppPage.otpName);
                        });
                      }
                    : null,
                isLoading: state.isLoading,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  const _FormField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.onChanged,
    required this.keyboardType,
    required this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: text12(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(icon, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  style: text13(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: text13(color: AppColors.hintText),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ],
    );
  }
}
