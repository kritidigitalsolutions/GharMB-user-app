import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/property/providers/book_by_token_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:go_router/go_router.dart';

const _familyMemberOptions = ['1', '2', '3', '4', '5', '6+'];
const _countOptions = ['1', '2', '3', '4', '5+'];
const _maritalOptions = ['Single', 'Married', 'Divorced', 'Widowed'];
const _professionOptions = [
  'Salaried',
  'Self Employed',
  'Business Owner',
  'Freelancer',
  'Student',
  'Retired',
];
const _incomeOptions = [
  'Below ₹25,000',
  '₹25,000 – ₹50,000',
  '₹50,000 – ₹1,00,000',
  '₹1,00,000 – ₹2,00,000',
  'Above ₹2,00,000',
];

class BookWithTokenPage extends ConsumerStatefulWidget {
  final int monthlyRent;
  const BookWithTokenPage({super.key, this.monthlyRent = 28000});

  @override
  ConsumerState<BookWithTokenPage> createState() => _BookWithTokenPageState();
}

class _BookWithTokenPageState extends ConsumerState<BookWithTokenPage> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _cityCtrl.dispose();
    _companyCtrl.dispose();
    super.dispose();
  }

  void _handlePay() {
    // if (_formKey.currentState?.validate() ?? false) {
    //   final state = ref.read(bookingFormProvider);
    //   // Handle payment
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         'Booking initiated with ₹${state.selectedToken} token!',
    //         style: text13(color: AppColors.white),
    //       ),
    //       backgroundColor: AppColors.success,
    //       behavior: SnackBarBehavior.floating,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //     ),
    //   );
    //}
    context.pushNamed(AppPage.propertyReservedName);
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(bookingFormProvider);
    final notifier = ref.read(bookingFormProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
        title: Text(
          'Book with Token',
          style: text18(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Personal Details ──────────────────────────────
              _SectionCard(
                number: 1,
                title: 'Personal Details',
                child: Column(
                  children: [
                    _InputField(
                      label: 'Full Name',
                      hint: 'Enter full name',
                      controller: _nameCtrl,
                      onChanged: (v) => notifier.update(fullName: v),
                      validator: (v) => v!.isEmpty ? 'Name is required' : null,
                    ),
                    _InputField(
                      label: 'Mobile Number',
                      hint: 'Enter mobile number',
                      controller: _mobileCtrl,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onChanged: (v) => notifier.update(mobile: v),
                      validator: (v) => v!.length != 10
                          ? 'Enter valid 10-digit number'
                          : null,
                    ),
                    _InputField(
                      label: 'Email Address',
                      hint: 'Enter email address',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (v) => notifier.update(email: v),
                    ),
                    _InputField(
                      label: 'Current City',
                      hint: 'Enter current city',
                      controller: _cityCtrl,
                      onChanged: (v) => notifier.update(city: v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── 2. Family Details ────────────────────────────────
              _SectionCard(
                number: 2,
                title: 'Family Details',
                child: Column(
                  children: [
                    _DropdownField(
                      label: 'Number of Family Members',
                      hint: 'Select',
                      value: form.familyMembers.isEmpty
                          ? null
                          : form.familyMembers,
                      items: _familyMemberOptions,
                      onChanged: (v) => notifier.update(familyMembers: v ?? ''),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _DropdownField(
                            label: 'Adults',
                            hint: 'Select',
                            value: form.adults.isEmpty ? null : form.adults,
                            items: _countOptions,
                            onChanged: (v) => notifier.update(adults: v ?? ''),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DropdownField(
                            label: 'Children',
                            hint: 'Select',
                            value: form.children.isEmpty ? null : form.children,
                            items: _countOptions,
                            onChanged: (v) =>
                                notifier.update(children: v ?? ''),
                          ),
                        ),
                      ],
                    ),
                    _DropdownField(
                      label: 'Marital Status',
                      hint: 'Select',
                      value: form.maritalStatus.isEmpty
                          ? null
                          : form.maritalStatus,
                      items: _maritalOptions,
                      onChanged: (v) => notifier.update(maritalStatus: v ?? ''),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── 3. Occupation Details ────────────────────────────
              _SectionCard(
                number: 3,
                title: 'Occupation Details',
                child: Column(
                  children: [
                    _DropdownField(
                      label: 'Profession',
                      hint: 'Select profession',
                      value: form.profession.isEmpty ? null : form.profession,
                      items: _professionOptions,
                      onChanged: (v) => notifier.update(profession: v ?? ''),
                    ),
                    _InputField(
                      label: 'Company / Organisation',
                      hint: 'Enter company name',
                      controller: _companyCtrl,
                      onChanged: (v) => notifier.update(company: v),
                    ),
                    _DropdownField(
                      label: 'Monthly Income (Approx.)',
                      hint: 'Select income range',
                      value: form.monthlyIncome.isEmpty
                          ? null
                          : form.monthlyIncome,
                      items: _incomeOptions,
                      onChanged: (v) => notifier.update(monthlyIncome: v ?? ''),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── 4. Upload ID Proof ───────────────────────────────
              _SectionCard(
                number: 4,
                title: 'Upload ID Proof (Any One)',
                subtitle: 'Aadhaar / PAN / Passport / Driving License',
                child: _UploadWidget(
                  fileName: form.uploadedFileName,
                  onUpload: () {
                    // file_picker integration here
                    notifier.update(uploadedFileName: 'aadhaar_scan.pdf');
                  },
                ),
              ),
              const SizedBox(height: 16),

              // ── 5. Token Amount ──────────────────────────────────
              _SectionCard(
                number: 5,
                title: 'Token Amount',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Monthly Rent row
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Monthly Rent',
                            style: text13(color: AppColors.textSecondary),
                          ),
                          Text(
                            '₹${widget.monthlyRent.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                            style: text16(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'Select Token Amount',
                      style: text13(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),

                    // Radio options
                    Row(
                      children: [
                        _TokenRadio(
                          value: 2000,
                          label: '₹2,000',
                          groupValue: form.selectedToken,
                          onChanged: (v) => notifier.update(selectedToken: v),
                        ),
                        const SizedBox(width: 24),
                        _TokenRadio(
                          value: 5000,
                          label: '₹5,000',
                          groupValue: form.selectedToken,
                          onChanged: (v) => notifier.update(selectedToken: v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        'Token amount will be adjusted in security deposit or first month\'s rent',
                        style: text11(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ── Pay Button ─────────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Consumer(
          builder: (_, ref, _) {
            final token = ref.watch(bookingFormProvider).selectedToken;
            return SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _handlePay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Pay ₹${token.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} & Book Property',
                  style: text15(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Section Card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final int number;
  final String title;
  final String? subtitle;
  final Widget child;

  const _SectionCard({
    required this.number,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: text12(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text15(fontWeight: FontWeight.bold)),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: text11(color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.grey100),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ─── Input Field ──────────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const _InputField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: text12(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            validator: validator,
            style: text14(),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: text14(color: AppColors.hintText),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.grey300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.grey300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dropdown Field ───────────────────────────────────────────────────────────

class _DropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const _DropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: text12(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: value,
            hint: Text(hint, style: text14(color: AppColors.hintText)),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
            ),
            style: text14(),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.grey300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.grey300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ─── Upload Widget ────────────────────────────────────────────────────────────

class _UploadWidget extends StatelessWidget {
  final String? fileName;
  final VoidCallback onUpload;

  const _UploadWidget({required this.fileName, required this.onUpload});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUpload,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: fileName != null
              ? AppColors.success.withOpacity(0.05)
              : AppColors.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: fileName != null
                ? AppColors.success.withOpacity(0.5)
                : AppColors.grey300,
            width: 1.5,
            // dashed effect via custom painter below
          ),
        ),
        child: Column(
          children: [
            Icon(
              fileName != null
                  ? Icons.check_circle_outline
                  : Icons.upload_outlined,
              size: 30,
              color: fileName != null
                  ? AppColors.success
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              fileName != null ? fileName! : 'Upload Document',
              style: text13(
                fontWeight: FontWeight.w600,
                color: fileName != null
                    ? AppColors.success
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              fileName != null
                  ? 'Tap to change file'
                  : 'Only PDF, JPG or PNG files',
              style: text11(color: AppColors.hintText),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Token Radio ──────────────────────────────────────────────────────────────

class _TokenRadio extends StatelessWidget {
  final int value;
  final String label;
  final int groupValue;
  final ValueChanged<int> onChanged;

  const _TokenRadio({
    required this.value,
    required this.label,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.grey400,
                width: selected ? 5.5 : 1.5,
              ),
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: text14(
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
