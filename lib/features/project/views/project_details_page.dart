import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/project/provider/project_provider.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';
import 'package:gharmb_app/features/property/widget/schedule_visit_bottom_sheet.dart';
import 'package:gharmb_app/features/wishlist/providers/wishlist_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/snakebar/custom_snakebar.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailPage extends ConsumerStatefulWidget {
  const ProjectDetailPage({super.key});

  @override
  ConsumerState<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends ConsumerState<ProjectDetailPage> {
  int _currentImageIndex = 0;

  IconData _getAmenityIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('pool') || lower.contains('swim')) return Icons.pool;
    if (lower.contains('gym') || lower.contains('fit')) {
      return Icons.fitness_center;
    }
    if (lower.contains('club')) return Icons.sports_tennis_outlined;
    if (lower.contains('play') || lower.contains('kid')) {
      return Icons.child_friendly;
    }
    if (lower.contains('security') ||
        lower.contains('guard') ||
        lower.contains('cctv')) {
      return Icons.security;
    }
    if (lower.contains('park') || lower.contains('garden')) {
      return Icons.park_outlined;
    }
    if (lower.contains('power') ||
        lower.contains('backup') ||
        lower.contains('generator')) {
      return Icons.bolt;
    }
    if (lower.contains('lift') || lower.contains('elevator')) {
      return Icons.elevator;
    }
    if (lower.contains('wifi') || lower.contains('internet')) return Icons.wifi;
    if (lower.contains('water')) return Icons.water_drop_outlined;
    if (lower.contains('car') || lower.contains('parking')) {
      return Icons.directions_car_outlined;
    }
    return Icons.verified_outlined;
  }

  String _formatAmenityName(String name) {
    final lower = name.toLowerCase().trim();
    if (lower == 'powerbackup' || lower == 'power_backup') return 'Power Backup';
    if (lower == 'cctv' || lower == 'cctvcamera') return 'CCTV Security';
    if (lower == 'swimmingpool') return 'Swimming Pool';
    if (lower == 'clubhouse') return 'Clubhouse';
    if (lower == 'kidsplayarea' || lower == 'playarea') return 'Kids Play Area';
    return name;
  }

  String _formatFurnishing(String? raw) {
    if (raw == null || raw.trim().isEmpty) return 'Unfurnished';
    final lower = raw.toLowerCase().trim();
    if (lower == 'semifurnished' ||
        lower == 'semi-furnished' ||
        lower == 'semi furnished') {
      return 'Semi-Furnished';
    }
    if (lower == 'unfurnished' ||
        lower == 'un-furnished' ||
        lower == 'un furnished') {
      return 'Unfurnished';
    }
    if (lower == 'fullyfurnished' ||
        lower == 'fully-furnished' ||
        lower == 'furnished') {
      return 'Fully Furnished';
    }
    return raw;
  }

  String _formatPossession(String raw) {
    final lower = raw.toLowerCase().trim();
    if (lower == 'fifteenplus' || lower == 'fifteen_plus') {
      return '15+ Days';
    }
    if (lower == 'immediate') {
      return 'Immediate';
    }
    if (lower == 'readytomove' || lower == 'ready to move') {
      return 'Ready to Move';
    }
    return raw;
  }

  String _formatFacing(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    if (raw.contains(',')) return 'Multiple';
    return raw;
  }

  Property _getOrCreateProperty(ProjectModel project) {
    if (project.property != null) return project.property!;
    return Property(
      location: Location(type: 'Point', coordinates: [0.0, 0.0]),
      id: project.id,
      mongoId: project.id,
      listingAs: project.developer,
      category: 'residential',
      listingFor: 'Buy',
      propertyType: 'Apartment',
      title: project.name,
      city: project.distance,
      locality: project.location,
      fullAddress: project.fullAddress ?? project.location,
      pincode: '',
      description: project.description ?? '',
      bedrooms: project.bhkTypes,
      bathrooms: project.bathrooms ?? '1',
      carpetArea: project.carpetArea ?? 0,
      builtUpArea: project.builtUpArea ?? 0,
      floorNo: project.floorNo ?? '1',
      totalFloors: project.totalFloors ?? '1',
      ageOfProperty: '',
      furnishing: project.furnishing ?? '',
      facingDirection: project.facing ?? '',
      parking: project.parking ?? '1',
      amenities: project.amenities,
      preferredTenants: const [],
      petsAllowed: false,
      smokingAllowed: false,
      brokerageFree: true,
      rentNegotiable: false,
      images: project.images,
      price: project.price ?? 0,
      securityDeposit: 0,
      maintenanceCharges: 0,
      maintenanceIncludedInRent: false,
      brokerageFee: 0,
      otherCharges: 0,
      vastuCompliant: false,
      keyHandover: false,
      isVerified: project.isVerified || project.reraApproved,
      openToAllBuyers: true,
      loanAssistanceNeeded: false,
      listingTier: '',
      allowInstallments: project.allowInstallments,
      installmentDetails: project.installmentDetails,
      owner: Owner(
        id: project.ownerId ?? '',
        name: project.developer,
        phone: project.ownerPhone ?? '',
        profilePicture: '',
        isVerified: project.isVerified || project.reraApproved,
      ),
      approvalStatus: 'approved',
      isLive: true,
      viewsCount: project.interested,
      shortlistedCount: project.interested,
      inquiriesCount: 0,
      tokensCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      submissionId: '',
      version: 1,
    );
  }

  Future<void> _makeCall(String? phone) async {
    if (phone == null || phone.trim().isEmpty) {
      AppSnackBar.showError(context, message: "Contact number not available");
      return;
    }
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse("tel:$cleanPhone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        AppSnackBar.showError(context, message: "Could not launch dialer");
      }
    }
  }

  Future<void> _openWhatsApp(String? phone, String propTitle) async {
    if (phone == null || phone.trim().isEmpty) {
      AppSnackBar.showError(context, message: "WhatsApp number not available");
      return;
    }
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final msg = Uri.encodeComponent(
      "Hello, I am interested in exploring '$propTitle' on GharMB.",
    );
    final uri = Uri.parse("https://wa.me/$cleanPhone?text=$msg");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        AppSnackBar.showError(context, message: "Could not open WhatsApp");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(selectedProjectProvider) ?? _defaultProject;
    final wishlistState = ref.watch(wishlistProvider);
    final isWishlisted = wishlistState.items.any(
      (item) =>
          item.id == project.id ||
          (item.property != null && item.property!.id == project.id),
    );

    final List<String> images = project.images.isNotEmpty
        ? project.images
        : (project.imageUrl != null && project.imageUrl!.isNotEmpty
              ? [project.imageUrl!]
              : <String>[]);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero SliverAppBar ──────────────────────────────────
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ),
                actions: [
                  // Wishlist / Favorite Icon (Replaces Notification Bell)
                  GestureDetector(
                    onTap: () async {
                      final added = await ref
                          .read(wishlistProvider.notifier)
                          .toggleWishlist(
                            propertyId: project.id,
                            itemType: 'Property',
                          );
                      if (context.mounted) {
                        AppSnackBar.showSuccess(
                          context,
                          title: added ? 'Wishlisted' : 'Removed',
                          message: added
                              ? 'Added to your wishlist!'
                              : 'Removed from wishlist!',
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 6, top: 8, bottom: 8),
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted ? AppColors.error : AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  // Share Button
                  Container(
                    margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.share_outlined,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Photo PageView
                      if (images.isNotEmpty)
                        PageView.builder(
                          itemCount: images.length,
                          onPageChanged: (idx) {
                            setState(() {
                              _currentImageIndex = idx;
                            });
                          },
                          itemBuilder: (ctx, idx) {
                            return CachedNetworkImage(
                              imageUrl: images[idx],
                              fit: BoxFit.fill,
                              placeholder: (_, __) => Container(
                                color: const Color(0xFF2C1B00),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color: const Color(0xFF1E293B),
                                child: const Center(
                                  child: Icon(
                                    Icons.business_outlined,
                                    color: AppColors.grey400,
                                    size: 48,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      else
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.business_outlined,
                              color: AppColors.grey400,
                              size: 56,
                            ),
                          ),
                        ),

                      // Bottom Gradient overlay
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),

                      // RERA / Verified badge
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: _BadgeChip(
                          label: project.reraApproved
                              ? '✓ RERA Approved'
                              : '✓ Verified Project',
                          bg: AppColors.success,
                        ),
                      ),

                      // Ready / Possession badge
                      Positioned(
                        bottom: 12,
                        right: images.length > 1 ? 70 : 12,
                        child: _BadgeChip(
                          label: project.readyToMove
                              ? '⚡ Ready to Move'
                              : '⏳ ${_formatPossession(project.possession)}',
                          bg: const Color(0xFFF39C12),
                        ),
                      ),

                      // Photos counter badge
                      if (images.length > 1)
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.photo_library_outlined,
                                  color: AppColors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_currentImageIndex + 1}/${images.length}',
                                  style: text11(color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Body Content ──────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Name + Price + Location ───────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project.name,
                                    style: text20(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 2),
                                      Expanded(
                                        child: Text(
                                          '${project.location} • ${project.distance}',
                                          style: text12(
                                            color: AppColors.textSecondary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Starting Price',
                                  style: text11(color: AppColors.textSecondary),
                                ),
                                Text(
                                  project.startingPrice,
                                  style: text18(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  'All inclusive',
                                  style: text10(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── 4-stat row ───────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.grey50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: Row(
                            children: [
                              _QuadStat(
                                value: project.bhkTypes,
                                label: 'BHK Types',
                              ),
                              _VDivider(),
                              _QuadStat(
                                value: project.carpetArea != null &&
                                        project.carpetArea! > 0
                                    ? '${project.carpetArea} sq ft'
                                    : '${project.totalUnits} Units',
                                label: project.carpetArea != null &&
                                        project.carpetArea! > 0
                                    ? 'Carpet Area'
                                    : 'Total Units',
                              ),
                              _VDivider(),
                              _QuadStat(
                                value: _formatFurnishing(project.furnishing),
                                label: 'Furnishing',
                              ),
                              _VDivider(),
                              _QuadStat(
                                value: _formatPossession(project.possession),
                                label: 'Possession',
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ── Installment / EMI Plan (if allowed) ─────────
                      if (project.allowInstallments)
                        _ProjectInstallmentPlanCard(project: project),

                      const SizedBox(height: 18),
                      _SectionDivider(),

                      // ── Project Highlights ───────────────────────────
                      _SectionTitle('Project Highlights'),
                      SizedBox(
                        height: 90,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            if (project.allowInstallments)
                              const _HighlightTile(
                                icon: Icons.payments_outlined,
                                label: 'EMI Plan\nAvailable',
                              ),
                            _HighlightTile(
                              icon: Icons.verified_outlined,
                              label: project.reraApproved
                                  ? 'RERA\nApproved'
                                  : 'GharMB\nVerified',
                            ),
                            if (project.readyToMove)
                              const _HighlightTile(
                                icon: Icons.home_outlined,
                                label: 'Ready to\nMove',
                              ),
                            if (project.furnishing?.isNotEmpty == true)
                              _HighlightTile(
                                icon: Icons.chair_outlined,
                                label: _formatFurnishing(project.furnishing),
                              ),
                            if (project.parking?.isNotEmpty == true)
                              _HighlightTile(
                                icon: Icons.directions_car_outlined,
                                label: '${project.parking}\nParking',
                              ),
                            if (project.facing?.isNotEmpty == true)
                              _HighlightTile(
                                icon: Icons.explore_outlined,
                                label: '${_formatFacing(project.facing)}\nFacing',
                              ),
                            const _HighlightTile(
                              icon: Icons.sports_outlined,
                              label: 'Premium\nClubhouse',
                            ),
                            const _HighlightTile(
                              icon: Icons.security,
                              label: '24x7\nSecurity',
                            ),
                            const _HighlightTile(
                              icon: Icons.park_outlined,
                              label: '70% Open\nSpace',
                            ),
                          ],
                        ),
                      ),

                      if (project.description?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        _SectionDivider(),
                        _SectionTitle('About Property'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            project.description!,
                            style: text13(color: AppColors.textSecondary)
                                .copyWith(height: 1.5),
                          ),
                        ),
                      ],

                      const SizedBox(height: 8),
                      _SectionDivider(),

                      // ── Investment Score ─────────────────────────────
                      _SectionTitle('Investment Score'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.grey200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '8.9',
                                            style: text18(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '/ 10',
                                            style: text10(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Excellent',
                                    style: text12(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  children: scoreItems
                                      .map((s) => _ScoreBar(item: s))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      _SectionDivider(),

                      // ── Price & Unit Details ─────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price & Unit Details',
                              style: text16(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              project.bhkTypes,
                              style: text13(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        child: _PriceUnitRow(
                          unit: PriceUnit(
                            bhk: project.bhkTypes,
                            area: project.carpetArea != null &&
                                    project.carpetArea! > 0
                                ? '${project.carpetArea} sq ft Carpet'
                                : 'Standard Unit',
                            priceRange: project.startingPrice,
                            status: project.readyToMove
                                ? 'Ready'
                                : 'Booking Open',
                          ),
                        ),
                      ),

                      _SectionDivider(),

                      // ── Amenities ────────────────────────────────────
                      if (project.amenities.isNotEmpty) ...[
                        _SectionTitle('Amenities'),
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: project.amenities.length,
                            itemBuilder: (context, idx) {
                              final item = project.amenities[idx];
                              return _HighlightTile(
                                icon: _getAmenityIcon(item),
                                label: _formatAmenityName(item),
                              );
                            },
                          ),
                        ),
                        _SectionDivider(),
                      ],

                      // ── Builder Info ─────────────────────────────────
                      _SectionTitle('Builder Information'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.grey50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.textPrimary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    project.developer.isNotEmpty
                                        ? project.developer
                                            .substring(
                                              0,
                                              math.min(
                                                2,
                                                project.developer.length,
                                              ),
                                            )
                                            .toUpperCase()
                                        : 'MB',
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      project.developer,
                                      style: text14(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '• Verified Builder Partner',
                                      style: text11(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      '• GharMB Trust Guaranteed',
                                      style: text11(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      '• 4.8 Trust Score',
                                      style: text11(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'RERA Status',
                                    style: text10(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    project.reraApproved
                                        ? 'APPROVED'
                                        : 'VERIFIED',
                                    style: text11(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    project.location,
                                    style: text10(
                                      color: AppColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      _SectionDivider(),

                      // ── Location & Nearby ────────────────────────────
                      _SectionTitle('Location & Nearby'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _NearbyItem(
                              place: NearbyPlace(
                                project.location,
                                project.distance,
                                'orange',
                              ),
                            ),
                            const _NearbyItem(
                              place: NearbyPlace(
                                'City Center',
                                '1.5 km',
                                'blue',
                              ),
                            ),
                            const _NearbyItem(
                              place: NearbyPlace(
                                'Nearest Metro/Bus',
                                '0.8 km',
                                'green',
                              ),
                            ),
                            const _NearbyItem(
                              place: NearbyPlace(
                                'Hospital & Medical',
                                '1.2 km',
                                'red',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── Gallery (Only displayed if real images exist) ──
                      if (images.isNotEmpty) ...[
                        _SectionDivider(),
                        _SectionTitle('Gallery (${images.length} Photos)'),
                        SizedBox(
                          height: 95,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: images.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, idx) {
                              final img = images[idx];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: img,
                                  width: 130,
                                  height: 95,
                                  fit: BoxFit.fill,
                                  placeholder: (_, __) => Container(
                                    width: 130,
                                    height: 95,
                                    color: AppColors.grey200,
                                  ),
                                  errorWidget: (_, __, ___) => Container(
                                    width: 130,
                                    height: 95,
                                    color: AppColors.grey300,
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],

                      const SizedBox(height: 10),

                      // ── Site Visit Banner ────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Site Visit Available',
                                      style: text14(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Book a free site visit and get best offers',
                                      style: text11(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  showScheduleVisitBottomSheet(
                                    context,
                                    propertyId: project.id,
                                    title: project.name,
                                    locality: project.location,
                                    city: project.location,
                                    imageUrl: project.images.isNotEmpty
                                        ? project.images.first
                                        : project.imageUrl,
                                    ownerId: project.ownerId,
                                    ownerName: project.developer,
                                    ownerPhone: project.ownerPhone,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Schedule Visit',
                                  style: text12(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Trust Badges ─────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            _TrustBadge(
                              icon: Icons.verified_outlined,
                              label: '100% Verified\nProperties',
                            ),
                            _TrustBadge(
                              icon: Icons.gavel_outlined,
                              label: 'RERA\nRegistered',
                            ),
                            _TrustBadge(
                              icon: Icons.lock_outlined,
                              label: 'Secure &\nTransparent',
                            ),
                            _TrustBadge(
                              icon: Icons.headset_mic_outlined,
                              label: 'Expert\nAssistance',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Bottom Action Bar (Same as PropertyDetailPage) ────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _ProjectBottomActions(
              project: project,
              onScheduleVisit: () {
                showScheduleVisitBottomSheet(
                  context,
                  propertyId: project.id,
                  title: project.name,
                  locality: project.location,
                  city: project.location,
                  imageUrl: project.images.isNotEmpty
                      ? project.images.first
                      : project.imageUrl,
                  ownerId: project.ownerId,
                  ownerName: project.developer,
                  ownerPhone: project.ownerPhone,
                );
              },
              onBookToken: () {
                final prop = _getOrCreateProperty(project);
                context.pushNamed(AppPage.bookByTokenName, extra: prop);
              },
              onCall: () => _makeCall(project.ownerPhone),
              onWhatsApp: () => _openWhatsApp(
                project.ownerPhone,
                project.name,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Default project fallback ─────────────────────────────────────────────────

const _defaultProject = ProjectModel(
  id: 'default',
  name: 'Emerald Heights',
  location: 'Shastri Nagar, Meerut',
  developer: 'XYZ Developers',
  startingPrice: '₹42 Lakh*',
  bhkTypes: '2/3/4',
  totalUnits: 240,
  openSpace: '70%',
  possession: 'Dec 2026',
  distance: '1.2 km from NH-58',
  interested: 128,
  reraApproved: true,
  readyToMove: true,
  imageGradientKey: 'dark_gold',
);

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
    child: Text(title, style: text16(fontWeight: FontWeight.bold)),
  );
}

class _SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(height: 8, color: AppColors.grey50);
}

class _QuadStat extends StatelessWidget {
  final String value;
  final String label;
  const _QuadStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: text13(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: text10(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class _VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 30, color: AppColors.grey200);
}

class _HighlightTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HighlightTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    width: 68,
    margin: const EdgeInsets.only(right: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 22, color: AppColors.primary),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: text10(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    ),
  );
}

class _BadgeChip extends StatelessWidget {
  final String label;
  final Color bg;
  const _BadgeChip({required this.label, required this.bg});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      label,
      style: text10(color: AppColors.white, fontWeight: FontWeight.bold),
    ),
  );
}

class _ScoreBar extends StatelessWidget {
  final ScoreItem item;
  const _ScoreBar({required this.item});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Expanded(
          child: Text(
            item.label,
            style: text11(color: AppColors.textSecondary),
          ),
        ),
        SizedBox(
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: item.score / item.maxScore,
              minHeight: 5,
              backgroundColor: AppColors.grey200,
              color: AppColors.success,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${item.score}/${item.maxScore.toInt()}',
          style: text10(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _PriceUnitRow extends StatelessWidget {
  final PriceUnit unit;
  const _PriceUnitRow({required this.unit});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.grey200),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(unit.bhk, style: text13(fontWeight: FontWeight.bold)),
              Text(unit.area, style: text11(color: AppColors.textSecondary)),
            ],
          ),
        ),
        Text(
          unit.priceRange,
          style: text13(color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            unit.status,
            style: text10(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

class _NearbyItem extends StatelessWidget {
  final NearbyPlace place;
  const _NearbyItem({required this.place});

  @override
  Widget build(BuildContext context) {
    final dotColor = switch (place.colorKey) {
      'red' => AppColors.error,
      'green' => AppColors.success,
      'orange' => AppColors.primary,
      _ => AppColors.blue,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text('${place.name}  ', style: text12(fontWeight: FontWeight.w500)),
        Text(place.distance, style: text12(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, size: 20, color: AppColors.primary),
      const SizedBox(height: 4),
      Text(
        label,
        style: text10(color: AppColors.textSecondary),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

// ─── Installment / EMI Plan Card for Projects ─────────────────────────────────

class _ProjectInstallmentPlanCard extends StatelessWidget {
  final ProjectModel project;

  const _ProjectInstallmentPlanCard({required this.project});

  String _formatCurrency(int amount) {
    if (amount <= 0) return '₹0';
    if (amount >= 10000000) {
      final cr = amount / 10000000;
      return '₹${cr.toStringAsFixed(cr.truncateToDouble() == cr ? 0 : 2)} Cr';
    } else if (amount >= 100000) {
      final l = amount / 100000;
      return '₹${l.toStringAsFixed(l.truncateToDouble() == l ? 0 : 2)} L';
    } else if (amount >= 1000) {
      final k = amount / 1000;
      return '₹${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)} K';
    }
    return '₹$amount';
  }

  @override
  Widget build(BuildContext context) {
    final details = project.installmentDetails;

    String downPaymentText = 'Available';
    if (details != null && details.downPaymentAmount > 0) {
      downPaymentText = _formatCurrency(details.downPaymentAmount);
      if (details.downPaymentPercentage > 0) {
        downPaymentText += ' (${details.downPaymentPercentage}%)';
      }
    } else if (details != null && details.downPaymentPercentage > 0) {
      downPaymentText = '${details.downPaymentPercentage}%';
    }

    String emiText = 'Flexible';
    if (details != null && details.installmentAmount > 0) {
      final freq = details.installmentFrequency.isNotEmpty
          ? details.installmentFrequency.toLowerCase().replaceAll('ly', '')
          : 'mo';
      emiText = '${_formatCurrency(details.installmentAmount)} / $freq';
    } else if (details != null && details.numberOfInstallments > 0) {
      emiText = '${details.numberOfInstallments} Installments';
    }

    String durationText = 'Custom Plan';
    if (details != null && details.numberOfInstallments > 0) {
      final freq = details.installmentFrequency.isNotEmpty
          ? details.installmentFrequency
          : 'Monthly';
      if (details.installmentDurationMonths > 0 &&
          details.installmentDurationMonths != details.numberOfInstallments) {
        durationText =
            '${details.numberOfInstallments} ($freq) · ${details.installmentDurationMonths}M';
      } else {
        durationText = '${details.numberOfInstallments} ($freq)';
      }
    } else if (details != null && details.installmentDurationMonths > 0) {
      durationText = '${details.installmentDurationMonths} Months';
    }

    String interestText = '0% (Interest Free)';
    if (details != null && details.interestRate > 0) {
      interestText = '${details.interestRate}% p.a.';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.payments_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Installment / EMI Plan',
                        style: text14(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Flexible payment options available directly from builder',
                        style: text11(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Available',
                    style: text10(
                      color: const Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 2x2 Metric Cards Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _ProjectInstallmentMetricTile(
                  title: 'Down Payment',
                  value: downPaymentText,
                  icon: Icons.account_balance_wallet_outlined,
                ),
                _ProjectInstallmentMetricTile(
                  title: 'Estimated EMI',
                  value: emiText,
                  icon: Icons.credit_card_outlined,
                ),
                _ProjectInstallmentMetricTile(
                  title: 'Tenure & Frequency',
                  value: durationText,
                  icon: Icons.calendar_month_outlined,
                ),
                _ProjectInstallmentMetricTile(
                  title: 'Interest Rate',
                  value: interestText,
                  icon: Icons.percent_outlined,
                ),
              ],
            ),

            // Grace Period Pill
            if (details != null && details.gracePeriodDays > 0) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Grace Period: ${details.gracePeriodDays} days after due date',
                      style: text11(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Terms and conditions note
            if (details != null &&
                details.termsAndConditions.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terms & Conditions',
                      style: text11(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      details.termsAndConditions.trim(),
                      style: text12(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProjectInstallmentMetricTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ProjectInstallmentMetricTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: text10(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: text12(
                    fontWeight: FontWeight.bold,
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
    );
  }
}

// ─── Bottom Actions (Aligned with PropertyDetailPage) ─────────────────────────

class _ProjectBottomActions extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onScheduleVisit;
  final VoidCallback onBookToken;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;

  const _ProjectBottomActions({
    required this.project,
    required this.onScheduleVisit,
    required this.onBookToken,
    required this.onCall,
    required this.onWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Schedule Visit button (Primary Action)
          Expanded(
            flex: 3,
            child: _ProjectBottomBtn(
              label: 'Schedule Visit',
              icon: Icons.calendar_month_outlined,
              bgColor: AppColors.primary,
              textColor: AppColors.white,
              onTap: onScheduleVisit,
            ),
          ),
          const SizedBox(width: 8),
          // Book Token button
          Expanded(
            flex: 2,
            child: _ProjectBottomBtn(
              label: 'Book Token',
              icon: Icons.bookmark_added_outlined,
              bgColor: AppColors.white,
              textColor: AppColors.primary,
              borderColor: AppColors.primary,
              onTap: onBookToken,
            ),
          ),
          const SizedBox(width: 8),
          // Call button
          _ProjectCircleActionBtn(
            icon: Icons.phone_outlined,
            bgColor: AppColors.grey100,
            iconColor: AppColors.textPrimary,
            onTap: onCall,
          ),
          const SizedBox(width: 8),
          // WhatsApp button
          _ProjectCircleActionBtn(
            icon: Icons.chat_bubble_outline,
            bgColor: const Color(0xFFE8F5E9),
            iconColor: const Color(0xFF25D366),
            onTap: onWhatsApp,
          ),
        ],
      ),
    );
  }
}

class _ProjectCircleActionBtn extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _ProjectCircleActionBtn({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}

class _ProjectBottomBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _ProjectBottomBtn({
    required this.label,
    this.icon,
    required this.bgColor,
    required this.textColor,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1.2)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: textColor),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label,
                  style: text11(color: textColor, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
