import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/auth/providers/otp_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (final n in _focusNodes) {
      n.dispose();
    }
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    final notifier = ref.read(otpProvider.notifier);
    if (value.isEmpty) {
      notifier.setDigit(index, '');
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    } else {
      notifier.setDigit(index, value);
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        // Auto-verify when last digit entered
        notifier.verify(() {
          // Navigate to next step
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(otpProvider);
    final notifier = ref.read(otpProvider.notifier);
    final phone = ref.watch(otpPhoneProvider);

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

        titleSpacing: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              Text(
                'Verify Your Number',
                style: text24(color: AppColors.textPrimary),
              ),

              const SizedBox(height: 8),

              Text(
                'Enter the 6-digit code sent to',
                style: text13(color: AppColors.textSecondary),
              ),

              const SizedBox(height: 4),

              Text(
                phone,
                style: text16(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 40),

              // OTP input boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return _OtpBox(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    onChanged: (v) => _onDigitChanged(index, v),
                    hasError: state.hasError,
                    isVerified: state.isVerified,
                    value: state.digits[index],
                  );
                }),
              ),

              const SizedBox(height: 20),

              // Status message
              if (state.isVerified)
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'OTP Verified Successfully',
                        style: text13(
                          fontWeight: FontWeight.w500,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),

              if (state.hasError)
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Invalid OTP. Please try again.',
                        style: text13(
                          fontWeight: FontWeight.w500,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // Resend section
              Center(
                child: GestureDetector(
                  onTap: state.resendCountdown == 0 ? notifier.resend : null,
                  child: RichText(
                    text: TextSpan(
                      style: text13(color: AppColors.textSecondary),
                      children: [
                        const TextSpan(text: "Didn't receive code? "),
                        if (state.resendCountdown > 0)
                          TextSpan(
                            text:
                                'Resend OTP in ${_formatSeconds(state.resendCountdown)}',
                            style: text13(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          )
                        else
                          TextSpan(
                            text: 'Resend OTP',
                            style: text13(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Continue button
              AppButton(
                title: 'Continue',
                onTap: (state.isFilled && !state.isLoading && !state.isVerified)
                    ? () {
                        notifier.verify(() {
                          // Navigate to next step
                        });
                      }
                    : state.isVerified
                    ? () {
                        context.pushNamed(AppPage.roleSelectionName);
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

  String _formatSeconds(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool hasError;
  final bool isVerified;
  final String value;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.hasError,
    required this.isVerified,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.grey300;
    Color bgColor = AppColors.grey50;

    if (value.isNotEmpty && !hasError && !isVerified) {
      borderColor = AppColors.primary;
      bgColor = AppColors.primary.withOpacity(0.05);
    } else if (hasError && value.isNotEmpty) {
      borderColor = AppColors.error;
      bgColor = AppColors.error.withOpacity(0.05);
    } else if (isVerified && value.isNotEmpty) {
      borderColor = AppColors.success;
      bgColor = AppColors.success.withOpacity(0.05);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          maxLength: 1,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: text24(
            fontWeight: FontWeight.bold,
            color: hasError
                ? AppColors.error
                : isVerified
                ? AppColors.success
                : AppColors.textPrimary,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
