import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/profile/provider/profile_provider.dart';
import 'package:gharmb_app/features/property/models/visit_request_model.dart';
import 'package:gharmb_app/features/property/providers/visit_request_provider.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/snakebar/custom_snakebar.dart';
import 'package:url_launcher/url_launcher.dart';

class SiteVisitsPage extends ConsumerStatefulWidget {
  const SiteVisitsPage({super.key});

  @override
  ConsumerState<SiteVisitsPage> createState() => _SiteVisitsPageState();
}

class _SiteVisitsPageState extends ConsumerState<SiteVisitsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedMyStatus = 'all';
  String _selectedReceivedStatus = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _makeCall(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String? phone, String propertyTitle) async {
    if (phone == null || phone.isEmpty) return;
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final msg = Uri.encodeComponent(
      'Hi, regarding the site visit for "$propertyTitle" scheduled on GharMB.',
    );
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=$msg');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomBackButton(),
        ),
        title: Text(
          'Site Visits',
          style: text18(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: text13(fontWeight: FontWeight.w600),
              unselectedLabelStyle: text13(fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'My Bookings'),
                Tab(text: 'Received Requests'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: My Bookings
          _VisitsListTab(
            isReceived: false,
            selectedStatus: _selectedMyStatus,
            onStatusChanged: (status) {
              setState(() {
                _selectedMyStatus = status;
              });
            },
            onCall: _makeCall,
            onWhatsApp: _openWhatsApp,
          ),

          // Tab 2: Received Requests
          _VisitsListTab(
            isReceived: true,
            selectedStatus: _selectedReceivedStatus,
            onStatusChanged: (status) {
              setState(() {
                _selectedReceivedStatus = status;
              });
            },
            onCall: _makeCall,
            onWhatsApp: _openWhatsApp,
          ),
        ],
      ),
    );
  }
}

class _VisitsListTab extends ConsumerWidget {
  final bool isReceived;
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;
  final Function(String?) onCall;
  final Function(String?, String) onWhatsApp;

  const _VisitsListTab({
    required this.isReceived,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onCall,
    required this.onWhatsApp,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsAsync = isReceived
        ? ref.watch(receivedVisitRequestsProvider(
            (status: selectedStatus, page: 1),
          ))
        : ref.watch(myVisitRequestsProvider(
            (status: selectedStatus, page: 1),
          ));

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        if (isReceived) {
          ref.invalidate(receivedVisitRequestsProvider);
        } else {
          ref.invalidate(myVisitRequestsProvider);
        }
      },
      child: Column(
        children: [
          // Filter Chips
          _buildFilterChips(visitsAsync.value?.counts),

          // Content List
          Expanded(
            child: visitsAsync.when(
              data: (data) {
                final list = data?.visitRequests ?? [];
                if (list.isEmpty) {
                  return _buildEmptyState(context);
                }

                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return _VisitCard(
                      visit: item,
                      isReceived: isReceived,
                      onCall: onCall,
                      onWhatsApp: onWhatsApp,
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 44, color: AppColors.error),
                      const SizedBox(height: 12),
                      Text(
                        'Failed to load visit requests',
                        style: text15(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        err.toString().replaceAll('Exception:', ''),
                        style: text12(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (isReceived) {
                            ref.invalidate(receivedVisitRequestsProvider);
                          } else {
                            ref.invalidate(myVisitRequestsProvider);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: Text(
                          'Retry',
                          style: text13(color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(VisitRequestCounts? counts) {
    final filters = [
      {'key': 'all', 'label': 'All', 'count': counts?.total},
      {'key': 'pending', 'label': 'Pending', 'count': counts?.pending},
      {'key': 'accepted', 'label': 'Accepted', 'count': counts?.accepted},
      {'key': 'rejected', 'label': 'Declined', 'count': counts?.rejected},
    ];

    return Container(
      height: 48,
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final f = filters[index];
          final isSelected = selectedStatus == f['key'];
          final count = f['count'] as int?;

          return InkWell(
            onTap: () => onStatusChanged(f['key'] as String),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.textPrimary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected ? AppColors.textPrimary : AppColors.grey300,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    f['label'] as String,
                    style: text12(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  if (count != null && count > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.white.withOpacity(0.25)
                            : AppColors.grey200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: text10(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isReceived
                  ? 'No Visit Requests Received'
                  : 'No Booked Site Visits',
              style: text16(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isReceived
                  ? 'When buyers or tenants schedule a visit for your listed properties, their requests will appear here.'
                  : 'You haven\'t requested any property site visits yet. Browse verified listings and book a free visit!',
              style: text12(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitCard extends ConsumerWidget {
  final VisitRequestModel visit;
  final bool isReceived;
  final Function(String?) onCall;
  final Function(String?, String) onWhatsApp;

  const _VisitCard({
    required this.visit,
    required this.isReceived,
    required this.onCall,
    required this.onWhatsApp,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
      'Dec'
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decisionState = ref.watch(ownerDecisionProvider);
    final isProcessing = decisionState.isLoading(visit.id);

    final statusColor = visit.isAccepted
        ? AppColors.success
        : visit.isRejected
            ? AppColors.error
            : const Color(0xFFF59E0B); // Amber for pending

    final statusBg = visit.isAccepted
        ? const Color(0xFFE8F5E9)
        : visit.isRejected
            ? const Color(0xFFFFEBEE)
            : const Color(0xFFFFF8E1);

    final statusIcon = visit.isAccepted
        ? Icons.check_circle_rounded
        : visit.isRejected
            ? Icons.cancel_rounded
            : Icons.hourglass_top_rounded;

    final propertyTitle = visit.propertyDetails?.title.isNotEmpty == true
        ? visit.propertyDetails!.title
        : visit.property?.title ?? 'Property Site Visit';

    final locality = visit.propertyDetails?.locality.isNotEmpty == true
        ? visit.propertyDetails!.locality
        : visit.property?.locality ?? '';

    final city = visit.propertyDetails?.city.isNotEmpty == true
        ? visit.propertyDetails!.city
        : visit.property?.city ?? '';

    final contactPerson = isReceived
        ? (visit.userDetails?.name.isNotEmpty == true
            ? visit.userDetails!.name
            : visit.user?.name ?? 'Visitor')
        : (visit.owner?.name.isNotEmpty == true
            ? visit.owner!.name
            : 'Property Owner');

    final contactPhone = isReceived
        ? (visit.userDetails?.phone.isNotEmpty == true
            ? visit.userDetails!.phone
            : visit.user?.phone)
        : visit.owner?.phone;

    final contactEmail = isReceived
        ? (visit.userDetails?.email.isNotEmpty == true
            ? visit.userDetails!.email
            : visit.user?.email)
        : visit.owner?.email;

    final imageUrl =
        visit.property?.images.isNotEmpty == true ? visit.property!.images.first : '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Tracker ID & Status ─────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: const Border(bottom: BorderSide(color: AppColors.grey200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      visit.visitRequestId.isNotEmpty
                          ? visit.visitRequestId
                          : '#VST-${visit.id.substring(visit.id.length > 6 ? visit.id.length - 6 : 0)}',
                      style: text12(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: visit.visitRequestId),
                        );
                        AppSnackBar.showSuccess(
                          context,
                          message: 'Visit ID copied to clipboard',
                        );
                      },
                      child: const Icon(
                        Icons.copy_rounded,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        visit.status.toUpperCase(),
                        style: text10(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Property Snapshot ────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                width: 60,
                                height: 60,
                                color: AppColors.grey200,
                              ),
                              errorWidget: (_, __, ___) => Image.asset(
                                "assets/builder.png",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              "assets/builder.png",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            propertyTitle,
                            style: text14(
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
                                  locality.isNotEmpty
                                      ? '$locality, $city'
                                      : city,
                                  style: text11(
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          if (visit.property?.expectedPrice != null &&
                              visit.property!.expectedPrice > 0) ...[
                            const SizedBox(height: 3),
                            Text(
                              '₹${visit.property!.expectedPrice}',
                              style: text12(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.grey200),
                const SizedBox(height: 12),

                // ── Visit Schedule Info ──────────────────────────────
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 15,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Visit Date',
                                    style: text10(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    _formatDate(visit.visitDate),
                                    style: text11(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 28,
                        color: AppColors.grey300,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 15,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Time Slot',
                                    style: text10(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    visit.visitTime.isNotEmpty
                                        ? visit.visitTime
                                        : 'Not specified',
                                    style: text11(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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

                // ── Visitor / Owner Contact Bar ───────────────────────
                const SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.primary.withOpacity(0.12),
                      child: Text(
                        contactPerson.isNotEmpty
                            ? contactPerson[0].toUpperCase()
                            : 'U',
                        style: text11(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$contactPerson (${isReceived ? "Visitor" : "Owner"})',
                            style: text12(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (contactPhone != null && contactPhone.isNotEmpty)
                            Text(
                              contactPhone,
                              style: text11(color: AppColors.textSecondary),
                            ),
                        ],
                      ),
                    ),
                    if (contactPhone != null && contactPhone.isNotEmpty) ...[
                      InkWell(
                        onTap: () => onCall(contactPhone),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.phone_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => onWhatsApp(contactPhone, propertyTitle),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline,
                            size: 16,
                            color: Color(0xFF25D366),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // ── Visitor Notes (if any) ───────────────────────────
                if (visit.notes != null && visit.notes!.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.sticky_note_2_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Visitor Note: "${visit.notes!}"',
                            style: text11(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ── Rejection Message Box (if rejected) ───────────────
                if (visit.isRejected) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.highlight_off_rounded,
                              size: 16,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Declined by Owner',
                              style: text12(
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                        if (visit.ownerMessage != null &&
                            visit.ownerMessage!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Owner Note: "${visit.ownerMessage!}"',
                            style: text11(
                              color: const Color(0xFF991B1B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],

                // ── Accepted Confirmation Box (if accepted) ───────────
                if (visit.isAccepted) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Visit Confirmed! Please visit the property on scheduled time.',
                            style: text11(
                              color: const Color(0xFF166534),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ── Owner Decision Buttons (Accept / Reject) ───────────
                // Only shown if current tab is Received Requests AND request is Pending
                if (isReceived && visit.isPending) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      // Reject Button -> Opens Decline Dialog
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isProcessing
                              ? null
                              : () => _showRejectDialog(context, ref, visit),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.close_rounded, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Decline',
                                style: text12(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Accept Button -> Instant confirmation
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isProcessing
                              ? null
                              : () async {
                                  await ref
                                      .read(ownerDecisionProvider.notifier)
                                      .acceptRequest(
                                        context: context,
                                        requestId: visit.id,
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            elevation: 0,
                          ),
                          child: isProcessing
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_rounded,
                                        size: 16, color: AppColors.white),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Accept Visit',
                                      style: text12(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(
    BuildContext context,
    WidgetRef ref,
    VisitRequestModel visit,
  ) {
    final messageController = TextEditingController();
    final quickReasons = [
      'Unavailable on this date/time',
      'Property under maintenance',
      'Already booked with another visitor',
      'Please reschedule for weekday evening',
      'Out of town on this weekend',
    ];

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.highlight_off_rounded,
                            color: AppColors.error,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Decline Visit Request',
                                style: text16(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Provide a reason or next available slot',
                                style: text11(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Quick suggestion chips
                    Text(
                      'Quick Reasons',
                      style: text11(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: quickReasons.map((reason) {
                        return InkWell(
                          onTap: () {
                            setModalState(() {
                              messageController.text = reason;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.grey300),
                            ),
                            child: Text(
                              reason,
                              style: text10(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 14),

                    // Message box TextField
                    Text(
                      'Message to Visitor *',
                      style: text12(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: messageController,
                      maxLines: 3,
                      style: text13(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText:
                            'e.g., Unavailable on Sunday due to society meeting. Please reschedule for Tuesday 3:00 PM - 6:00 PM.',
                        hintStyle: text11(color: AppColors.hintText),
                        filled: true,
                        fillColor: AppColors.grey50,
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.grey300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.error,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
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
                              'Cancel',
                              style: text13(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final msg = messageController.text.trim();
                              if (msg.isEmpty) {
                                AppSnackBar.showWarning(
                                  context,
                                  title: 'Message Required',
                                  message:
                                      'Please enter a reason or proposed time slot.',
                                );
                                return;
                              }

                              Navigator.of(dialogCtx).pop();

                              await ref
                                  .read(ownerDecisionProvider.notifier)
                                  .rejectRequest(
                                    context: context,
                                    requestId: visit.id,
                                    ownerMessage: msg,
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                            ),
                            child: Text(
                              'Confirm Decline',
                              style: text13(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
