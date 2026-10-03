import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';
import 'package:gharmb_app/features/property/providers/provider_details_provider.dart';
import 'package:gharmb_app/features/property/widget/schedule_visit_bottom_sheet.dart';
import 'package:gharmb_app/features/wishlist/providers/wishlist_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/snakebar/custom_snakebar.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailPage extends ConsumerStatefulWidget {
  final String? propertyId;
  final Property? property;

  const PropertyDetailPage({super.key, this.propertyId, this.property});

  @override
  ConsumerState<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends ConsumerState<PropertyDetailPage> {
  int _currentImageIndex = 0;

  String _formatPrice(int p) {
    if (p <= 0) return '₹ On Request';
    if (p >= 10000000) {
      final cr = p / 10000000;
      return '₹${cr.toStringAsFixed(cr.truncateToDouble() == cr ? 0 : 2)} Cr';
    } else if (p >= 100000) {
      final l = p / 100000;
      return '₹${l.toStringAsFixed(l.truncateToDouble() == l ? 0 : 1)} L';
    } else if (p >= 1000) {
      final k = p / 1000;
      return '₹${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)} K';
    }
    return '₹$p';
  }

  String _getPriceSuffix(Property prop) {
    final lf = prop.listingFor.toLowerCase();
    if (lf == 'rent' || lf == 'lease' || lf == 'pg') {
      return ' /month';
    }
    return '';
  }

  IconData _getAmenityIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('gym') || lower.contains('fitness')) {
      return Icons.fitness_center;
    }
    if (lower.contains('pool') || lower.contains('swimming')) {
      return Icons.pool;
    }
    if (lower.contains('park') || lower.contains('garden')) {
      return Icons.park_outlined;
    }
    if (lower.contains('play') || lower.contains('kid')) {
      return Icons.child_friendly;
    }
    if (lower.contains('security') || lower.contains('guard')) {
      return Icons.shield_outlined;
    }
    if (lower.contains('lift') || lower.contains('elevator')) {
      return Icons.elevator_outlined;
    }
    if (lower.contains('power') || lower.contains('backup')) {
      return Icons.bolt_outlined;
    }
    if (lower.contains('wifi') || lower.contains('internet')) {
      return Icons.wifi;
    }
    if (lower.contains('club') || lower.contains('hall')) {
      return Icons.sports_tennis_outlined;
    }
    if (lower.contains('cctv') || lower.contains('camera')) {
      return Icons.videocam_outlined;
    }
    if (lower.contains('gas') || lower.contains('pipeline')) {
      return Icons.local_gas_station_outlined;
    }
    if (lower.contains('fire')) return Icons.fire_extinguisher_outlined;
    if (lower.contains('water')) return Icons.water_drop_outlined;
    return Icons.check_circle_outline;
  }

  List<HighlightItem> _buildHighlights(Property prop) {
    final list = <HighlightItem>[];
    if (prop.allowInstallments) {
      list.add(
        const HighlightItem(Icons.payments_outlined, 'EMI Plan\nAvailable'),
      );
    }
    if (prop.brokerageFree) {
      list.add(const HighlightItem(Icons.money_off, 'Zero\nBrokerage'));
    }
    if (prop.vastuCompliant) {
      list.add(const HighlightItem(Icons.explore, 'Vastu\nCompliant'));
    }
    if (prop.keyHandover) {
      list.add(const HighlightItem(Icons.vpn_key, 'Key\nHandover'));
    }
    if (prop.petsAllowed) {
      list.add(const HighlightItem(Icons.pets, 'Pets\nAllowed'));
    }
    if (prop.furnishing.isNotEmpty) {
      String label = prop.furnishing.trim();
      final lower = label.toLowerCase();
      if (lower == 'semifurnished' ||
          lower == 'semi-furnished' ||
          lower == 'semi furnished') {
        label = 'Semi\nFurnished';
      } else if (lower == 'unfurnished' ||
          lower == 'un-furnished' ||
          lower == 'un furnished') {
        label = 'Unfurnished';
      } else if (lower == 'fullyfurnished' ||
          lower == 'fully-furnished' ||
          lower == 'furnished') {
        label = 'Fully\nFurnished';
      } else if (!lower.contains('furnish')) {
        label = '$label\nFurnished';
      }
      list.add(HighlightItem(Icons.chair_outlined, label));
    }
    if (prop.isVerified) {
      list.add(const HighlightItem(Icons.verified, 'Verified\nListing'));
    }
    return list;
  }

  Map<String, String> _buildPropertyDetails(Property prop) {
    final map = <String, String>{};
    if (prop.propertyType.isNotEmpty) {
      map['Property Type'] = prop.propertyType;
    }
    if (prop.category.isNotEmpty) {
      map['Category'] =
          prop.category[0].toUpperCase() + prop.category.substring(1);
    }
    if (prop.listingFor.isNotEmpty) {
      map['Listing For'] = prop.listingFor;
    }
    if (prop.furnishing.isNotEmpty) {
      map['Furnishing'] = prop.furnishing;
    }
    if (prop.facingDirection.isNotEmpty) {
      map['Facing'] = prop.facingDirection;
    }
    if (prop.ageOfProperty.isNotEmpty) {
      map['Age of Property'] = prop.ageOfProperty;
    }
    if (prop.carpetArea > 0) {
      map['Carpet Area'] = '${prop.carpetArea} sq.ft';
    }
    if (prop.builtUpArea > 0) {
      map['Built-up Area'] = '${prop.builtUpArea} sq.ft';
    }
    if (prop.floorNo.isNotEmpty) {
      map['Floor'] = prop.totalFloors.isNotEmpty
          ? '${prop.floorNo} of ${prop.totalFloors}'
          : prop.floorNo;
    }
    if (prop.securityDeposit > 0) {
      map['Security Deposit'] = '₹${prop.securityDeposit}';
    }
    if (prop.maintenanceCharges > 0) {
      map['Maintenance'] = '₹${prop.maintenanceCharges} /month';
    }
    if (prop.preferredTenants.isNotEmpty) {
      map['Preferred Tenants'] = prop.preferredTenants.join(', ');
    }
    if (prop.pincode.isNotEmpty) {
      map['Pincode'] = prop.pincode;
    }
    return map;
  }

  Future<void> _makeCall(String? phone) async {
    if (phone == null || phone.isEmpty) {
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
    if (phone == null || phone.isEmpty) {
      AppSnackBar.showError(context, message: "WhatsApp number not available");
      return;
    }
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final msg = Uri.encodeComponent(
      "Hello, I am interested in your property '$propTitle' on GharMB.",
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
    if (widget.property != null) {
      return _buildPropertyScaffold(widget.property!);
    }

    final id = widget.propertyId ?? '';
    if (id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Property Details')),
        body: const Center(child: Text('Property not found')),
      );
    }

    final asyncProperty = ref.watch(propertyDetailByIdProvider(id));

    return asyncProperty.when(
      data: (property) {
        if (property == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Property Details')),
            body: const Center(child: Text('Property details not found')),
          );
        }
        return _buildPropertyScaffold(property);
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          leading: const CustomBackButton(),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Property Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text(
                'Could not load property details',
                style: text14(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(propertyDetailByIdProvider(id)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text('Retry', style: text14(color: AppColors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyScaffold(Property property) {
    final propId = property.id.isNotEmpty ? property.id : property.mongoId;
    final wishlistState = ref.watch(wishlistProvider);
    final isWishlisted = wishlistState.items.any(
      (item) =>
          item.id == propId ||
          (item.property != null &&
              (item.property!.id == propId ||
                  item.property!.mongoId == propId)),
    );
    final isExpanded = ref.watch(isExpandedProvider);

    final List<String> images = property.images;
    final highlights = _buildHighlights(property);
    final detailsMap = _buildPropertyDetails(property);
    final isHot =
        property.listingTier.toLowerCase() == 'featured' ||
        property.viewsCount > 50;

    final locationStr = [
      if (property.locality.isNotEmpty) property.locality,
      if (property.city.isNotEmpty) property.city,
    ].join(', ');
    final displayLocation = locationStr.isNotEmpty
        ? locationStr
        : property.fullAddress;

    // Stat items list (only non-empty / > 0)
    final stats = <Widget>[];

    final area = property.carpetArea > 0
        ? property.carpetArea
        : property.builtUpArea;
    if (area > 0) {
      stats.add(
        _StatItem(
          value: '$area',
          unit: 'sq.ft',
          icon: Icons.crop_square_rounded,
        ),
      );
    }

    if (property.bedrooms.isNotEmpty && property.bedrooms != '0') {
      if (stats.isNotEmpty) stats.add(_Divider());
      stats.add(
        _StatItem(
          value: property.bedrooms,
          unit: 'Bedrooms',
          icon: Icons.bed_outlined,
        ),
      );
    }

    if (property.bathrooms.isNotEmpty && property.bathrooms != '0') {
      if (stats.isNotEmpty) stats.add(_Divider());
      stats.add(
        _StatItem(
          value: property.bathrooms,
          unit: 'Bathrooms',
          icon: Icons.bathtub_outlined,
        ),
      );
    }

    if (property.parking.isNotEmpty &&
        property.parking != '0' &&
        property.parking.toLowerCase() != 'none') {
      if (stats.isNotEmpty) stats.add(_Divider());
      stats.add(
        _StatItem(
          value: property.parking,
          unit: 'Parking',
          icon: Icons.local_parking_outlined,
        ),
      );
    }

    if (property.floorNo.isNotEmpty) {
      if (stats.isNotEmpty) stats.add(_Divider());
      stats.add(
        _StatItem(
          value: property.floorNo,
          unit: property.totalFloors.isNotEmpty
              ? 'of ${property.totalFloors}'
              : 'Floor',
          icon: Icons.layers_outlined,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero Image Sliver ──────────────────────────────────
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
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
                  GestureDetector(
                    onTap: () async {
                      final success = await ref
                          .read(wishlistProvider.notifier)
                          .toggleWishlist(propertyId: propId);
                      if (context.mounted && success) {
                        AppSnackBar.showSuccess(
                          context,
                          title: !isWishlisted ? 'Added!' : 'Removed',
                          message: !isWishlisted
                              ? 'Added to wishlist!'
                              : 'Removed from wishlist!',
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
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
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Photo PageView / Image
                      if (images.isNotEmpty)
                        PageView.builder(
                          itemCount: images.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (ctx, idx) {
                            return CachedNetworkImage(
                              imageUrl: images[idx],
                              fit: BoxFit.fill,
                              placeholder: (c, u) => Container(
                                color: AppColors.grey200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (c, u, e) => Container(
                                color: const Color(0xFF1E293B),
                                child: const Center(
                                  child: Icon(
                                    Icons.home_work_outlined,
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
                              Icons.home_work_outlined,
                              color: AppColors.grey400,
                              size: 56,
                            ),
                          ),
                        ),

                      // Gradient overlay at bottom for readability
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Bottom badges row
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Row(
                          children: [
                            if (property.isVerified)
                              const _Badge(
                                label: '✓ Verified',
                                bg: AppColors.success,
                              ),
                            if (property.isVerified && isHot)
                              const SizedBox(width: 6),
                            if (isHot)
                              const _Badge(
                                label: '🔥 Featured',
                                bg: AppColors.error,
                              ),
                          ],
                        ),
                      ),

                      // Photos count
                      if (images.isNotEmpty)
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
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
                                  size: 13,
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
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Price + Title + Type ───────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _formatPrice(property.price),
                                        style: text24(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _getPriceSuffix(property),
                                        style: text12(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (property.title.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      property.title,
                                      style: text15(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                  if (displayLocation.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          child: Text(
                                            displayLocation,
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
                                ],
                              ),
                            ),
                            if (property.propertyType.isNotEmpty ||
                                property.listingFor.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  property.propertyType.isNotEmpty
                                      ? property.propertyType
                                      : property.listingFor,
                                  style: text12(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // ── Stat Row (Only non-empty) ───────────────────
                      if (stats.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.grey200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: stats,
                            ),
                          ),
                        ),
                      ],

                      // ── Installment / EMI Plan (if allowed) ─────────
                      if (property.allowInstallments)
                        _InstallmentPlanCard(property: property),

                      // ── Property Highlights ────────────────────────
                      if (highlights.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        const _Divider2(),
                        _SectionTitle('Property Highlights'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 14,
                            children: highlights
                                .map((h) => _HighlightTile(item: h))
                                .toList(),
                          ),
                        ),
                      ],

                      // ── About Property ─────────────────────────────
                      if (property.description.trim().isNotEmpty) ...[
                        const SizedBox(height: 18),
                        const _Divider2(),
                        _SectionTitle('About Property'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property.description.trim(),
                                style: text13(
                                  color: AppColors.textSecondary,
                                ).copyWith(height: 1.6),
                                maxLines: isExpanded ? null : 4,
                                overflow: isExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                              ),
                              if (property.description.trim().length > 150) ...[
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: () => ref
                                      .read(isExpandedProvider.notifier)
                                      .update((s) => !s),
                                  child: Text(
                                    isExpanded ? 'Read less' : 'Read more',
                                    style: text13(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],

                      // ── Amenities ──────────────────────────────────
                      if (property.amenities.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        const _Divider2(),
                        _SectionTitle('Amenities'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: property.amenities
                                .map(
                                  (a) => _AmenityTile(
                                    item: AmenityItem(_getAmenityIcon(a), a),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],

                      // ── Property Details ───────────────────────────
                      if (detailsMap.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        const _Divider2(),
                        _SectionTitle('Property Details'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _PropertyDetailsGrid(details: detailsMap),
                        ),
                      ],

                      // ── Location & Address ─────────────────────────
                      if (property.fullAddress.isNotEmpty ||
                          displayLocation.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        const _Divider2(),
                        _SectionTitle('Location'),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (property.locality.isNotEmpty)
                                        Text(
                                          property.locality,
                                          style: text14(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      const SizedBox(height: 2),
                                      Text(
                                        property.fullAddress.isNotEmpty
                                            ? property.fullAddress
                                            : displayLocation,
                                        style: text12(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      // ── Verified Banner ────────────────────────────
                      if (property.isVerified) ...[
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF7EF),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.success),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.verified_user_outlined,
                                    color: AppColors.success,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Verified Property',
                                        style: text13(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.success,
                                        ),
                                      ),
                                      Text(
                                        'This property has been verified by the GharMB team',
                                        style: text11(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      // ── Schedule Free Site Visit Card ───────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFF7F2), Color(0xFFFFECE0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.35),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.calendar_month_rounded,
                                      color: AppColors.white,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Schedule a Free Site Visit',
                                          style: text14(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Inspect amenities, sunlight & neighbourhood in person',
                                          style: text11(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => showScheduleVisitBottomSheet(
                                    context,
                                    property: property,
                                  ),
                                  icon: const Icon(
                                    Icons.touch_app_outlined,
                                    size: 16,
                                    color: AppColors.white,
                                  ),
                                  label: Text(
                                    'Select Date & Time Slot',
                                    style: text13(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Bottom Action Bar ──────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomActions(
              onScheduleVisit: () =>
                  showScheduleVisitBottomSheet(context, property: property),
              onCall: () => _makeCall(property.owner.phone),
              onWhatsApp: () => _openWhatsApp(
                property.owner.phone,
                property.title.isNotEmpty
                    ? property.title
                    : '${property.bedrooms} BHK ${property.propertyType}',
              ),
              onBookToken: () {
                context.pushNamed(AppPage.bookByTokenName, extra: property);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  const _Badge({required this.label, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: text10(color: AppColors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String unit;
  final IconData icon;
  const _StatItem({
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(height: 4),
        Text(value, style: text13(fontWeight: FontWeight.bold)),
        Text(unit, style: text10(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppColors.grey200);
  }
}

class _Divider2 extends StatelessWidget {
  const _Divider2();
  @override
  Widget build(BuildContext context) {
    return Container(height: 8, color: AppColors.grey50);
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      child: Text(title, style: text16(fontWeight: FontWeight.bold)),
    );
  }
}

class _HighlightTile extends StatelessWidget {
  final HighlightItem item;
  const _HighlightTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          Icon(item.icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: text10(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AmenityTile extends StatelessWidget {
  final AmenityItem item;
  const _AmenityTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, color: AppColors.primary, size: 16),
          const SizedBox(width: 6),
          Text(
            item.label,
            style: text11(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertyDetailsGrid extends StatelessWidget {
  final Map<String, String> details;
  const _PropertyDetailsGrid({required this.details});

  @override
  Widget build(BuildContext context) {
    final entries = details.entries.toList();
    return Column(
      children: List.generate((entries.length / 2).ceil(), (row) {
        final left = entries[row * 2];
        final right = row * 2 + 1 < entries.length
            ? entries[row * 2 + 1]
            : null;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              Expanded(
                child: _DetailCell(k: left.key, v: left.value),
              ),
              if (right != null)
                Expanded(
                  child: _DetailCell(k: right.key, v: right.value),
                )
              else
                const Spacer(),
            ],
          ),
        );
      }),
    );
  }
}

class _DetailCell extends StatelessWidget {
  final String k;
  final String v;
  const _DetailCell({required this.k, required this.v});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, style: text12(color: AppColors.textSecondary)),
        const SizedBox(height: 3),
        Text(v, style: text13(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ─── Bottom Action Bar ────────────────────────────────────────────────────────

class _BottomActions extends StatelessWidget {
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onScheduleVisit;
  final VoidCallback onBookToken;

  const _BottomActions({
    required this.onCall,
    required this.onWhatsApp,
    required this.onScheduleVisit,
    required this.onBookToken,
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
            child: _BottomBtn(
              label: 'Schedule Visit',
              icon: Icons.calendar_month_outlined,
              bgColor: AppColors.primary,
              textColor: AppColors.white,
              onTap: onScheduleVisit,
            ),
          ),
          const SizedBox(width: 8),
          // Book with token
          Expanded(
            flex: 2,
            child: _BottomBtn(
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
          _CircleActionBtn(
            icon: Icons.phone_outlined,
            bgColor: AppColors.grey100,
            iconColor: AppColors.textPrimary,
            onTap: onCall,
          ),
          const SizedBox(width: 8),
          // WhatsApp button
          _CircleActionBtn(
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

class _CircleActionBtn extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleActionBtn({
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

class _BottomBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _BottomBtn({
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

class _InstallmentPlanCard extends StatelessWidget {
  final Property property;

  const _InstallmentPlanCard({required this.property});

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
    final details = property.installmentDetails;

    // Down payment text
    String downPaymentText = 'Available';
    if (details != null && details.downPaymentAmount > 0) {
      downPaymentText = _formatCurrency(details.downPaymentAmount);
      if (details.downPaymentPercentage > 0) {
        downPaymentText += ' (${details.downPaymentPercentage}%)';
      }
    } else if (details != null && details.downPaymentPercentage > 0) {
      downPaymentText = '${details.downPaymentPercentage}%';
    }

    // Installment / EMI text
    String emiText = 'Flexible';
    if (details != null && details.installmentAmount > 0) {
      final freq = details.installmentFrequency.isNotEmpty
          ? details.installmentFrequency.toLowerCase().replaceAll('ly', '')
          : 'mo';
      emiText = '${_formatCurrency(details.installmentAmount)} / $freq';
    } else if (details != null && details.numberOfInstallments > 0) {
      emiText = '${details.numberOfInstallments} Installments';
    }

    // Tenure / Duration
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

    // Interest rate
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
                        'Flexible payment options available directly from owner',
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
                _InstallmentMetricTile(
                  title: 'Down Payment',
                  value: downPaymentText,
                  icon: Icons.account_balance_wallet_outlined,
                ),
                _InstallmentMetricTile(
                  title: 'Estimated EMI',
                  value: emiText,
                  icon: Icons.credit_card_outlined,
                ),
                _InstallmentMetricTile(
                  title: 'Tenure & Frequency',
                  value: durationText,
                  icon: Icons.calendar_month_outlined,
                ),
                _InstallmentMetricTile(
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

class _InstallmentMetricTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InstallmentMetricTile({
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
