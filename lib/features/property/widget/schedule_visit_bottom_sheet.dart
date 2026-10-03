import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/profile/provider/profile_provider.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';
import 'package:gharmb_app/features/property/providers/visit_request_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

/// Function to show the custom Schedule Visit BottomSheet
void showScheduleVisitBottomSheet(
  BuildContext context, {
  Property? property,
  String? propertyId,
  String? title,
  String? locality,
  String? city,
  String? imageUrl,
  String? ownerId,
  String? ownerName,
  String? ownerPhone,
}) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder: (modalContext) => ScheduleVisitBottomSheet(
      property: property,
      propertyId: propertyId,
      title: title,
      locality: locality,
      city: city,
      imageUrl: imageUrl,
      ownerId: ownerId,
      ownerName: ownerName,
      ownerPhone: ownerPhone,
    ),
  );
}

class ScheduleVisitBottomSheet extends ConsumerStatefulWidget {
  final Property? property;
  final String? propertyId;
  final String? title;
  final String? locality;
  final String? city;
  final String? imageUrl;
  final String? ownerId;
  final String? ownerName;
  final String? ownerPhone;

  const ScheduleVisitBottomSheet({
    super.key,
    this.property,
    this.propertyId,
    this.title,
    this.locality,
    this.city,
    this.imageUrl,
    this.ownerId,
    this.ownerName,
    this.ownerPhone,
  });

  @override
  ConsumerState<ScheduleVisitBottomSheet> createState() =>
      _ScheduleVisitBottomSheetState();
}

class _ScheduleVisitBottomSheetState
    extends ConsumerState<ScheduleVisitBottomSheet> {
  final TextEditingController _notesController = TextEditingController();
  late List<DateTime> _quickDates;
  DateTime? _selectedDate;
  String _selectedSlot = '10:00 AM - 11:00 AM';

  final List<String> _morningSlots = [
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
  ];

  final List<String> _afternoonSlots = [
    '12:00 PM - 01:00 PM',
    '02:00 PM - 03:00 PM',
    '03:00 PM - 04:00 PM',
  ];

  final List<String> _eveningSlots = [
    '04:00 PM - 05:00 PM',
    '05:00 PM - 06:00 PM',
    '06:00 PM - 07:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Default to tomorrow or today if early
    _selectedDate = now.add(const Duration(days: 1));
    _quickDates = List.generate(7, (i) => now.add(Duration(days: i + 1)));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(scheduleVisitProvider.notifier).setDate(_selectedDate!);
        ref.read(scheduleVisitProvider.notifier).setTimeSlot(_selectedSlot);
      }
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _formatDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _formatMonthName(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[date.month - 1];
  }

  String _formatFullDate(DateTime date) {
    return '${_formatDayName(date)}, ${date.day} ${_formatMonthName(date)} ${date.year}';
  }

  Future<void> _pickCustomDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      ref.read(scheduleVisitProvider.notifier).setDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleState = ref.watch(scheduleVisitProvider);
    final user = ref.watch(userModelProvider);

    final propId = widget.propertyId ??
        widget.property?.id ??
        widget.property?.mongoId ??
        '';
    final propTitle = widget.title ??
        (widget.property?.title.isNotEmpty == true
            ? widget.property!.title
            : (widget.property != null
                ? '${widget.property!.bedrooms} BHK ${widget.property!.propertyType}'
                : 'Site Visit'));
    final propLocality = widget.locality ?? widget.property?.locality ?? '';
    final propCity = widget.city ?? widget.property?.city ?? '';
    final propImage = widget.imageUrl ??
        (widget.property?.images.isNotEmpty == true
            ? widget.property!.images.first
            : '');
    final propOwnerId = widget.ownerId ?? widget.property?.owner.id ?? '';
    final propOwnerName =
        widget.ownerName ?? widget.property?.owner.name ?? '';
    final isOwner = user?.id != null &&
        user!.id != null &&
        user.id!.isNotEmpty &&
        propOwnerId.isNotEmpty &&
        user.id == propOwnerId;

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle Bar ──────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // ── Header Title & Close ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule Site Visit',
                        style: text18(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Select convenient date & time to visit',
                        style: text11(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                  ),
                  splashRadius: 20,
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.grey200),

          // ── Scrollable Body ─────────────────────────────────────────
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding + 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Property Info Card ──────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: propImage.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: propImage,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    width: 64,
                                    height: 64,
                                    color: AppColors.grey200,
                                  ),
                                  errorWidget: (_, __, ___) => Image.asset(
                                    "assets/builder.png",
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  "assets/builder.png",
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                propTitle,
                                style: text13(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 2),
                                  Expanded(
                                    child: Text(
                                      propLocality.isNotEmpty
                                          ? (propCity.isNotEmpty
                                              ? '$propLocality, $propCity'
                                              : propLocality)
                                          : propCity,
                                      style: text11(
                                        color: AppColors.textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(
                                        0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Free Visit',
                                      style: text10(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  if (propOwnerName.isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Developer: $propOwnerName',
                                        style: text10(
                                          color: AppColors.textSecondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (isOwner) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.warning),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.warning,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'You are the owner of this property. Owners cannot schedule visits to their own properties.',
                              style: text12(color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // ── Section 1: Preferred Date ───────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Select Visit Date',
                            style: text14(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: _pickCustomDate,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit_calendar_outlined,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'More Dates',
                                style: text12(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Date quick chips
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _quickDates.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final date = _quickDates[index];
                        final isSelected =
                            _selectedDate != null &&
                            _selectedDate!.year == date.year &&
                            _selectedDate!.month == date.month &&
                            _selectedDate!.day == date.day;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedDate = date;
                            });
                            ref
                                .read(scheduleVisitProvider.notifier)
                                .setDate(date);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 66,
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.grey50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.grey300,
                                width: isSelected ? 1.5 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatDayName(date),
                                  style: text11(
                                    color: isSelected
                                        ? AppColors.white.withOpacity(0.9)
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${date.day}',
                                  style: text16(
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _formatMonthName(date),
                                  style: text10(
                                    color: isSelected
                                        ? AppColors.white.withOpacity(0.85)
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  if (_selectedDate != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F8E9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.event_available,
                            size: 14,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Selected Date: ${_formatFullDate(_selectedDate!)}',
                            style: text11(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 22),

                  // ── Section 2: Time Slots ───────────────────────────
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Select Convenient Time Slot',
                        style: text14(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _buildSlotCategory('🌅 Morning Slots', _morningSlots),
                  const SizedBox(height: 10),
                  _buildSlotCategory('☀️ Afternoon Slots', _afternoonSlots),
                  const SizedBox(height: 10),
                  _buildSlotCategory('🌆 Evening Slots', _eveningSlots),

                  const SizedBox(height: 22),

                  // ── Section 3: Notes / Questions ────────────────────
                  Row(
                    children: [
                      const Icon(
                        Icons.edit_note_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Note for Owner (Optional)',
                        style: text14(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    onChanged: (val) {
                      ref.read(scheduleVisitProvider.notifier).setNotes(val);
                    },
                    maxLines: 3,
                    style: text13(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText:
                          'e.g., Interested in checking sunlight, ventilation, parking space, or society amenities...',
                      hintStyle: text12(color: AppColors.hintText),
                      filled: true,
                      fillColor: AppColors.grey50,
                      contentPadding: const EdgeInsets.all(12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.grey300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Visitor Info Note ───────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.contact_mail_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user?.name != null && user!.name!.isNotEmpty
                                ? 'Booking as ${user.name} (${user.phone ?? ""})'
                                : 'Your registered contact details will be shared with the owner.',
                            style: text11(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Error Message
                  if (scheduleState.error != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              scheduleState.error!,
                              style: text12(color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // ── Submit Button ───────────────────────────────────
                  AppButton(
                    title: isOwner
                        ? 'Owner Cannot Schedule'
                        : 'Confirm & Send Visit Request',
                    isLoading: scheduleState.isLoading,
                    color: isOwner ? AppColors.grey400 : AppColors.primary,
                    onTap: isOwner
                        ? null
                        : () async {
                            final success = await ref
                                .read(scheduleVisitProvider.notifier)
                                .submitVisitRequest(
                                  context: context,
                                  propertyId: propId,
                                );

                            if (success && context.mounted) {
                              Navigator.of(context).pop();
                              _showSuccessDialog(
                                context,
                                date: _selectedDate!,
                                timeSlot: _selectedSlot,
                                propertyTitle: propTitle,
                              );
                            }
                          },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotCategory(String title, List<String> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: text11(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: slots.map((slot) {
            final isSelected = _selectedSlot == slot;
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedSlot = slot;
                });
                ref.read(scheduleVisitProvider.notifier).setTimeSlot(slot);
              },
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.grey50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.grey300,
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  slot,
                  style: text12(
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showSuccessDialog(
    BuildContext context, {
    required DateTime date,
    required String timeSlot,
    required String propertyTitle,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 42,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Visit Requested! 🎉',
                style: text18(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your site visit request for "$propertyTitle" has been sent to the owner.',
                style: text12(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.event,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatFullDate(date),
                          style: text12(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          timeSlot,
                          style: text12(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(dialogCtx).pop(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Done',
                        style: text13(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogCtx).pop();
                        context.pushNamed(AppPage.siteVisitsName);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'View Visits',
                        style: text13(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
