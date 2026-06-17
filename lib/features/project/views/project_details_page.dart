import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/project/provider/project_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';

class ProjectDetailPage extends ConsumerWidget {
  const ProjectDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(selectedProjectProvider) ?? _defaultProject;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero SliverAppBar ──────────────────────────────────
              SliverAppBar(
                expandedHeight: 260,
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
                  Container(
                    margin: const EdgeInsets.only(right: 6, top: 8, bottom: 8),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
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
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF1A1200), Color(0xFF3D2B00)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Image.asset(
                          width: double.infinity,
                          "assets/builder.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: _BadgeChip(
                          label: '✓ RERA Approved',
                          bg: AppColors.success,
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: _BadgeChip(
                          label: '⚡ Ready to Move',
                          bg: const Color(0xFFF39C12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Name + Price ─────────────────────────────────
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 2),
                                      Expanded(
                                        child: Text(
                                          '${project.location} • ${project.distance}',
                                          style: text12(
                                            color: AppColors.textSecondary,
                                          ),
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
                                value: '${project.totalUnits}',
                                label: 'Total Units',
                              ),
                              _VDivider(),
                              _QuadStat(
                                value: project.openSpace,
                                label: 'Open Space',
                              ),
                              _VDivider(),
                              _QuadStat(
                                value: project.possession,
                                label: 'Possession',
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      _SectionDivider(),

                      // ── Project Highlights ───────────────────────────
                      _SectionTitle('Project Highlights'),
                      SizedBox(
                        height: 90,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: const [
                            _HighlightTile(
                              icon: Icons.verified_outlined,
                              label: 'RERA\nApproved',
                            ),
                            _HighlightTile(
                              icon: Icons.train_outlined,
                              label: 'Metro\n1.2 km',
                            ),
                            _HighlightTile(
                              icon: Icons.sports_outlined,
                              label: 'Premium\nClubhouse',
                            ),
                            _HighlightTile(
                              icon: Icons.security,
                              label: '24x7\nSecurity',
                            ),
                            _HighlightTile(
                              icon: Icons.park_outlined,
                              label: '70% Open\nSpace',
                            ),
                            _HighlightTile(
                              icon: Icons.home_outlined,
                              label: 'Ready to\nMove',
                            ),
                          ],
                        ),
                      ),

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
                              // Circle score
                              Column(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: CustomPaint(
                                      painter: _ScoreCirclePainter(8.9),
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
                              // Score bars
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
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'View all',
                                style: text13(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...priceUnits.map(
                        (u) => Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          child: _PriceUnitRow(unit: u),
                        ),
                      ),

                      _SectionDivider(),

                      // ── Amenities ────────────────────────────────────
                      _SectionTitle('Amenities'),
                      SizedBox(
                        height: 90,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: const [
                            _HighlightTile(icon: Icons.pool, label: 'Pool'),
                            _HighlightTile(
                              icon: Icons.fitness_center,
                              label: 'Gym',
                            ),
                            _HighlightTile(
                              icon: Icons.sports_tennis_outlined,
                              label: 'Clubhouse',
                            ),
                            _HighlightTile(
                              icon: Icons.child_friendly,
                              label: 'Kids Play\nArea',
                            ),
                            _HighlightTile(
                              icon: Icons.security,
                              label: '24x7\nSecurity',
                            ),
                          ],
                        ),
                      ),

                      _SectionDivider(),

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
                              // Logo
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.textPrimary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    'dp/',
                                    style: TextStyle(
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
                                      'XYZ Developers',
                                      style: text14(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '• 15 Projects Delivered',
                                      style: text11(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      '• 12 Years Experience',
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
                                    'RERA Registration',
                                    style: text10(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'UPRERAPRJ12345',
                                    style: text11(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      'View on RERA Website',
                                      style: text10(color: AppColors.primary),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      _SectionDivider(),

                      // ── Location & Nearby ────────────────────────────
                      _SectionTitle('Location & Nearby'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: nearbyPlaces
                              .map((n) => _NearbyItem(place: n))
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 10),

                      _SectionDivider(),

                      // ── Gallery ──────────────────────────────────────
                      _SectionTitle('Gallery'),
                      SizedBox(
                        height: 80,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: galleryTabs
                              .map((t) => _GalleryTabCard(tab: t))
                              .toList(),
                        ),
                      ),

                      const SizedBox(height: 16),

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
                                onPressed: () {},
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

          // ── Bottom Action Bar ──────────────────────────────────────
          Positioned(bottom: 0, left: 0, right: 0, child: _BottomActions()),
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
        Text(value, style: text13(fontWeight: FontWeight.bold)),
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
          child: Icon(icon, size: 22, color: AppColors.textSecondary),
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
      borderRadius: BorderRadius.circular(10),
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

class _GalleryTabCard extends StatelessWidget {
  final GalleryTab tab;
  const _GalleryTabCard({required this.tab});

  @override
  Widget build(BuildContext context) => Container(
    width: 80,
    margin: const EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: const LinearGradient(
        colors: [Color(0xFF1A1200), Color(0xFF3D2B00)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tab.label,
          style: text11(color: AppColors.white, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        Text(
          '(${tab.count})',
          style: text10(color: Colors.white.withOpacity(0.7)),
        ),
      ],
    ),
  );
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

// ─── Score Circle Painter ─────────────────────────────────────────────────────

class _ScoreCirclePainter extends CustomPainter {
  final double score;
  const _ScoreCirclePainter(this.score);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 6;

    final bgPaint = Paint()
      ..color = AppColors.grey200
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * (score / 10);

    canvas.drawCircle(Offset(cx, cy), r, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startAngle,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Bottom Action Bar ────────────────────────────────────────────────────────

class _BottomActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        10,
        12,
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
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.phone_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              label: Text(
                'Call Expert',
                style: text13(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const FaIcon(
                FontAwesomeIcons.whatsapp,
                size: 16,
                color: AppColors.white,
              ),
              label: Text(
                'WhatsApp',
                style: text13(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                'Schedule\nSite Visit',
                style: text11(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
