import 'package:flutter/material.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

// ─── Base Custom Shimmer ──────────────────────────────────────────────────────

class CustomShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const CustomShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? const Color(0xFFE5E7EB),
      highlightColor: highlightColor ?? const Color(0xFFF3F4F6),
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

// ─── Shimmer Container Box ───────────────────────────────────────────────────

class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final ShapeBorder? shape;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: shape == null
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : ShapeDecoration(color: Colors.white, shape: shape!),
    );
  }
}

// ─── Shimmer Circle / Avatar ──────────────────────────────────────────────────

class ShimmerCircle extends StatelessWidget {
  final double? size;
  final double? radius;

  const ShimmerCircle({super.key, this.size, this.radius});

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? (radius != null ? radius! * 2 : 48.0);
    return Container(
      width: effectiveSize,
      height: effectiveSize,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ─── Banner Shimmer ──────────────────────────────────────────────────────────

class BannerShimmer extends StatelessWidget {
  final double height;
  final double horizontalMargin;
  final double borderRadius;

  const BannerShimmer({
    super.key,
    this.height = 155,
    this.horizontalMargin = 16,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// ─── Property Card Shimmer (Horizontal / Grid) ───────────────────────────────

class PropertyCardShimmer extends StatelessWidget {
  final double width;
  final double? height;

  const PropertyCardShimmer({
    super.key,
    this.width = 240,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const ShimmerBox(width: 100, height: 14),
                    const ShimmerBox(width: 150, height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        ShimmerBox(width: 70, height: 10),
                        ShimmerBox(width: 50, height: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Property List Shimmer (Vertical full-width cards) ───────────────────────

class PropertyListShimmer extends StatelessWidget {
  final int itemCount;

  const PropertyListShimmer({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, __) => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerBox(width: 100, height: 100, borderRadius: 12),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerBox(width: 80, height: 16),
                    const SizedBox(height: 8),
                    const ShimmerBox(width: double.infinity, height: 12),
                    const SizedBox(height: 6),
                    const ShimmerBox(width: 130, height: 12),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        ShimmerBox(width: 60, height: 14),
                        ShimmerBox(width: 70, height: 24, borderRadius: 6),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Commercial Listing Shimmer ───────────────────────────────────────────────

class CommercialListShimmer extends StatelessWidget {
  final int itemCount;

  const CommercialListShimmer({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerBox(
                width: double.infinity,
                height: 170,
                borderRadius: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        ShimmerBox(width: 120, height: 18),
                        ShimmerBox(width: 60, height: 16, borderRadius: 6),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const ShimmerBox(width: double.infinity, height: 14),
                    const SizedBox(height: 6),
                    const ShimmerBox(width: 180, height: 12),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        ShimmerBox(width: 80, height: 26, borderRadius: 6),
                        SizedBox(width: 8),
                        ShimmerBox(width: 80, height: 26, borderRadius: 6),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Developer Cards Shimmer ─────────────────────────────────────────────────

class DeveloperListShimmer extends StatelessWidget {
  final int itemCount;
  final bool isHorizontal;

  const DeveloperListShimmer({
    super.key,
    this.itemCount = 4,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return CustomShimmer(
        child: SizedBox(
          height: 115,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: itemCount,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, __) => Container(
              width: 95,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ShimmerCircle(size: 44),
                  SizedBox(height: 8),
                  ShimmerBox(width: 65, height: 10),
                  SizedBox(height: 4),
                  ShimmerBox(width: 40, height: 8),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return CustomShimmer(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const ShimmerCircle(size: 50),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(width: 140, height: 16),
                    SizedBox(height: 6),
                    ShimmerBox(width: 90, height: 12),
                    SizedBox(height: 6),
                    ShimmerBox(width: 120, height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Real Estate News Shimmer ────────────────────────────────────────────────

class NewsCardShimmer extends StatelessWidget {
  const NewsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(
              width: double.infinity,
              height: 150,
              borderRadius: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(width: 70, height: 14, borderRadius: 4),
                  SizedBox(height: 8),
                  ShimmerBox(width: double.infinity, height: 16),
                  SizedBox(height: 6),
                  ShimmerBox(width: 200, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Notification Item Shimmer ───────────────────────────────────────────────

class NotificationListShimmer extends StatelessWidget {
  final int itemCount;

  const NotificationListShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerCircle(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(width: 140, height: 14),
                    SizedBox(height: 6),
                    ShimmerBox(width: double.infinity, height: 12),
                    SizedBox(height: 6),
                    ShimmerBox(width: 70, height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Details Page Shimmer ────────────────────────────────────────────────────

class DetailsPageShimmer extends StatelessWidget {
  const DetailsPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(
              width: double.infinity,
              height: 250,
              borderRadius: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(width: 120, height: 24),
                  const SizedBox(height: 10),
                  const ShimmerBox(width: 220, height: 18),
                  const SizedBox(height: 8),
                  const ShimmerBox(width: 160, height: 14),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(child: ShimmerBox(height: 60, borderRadius: 10)),
                      SizedBox(width: 12),
                      Expanded(child: ShimmerBox(height: 60, borderRadius: 10)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const ShimmerBox(width: 140, height: 18),
                  const SizedBox(height: 10),
                  const ShimmerBox(width: double.infinity, height: 60),
                  const SizedBox(height: 20),
                  const ShimmerBox(width: 140, height: 18),
                  const SizedBox(height: 10),
                  const ShimmerBox(width: double.infinity, height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Document / Text Page Shimmer ────────────────────────────────────────────

class DocumentShimmer extends StatelessWidget {
  const DocumentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ShimmerBox(width: double.infinity, height: 90, borderRadius: 12),
            SizedBox(height: 24),
            ShimmerBox(width: 160, height: 20, borderRadius: 6),
            SizedBox(height: 12),
            ShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
            SizedBox(height: 8),
            ShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
            SizedBox(height: 8),
            ShimmerBox(width: 240, height: 14, borderRadius: 4),
            SizedBox(height: 24),
            ShimmerBox(width: 200, height: 20, borderRadius: 6),
            SizedBox(height: 12),
            ShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
            SizedBox(height: 8),
            ShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
            SizedBox(height: 8),
            ShimmerBox(width: 180, height: 14, borderRadius: 4),
            SizedBox(height: 24),
            ShimmerBox(width: double.infinity, height: 80, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}
