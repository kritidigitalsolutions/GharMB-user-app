import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/auth/providers/login_provider.dart';
import 'package:gharmb_app/features/auth/providers/otp_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Top orange arc decoration
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 260),
              painter: _TopArcPainter(),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),

                // Logo + brand in arc area
                const SizedBox(height: 4),
                Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.home_rounded,
                            color: AppColors.primary,
                            size: 40,
                          ),
                          Positioned(
                            bottom: 12,
                            child: Text(
                              'G',
                              style: text11(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'GharMB',
                  style: text18(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),

                Text(
                  'Verified Properties of Mira-Bhayandar',
                  style: text11(color: AppColors.white70),
                ),

                const SizedBox(height: 40),

                // Card content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Heading
                        Text(
                          'Welcome Back 👋',
                          style: text24(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Enter your mobile number to continue',
                          style: text13(color: AppColors.textSecondary),
                        ),

                        const SizedBox(height: 32),

                        // Label
                        Text(
                          'Mobile Number',
                          style: text13(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Phone input
                        _PhoneInput(
                          controller: _controller,
                          focusNode: _focusNode,
                          onChanged: notifier.setPhone,
                          hasError: state.errorMessage != null,
                        ),

                        // Error message
                        if (state.errorMessage != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 14,
                                color: AppColors.error,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  state.errorMessage!,
                                  style: text12(color: AppColors.error),
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Continue button
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: state.isValid
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(
                                          0.35,
                                        ),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: ElevatedButton(
                              onPressed: (state.isValid && !state.isLoading)
                                  ? () => notifier.sendOtp(
                                      onSuccess: () {
                                        ref
                                            .read(otpPhoneProvider.notifier)
                                            .state = state.phone
                                            .trim();
                                        context.pushNamed(AppPage.otpName);
                                      },

                                    )
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor: AppColors.grey200,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: state.isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Send OTP',
                                          style: text15(
                                            fontWeight: FontWeight.w600,
                                            color: state.isValid
                                                ? AppColors.white
                                                : AppColors.grey400,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 18,
                                          color: state.isValid
                                              ? AppColors.white
                                              : AppColors.grey400,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Terms note
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: text11(color: AppColors.textSecondary),
                              children: [
                                const TextSpan(
                                  text: 'By continuing you agree to our ',
                                ),
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
                        ),

                        const SizedBox(height: 40),

                        // Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: AppColors.grey200)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'New to GharMB?',
                                style: text12(color: AppColors.textSecondary),
                              ),
                            ),
                            Expanded(child: Divider(color: AppColors.grey200)),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Create account button
                        AppOutlineButton(
                          title: "Create an Account",
                          onTap: () {
                            context.pushNamed(AppPage.basicInfoName);
                          },
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Phone Input Widget
// ---------------------------------------------------------------------------

class _PhoneInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool hasError;

  const _PhoneInput({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.hasError,
  });

  @override
  State<_PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<_PhoneInput> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() => _isFocused = widget.focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.grey200;
    if (widget.hasError) {
      borderColor = AppColors.error;
    } else if (_isFocused) {
      borderColor = AppColors.primary;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 58,
      decoration: BoxDecoration(
        color: _isFocused ? AppColors.white : AppColors.grey50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          // Country code
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🇮🇳', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  '+91',
                  style: text13(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),

          // Vertical divider
          Container(width: 1, height: 28, color: AppColors.grey200),

          const SizedBox(width: 12),

          // Number input
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              onChanged: widget.onChanged,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: text16(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: '98765 43210',
                hintStyle: text15(color: AppColors.hintText),
                border: InputBorder.none,
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          // Clear or checkmark
          if (widget.controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: widget.controller.text.length == 10
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 20,
                    )
                  : GestureDetector(
                      onTap: () {
                        widget.controller.clear();
                        widget.onChanged('');
                      },
                      child: const Icon(
                        Icons.cancel_rounded,
                        color: AppColors.grey400,
                        size: 20,
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top Arc Painter
// ---------------------------------------------------------------------------

class _TopArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background fill
    final bgPaint = Paint()..color = AppColors.primary;
    final bgPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.78)
      ..quadraticBezierTo(
        size.width / 2,
        size.height * 1.1,
        0,
        size.height * 0.78,
      )
      ..close();
    canvas.drawPath(bgPath, bgPaint);

    // Subtle inner highlight arc
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..style = PaintingStyle.fill;
    final highlightPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.7,
        0,
        size.height * 0.45,
      )
      ..close();
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
