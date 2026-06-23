import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/developer/providers/register_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

class RegistrationStep1Page extends ConsumerStatefulWidget {
  final RegistrationType type;
  const RegistrationStep1Page({super.key, required this.type});

  @override
  ConsumerState<RegistrationStep1Page> createState() =>
      _RegistrationStep1PageState();
}

class _RegistrationStep1PageState extends ConsumerState<RegistrationStep1Page> {
  final _companyCtrl = TextEditingController();
  final _reraCtrl = TextEditingController();
  final _gstCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _agentNameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();

  @override
  void dispose() {
    _companyCtrl.dispose();
    _reraCtrl.dispose();
    _gstCtrl.dispose();
    _cityCtrl.dispose();
    _agentNameCtrl.dispose();
    _mobileCtrl.dispose();
    super.dispose();
  }

  bool get _isDeveloper => widget.type == RegistrationType.developer;

  String get _title =>
      _isDeveloper ? 'Register as Developer' : 'Register as Agent';
  String get _subtitle => _isDeveloper
      ? 'Step 1 of 3 — Company details'
      : 'Step 1 of 3 — Personal details';
  String get _infoText => _isDeveloper
      ? 'Our admin team will verify your RERA registration before your projects go live.'
      : 'Our admin team will verify your RERA registration before you can list properties.';

  @override
  Widget build(BuildContext context) {
    final step1 = _isDeveloper
        ? ref.watch(developerStep1Provider)
        : ref.watch(agentStep1Provider);
    final notifier = _isDeveloper
        ? ref.read(developerStep1Provider.notifier)
        : ref.read(agentStep1Provider.notifier);

    final yearOptions = _isDeveloper
        ? developerYearOptions
        : agentExperienceOptions;
    final selectedYear = _isDeveloper
        ? step1.yearsInBusiness
        : step1.experience;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomBackButton(),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _title,
                            style: text18(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _subtitle,
                            style: text12(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Progress bar
                  _ProgressBar(step: 1, total: 3),
                  const SizedBox(height: 20),

                  // Info banner
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.business_outlined,
                          color: Color(0xFF6C63FF),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isDeveloper
                                    ? 'Developer account'
                                    : 'Agent account',
                                style: text13(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF6C63FF),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _infoText,
                                style: text12(
                                  color: const Color(
                                    0xFF6C63FF,
                                  ).withOpacity(0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Form ─────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Developer fields
                    if (_isDeveloper) ...[
                      _FieldLabel(label: 'Company / firm name', required: true),
                      _InputField(
                        controller: _companyCtrl,
                        hint: 'e.g. Emerald Builders Pvt Ltd',
                        onChanged: notifier.setCompanyName,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Agent fields
                    if (!_isDeveloper) ...[
                      _FieldLabel(label: 'Full name', required: true),
                      _InputField(
                        controller: _agentNameCtrl,
                        hint: 'e.g. Rahul Sharma',
                        onChanged: notifier.setAgentName,
                      ),
                      const SizedBox(height: 16),
                      _FieldLabel(label: 'Mobile number', required: true),
                      _InputField(
                        controller: _mobileCtrl,
                        hint: 'e.g. 9876543210',
                        keyboardType: TextInputType.phone,
                        onChanged: notifier.setMobile,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // RERA
                    _FieldLabel(
                      label: 'RERA registration number',
                      required: true,
                    ),
                    _InputField(
                      controller: _reraCtrl,
                      hint: _isDeveloper
                          ? 'UPREAREG24XXXXXXX'
                          : 'UPRERA24XXXXXXX',
                      onChanged: notifier.setReraNumber,
                    ),
                    const SizedBox(height: 16),

                    // GST (developer only)
                    if (_isDeveloper) ...[
                      _FieldLabel(label: 'GST number', required: false),
                      _InputField(
                        controller: _gstCtrl,
                        hint: '07AAAA0000A1Z5 (optional)',
                        onChanged: notifier.setGstNumber,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Years / Experience
                    _FieldLabel(
                      label: _isDeveloper ? 'Years in business' : 'Experience',
                      required: false,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: yearOptions.map((yr) {
                        final isSelected = selectedYear == yr;
                        return GestureDetector(
                          onTap: () => _isDeveloper
                              ? notifier.setYearsInBusiness(yr)
                              : notifier.setExperience(yr),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.grey300,
                              ),
                            ),
                            child: Text(
                              yr,
                              style: text13(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // City
                    _FieldLabel(label: 'City of operation', required: true),
                    _InputField(
                      controller: _cityCtrl,
                      hint: 'Noida, Meerut, Mumbai...',
                      onChanged: notifier.setCityOfOperation,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // ── Next Button ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: AppButton(
                title: "Next",
                onTap: () {
                  context.pushNamed(
                    AppPage.devRegisterStep2Name,
                    extra: widget.type,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared Widgets ────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final int step;
  final int total;
  const _ProgressBar({required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final filled = i < step;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
            height: 4,
            decoration: BoxDecoration(
              color: filled ? AppColors.primary : AppColors.grey200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool required;
  const _FieldLabel({required this.label, this.required = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: label,
          style: text13(fontWeight: FontWeight.w600),
          children: required
              ? [
                  TextSpan(
                    text: ' *',
                    style: text13(
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: text13(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: text13(color: AppColors.hintText),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
