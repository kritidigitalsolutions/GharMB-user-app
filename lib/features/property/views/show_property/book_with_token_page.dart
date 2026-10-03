import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/profile/provider/profile_provider.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';
import 'package:gharmb_app/features/property/models/token_booking_model.dart';
import 'package:gharmb_app/features/property/providers/book_by_token_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/snakebar/custom_snakebar.dart';
import 'package:go_router/go_router.dart';

const _familyMemberOptions = ['1', '2', '3', '4', '5', '6+'];
const _countOptions = ['0', '1', '2', '3', '4', '5+'];
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
const _idProofTypes = ['Aadhaar', 'PAN Card', 'Passport', 'Driving License'];

class BookWithTokenPage extends ConsumerStatefulWidget {
  final Property? property;
  final String? propertyId;
  final int monthlyRent;
  final String? propertyTitle;

  const BookWithTokenPage({
    super.key,
    this.property,
    this.propertyId,
    this.monthlyRent = 28000,
    this.propertyTitle,
  });

  @override
  ConsumerState<BookWithTokenPage> createState() => _BookWithTokenPageState();
}

class _BookWithTokenPageState extends ConsumerState<BookWithTokenPage> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  late final TextEditingController _nameCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _companyCtrl;

  bool _initializedProfile = false;

  String get _effectivePropertyId {
    if (widget.property != null) {
      if (widget.property!.id.isNotEmpty) return widget.property!.id;
      if (widget.property!.mongoId.isNotEmpty) return widget.property!.mongoId;
    }
    return widget.propertyId ?? '';
  }

  int get _effectiveRent =>
      widget.property != null && widget.property!.price > 0
          ? widget.property!.price
          : widget.monthlyRent;

  String get _effectiveTitle => widget.property?.title.isNotEmpty == true
      ? widget.property!.title
      : (widget.propertyTitle ?? 'Selected Property');

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _mobileCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _companyCtrl = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefillUserData();
    });
  }

  void _prefillUserData() {
    if (_initializedProfile) return;
    _initializedProfile = true;

    final user = ref.read(userModelProvider);
    final notifier = ref.read(bookingFormProvider.notifier);

    if (user != null) {
      if (user.name?.isNotEmpty == true) {
        _nameCtrl.text = user.name!;
      }
      if (user.phone?.isNotEmpty == true) {
        String cleanPhone = user.phone!.replaceAll(RegExp(r'^\+91|\D'), '');
        if (cleanPhone.length > 10) {
          cleanPhone = cleanPhone.substring(cleanPhone.length - 10);
        }
        _mobileCtrl.text = cleanPhone;
      }
      if (user.email?.isNotEmpty == true) {
        _emailCtrl.text = user.email!;
      }
      if (user.address?.city?.isNotEmpty == true) {
        _cityCtrl.text = user.address!.city!;
      }

      notifier.initializeWithDefaults(
        name: _nameCtrl.text,
        phone: _mobileCtrl.text,
        email: _emailCtrl.text,
        city: _cityCtrl.text,
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _cityCtrl.dispose();
    _companyCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadDocument() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final success = await ref
            .read(bookingFormProvider.notifier)
            .uploadDocument(file);

        if (mounted) {
          if (success) {
            AppSnackBar.show(
              context,
              message: 'ID Proof uploaded successfully!',
              type: SnackBarType.success,
            );
          } else {
            AppSnackBar.show(
              context,
              message: 'Failed to upload document. Please retry.',
              type: SnackBarType.error,
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'Error picking file: $e',
          type: SnackBarType.error,
        );
      }
    }
  }

  Future<void> _handlePay() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      AppSnackBar.show(
        context,
        message: 'Please fill all required fields correctly.',
        type: SnackBarType.error,
      );
      return;
    }

    final form = ref.read(bookingFormProvider);
    final propId = _effectivePropertyId;

    if (propId.isEmpty) {
      AppSnackBar.show(
        context,
        message: 'Invalid property ID. Unable to proceed.',
        type: SnackBarType.error,
      );
      return;
    }

    final notifier = ref.read(bookingFormProvider.notifier);
    final result = await notifier.submitBooking(
      propertyId: propId,
      monthlyRent: _effectiveRent,
      priceLabel: '₹${_formatNumber(_effectiveRent)}',
    );

    if (!mounted) return;

    if (result != null) {
      AppSnackBar.show(
        context,
        message: 'Token booking submitted successfully!',
        type: SnackBarType.success,
      );
      context.pushReplacementNamed(AppPage.propertyReservedName, extra: result);
    } else {
      final err =
          ref.read(bookingFormProvider).errorMessage ??
          'Payment or submission failed. Please try again.';
      AppSnackBar.show(context, message: err, type: SnackBarType.error);
    }
  }

  String _formatNumber(int val) {
    return val.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(bookingFormProvider);
    final notifier = ref.read(bookingFormProvider.notifier);

    // Watch config if propertyId is available
    final configAsync = _effectivePropertyId.isNotEmpty
        ? ref.watch(tokenConfigProvider(_effectivePropertyId))
        : null;

    final tokenConfig = configAsync?.value;
    final tokenAmounts = (tokenConfig?.tokenAmounts.isNotEmpty ?? false)
        ? tokenConfig!.tokenAmounts
        : [2000, 5000];

    final adjustmentNote =
        tokenConfig?.adjustmentNote ??
        "Token amount will be adjusted in security deposit or first month's rent";

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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Property Info Header ─────────────────────────────
              if (_effectiveTitle.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.apartment_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _effectiveTitle,
                              style: text14(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Monthly Rent: ₹${_formatNumber(_effectiveRent)}',
                              style: text12(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

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
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Name is required'
                          : null,
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
                      validator: (v) => (v == null || v.length != 10)
                          ? 'Enter valid 10-digit number'
                          : null,
                    ),
                    _InputField(
                      label: 'Email Address',
                      hint: 'Enter email address',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (v) => notifier.update(email: v),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(v.trim())) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    _InputField(
                      label: 'Current City',
                      hint: 'Enter current city',
                      controller: _cityCtrl,
                      onChanged: (v) => notifier.update(city: v),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'City is required'
                          : null,
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
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Company name is required'
                          : null,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DropdownField(
                      label: 'Select ID Proof Type',
                      hint: 'Select ID Type',
                      value: form.idProofType.isEmpty
                          ? 'Aadhaar'
                          : form.idProofType,
                      items: _idProofTypes,
                      onChanged: (v) =>
                          notifier.update(idProofType: v ?? 'Aadhaar'),
                    ),
                    const SizedBox(height: 4),
                    _UploadWidget(
                      fileName: form.uploadedFileName,
                      isLoading: form.isUploadingDoc,
                      onUpload: _pickAndUploadDocument,
                    ),
                  ],
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
                            '₹${_formatNumber(_effectiveRent)}',
                            style: text16(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'Select Token Amount',
                      style: text13(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Dynamic Radio options
                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      children: tokenAmounts.map((amt) {
                        return _TokenRadio(
                          value: amt,
                          label: '₹${_formatNumber(amt)}',
                          groupValue: form.selectedToken,
                          onChanged: (v) => notifier.update(selectedToken: v),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              adjustmentNote,
                              style: text11(
                                color: AppColors.textSecondary,
                              ).copyWith(height: 1.4),
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
            final formState = ref.watch(bookingFormProvider);
            final token = formState.selectedToken;
            final isBusy = formState.isSubmitting || formState.isUploadingDoc;

            return SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isBusy ? null : _handlePay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isBusy
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Pay ₹${_formatNumber(token)} & Book Property',
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
                Expanded(
                  child: Column(
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
            value: (value != null && items.contains(value)) ? value : null,
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
  final bool isLoading;
  final VoidCallback onUpload;

  const _UploadWidget({
    required this.fileName,
    this.isLoading = false,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onUpload,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
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
          ),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Column(
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
                        : 'Only PDF, JPG or PNG files (up to 15MB)',
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
        mainAxisSize: MainAxisSize.min,
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
