import 'package:flutter/material.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:go_router/go_router.dart';

class MyProjectPage extends StatefulWidget {
  const MyProjectPage({super.key});

  @override
  State<MyProjectPage> createState() => _MyProjectPageState();
}

class _MyProjectPageState extends State<MyProjectPage> {
  String _filter = 'Live';

  @override
  Widget build(BuildContext context) {
    final filteredProjects = _projects
        .where((project) => project.status == _filter)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: context.pop,
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.white,
              size: 18,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Project', style: text16(fontWeight: FontWeight.bold)),
            Text(
              '${filteredProjects.length} ${_filter.toLowerCase()} projects',
              style: text11(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          _DeveloperCard(developer: _developer),
          const SizedBox(height: 18),
          Row(
            children: [
              Text('Project list', style: text16(fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showEditMessage(context, 'Add project'),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
            ],
          ),
          _ProjectFilterBar(
            selected: _filter,
            onChanged: (value) => setState(() => _filter = value),
          ),
          const SizedBox(height: 10),
          ...filteredProjects.map(
            (project) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ProjectCard(
                project: project,
                onTap: () => _showProjectSheet(context, project),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeveloperCard extends StatelessWidget {
  final _DeveloperInfo developer;

  const _DeveloperCard({required this.developer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.business_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      developer.name,
                      style: text16(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      developer.location,
                      style: text12(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _Badge(label: developer.reraId),
                        const _Badge(label: 'Verified'),
                        const _Badge(label: 'Premium builder'),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showEditMessage(context, 'Developer details'),
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _DeveloperStat(value: '${developer.totalProjects}', label: 'Projects'),
              _SmallDivider(),
              _DeveloperStat(value: developer.experience, label: 'Experience'),
              _SmallDivider(),
              _DeveloperStat(value: developer.rating, label: 'Rating'),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            developer.about,
            style: text12(color: AppColors.textSecondary).copyWith(height: 1.45),
          ),
          const SizedBox(height: 14),
          _InfoRow(icon: Icons.call_outlined, text: developer.phone),
          const SizedBox(height: 8),
          _InfoRow(icon: Icons.mail_outline, text: developer.email),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final _DeveloperProject project;
  final VoidCallback onTap;

  const _ProjectCard({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 118,
              decoration: BoxDecoration(
                color: project.bannerColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.apartment_rounded,
                      color: AppColors.white.withOpacity(0.22),
                      size: 54,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _StatusPill(status: project.status),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () => _showEditMessage(context, project.name),
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.white,
                        size: 20,
                      ),
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          project.name,
                          style: text15(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        project.priceRange,
                        style: text13(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _InfoRow(icon: Icons.location_on_outlined, text: project.location),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _MiniStat(label: 'Units', value: project.totalUnits),
                      _MiniStat(label: 'BHK', value: project.bhkTypes),
                      _MiniStat(label: 'Possession', value: project.possession),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectFilterBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _ProjectFilterBar({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: ['Live', 'Pending', 'Rejected'].map((status) {
        final isSelected = selected == status;
        return GestureDetector(
          onTap: () => onChanged(status),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.grey300,
              ),
            ),
            child: Text(
              status,
              style: text12(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

void _showProjectSheet(BuildContext context, _DeveloperProject project) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    project.name,
                    style: text18(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => _showEditMessage(context, project.name),
                  icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 6),
            _InfoRow(icon: Icons.location_on_outlined, text: project.location),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatusPill(status: project.status),
                if (project.reraApproved) const _Badge(label: 'RERA approved'),
                const _Badge(label: 'Verified by admin'),
              ],
            ),
            const SizedBox(height: 18),
            _DetailGrid(project: project),
            const SizedBox(height: 18),
            Text('Amenities', style: text15(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.amenities.map((item) => _Badge(label: item)).toList(),
            ),
            const SizedBox(height: 18),
            Text('Description', style: text15(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              project.description,
              style: text13(color: AppColors.textSecondary).copyWith(height: 1.5),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => _showEditMessage(context, project.name),
                icon: const Icon(Icons.edit_outlined, color: AppColors.white),
                label: Text(
                  'Edit project',
                  style: text14(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

class _DetailGrid extends StatelessWidget {
  final _DeveloperProject project;

  const _DetailGrid({required this.project});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Project type', project.type),
      ('BHK types', project.bhkTypes),
      ('Total units', project.totalUnits),
      ('Price range', project.priceRange),
      ('Possession', project.possession),
      ('Open space', project.openSpace),
      ('Towers', project.towers),
      ('Photos', project.photos),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: rows
            .map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(row.$1, style: text12(color: AppColors.textSecondary)),
                    ),
                    Text(row.$2, style: text12(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _DeveloperStat extends StatelessWidget {
  final String value;
  final String label;

  const _DeveloperStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: text15(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: text10(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text10(color: AppColors.textSecondary)),
          const SizedBox(height: 2),
          Text(value, style: text12(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Expanded(
          child: Text(text, style: text12(color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}

class _SmallDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 34, color: AppColors.grey200);
  }
}

class _Badge extends StatelessWidget {
  final String label;

  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: text10(color: AppColors.primary, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'Live' => AppColors.success,
      'Pending' => AppColors.warning,
      _ => AppColors.info,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: text10(color: AppColors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

void _showEditMessage(BuildContext context, String item) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Edit $item')),
  );
}

class _DeveloperInfo {
  final String name;
  final String location;
  final String reraId;
  final int totalProjects;
  final String experience;
  final String rating;
  final String phone;
  final String email;
  final String about;

  const _DeveloperInfo({
    required this.name,
    required this.location,
    required this.reraId,
    required this.totalProjects,
    required this.experience,
    required this.rating,
    required this.phone,
    required this.email,
    required this.about,
  });
}

class _DeveloperProject {
  final String name;
  final String location;
  final String type;
  final String status;
  final String bhkTypes;
  final String totalUnits;
  final String priceRange;
  final String possession;
  final String openSpace;
  final String towers;
  final String photos;
  final bool reraApproved;
  final Color bannerColor;
  final List<String> amenities;
  final String description;

  const _DeveloperProject({
    required this.name,
    required this.location,
    required this.type,
    required this.status,
    required this.bhkTypes,
    required this.totalUnits,
    required this.priceRange,
    required this.possession,
    required this.openSpace,
    required this.towers,
    required this.photos,
    required this.reraApproved,
    required this.bannerColor,
    required this.amenities,
    required this.description,
  });
}

const _developer = _DeveloperInfo(
  name: 'Emerald Developers',
  location: 'Meerut, Uttar Pradesh',
  reraId: 'UPRERAG24XXXXX',
  totalProjects: 6,
  experience: '10+ yrs',
  rating: '4.6',
  phone: '+91 98765 43210',
  email: 'sales@emeralddevelopers.in',
  about:
      'Premium residential developer focused on gated communities, modern amenities, and timely handover across Meerut and nearby growth corridors.',
);

const _projects = [
  _DeveloperProject(
    name: 'Emerald Heights Phase 2',
    location: 'Shastri Nagar, Meerut',
    type: 'Residential',
    status: 'Live',
    bhkTypes: '2, 3, 4 BHK',
    totalUnits: '240',
    priceRange: 'Rs 42L - Rs 55L',
    possession: 'Dec 2026',
    openSpace: '70%',
    towers: '3',
    photos: '8 of 12',
    reraApproved: true,
    bannerColor: Color(0xFF263238),
    amenities: ['RERA approved', 'Gated society', 'Clubhouse', 'Swimming pool'],
    description:
        'Premium gated residential project near NH-58 with landscaped open spaces, modern clubhouse, family amenities, and efficient unit layouts.',
  ),
  _DeveloperProject(
    name: 'Emerald Business Square',
    location: 'Delhi Road, Meerut',
    type: 'Commercial',
    status: 'Pending',
    bhkTypes: 'Office, Retail',
    totalUnits: '86',
    priceRange: 'Rs 35L - Rs 1.2Cr',
    possession: 'Mar 2027',
    openSpace: '35%',
    towers: '1',
    photos: '5 of 12',
    reraApproved: true,
    bannerColor: Color(0xFF1B3A5C),
    amenities: ['Power backup', 'Lift', 'Visitor parking', 'CCTV'],
    description:
        'Mixed commercial project with office spaces and retail frontage planned for high visibility and daily footfall.',
  ),
  _DeveloperProject(
    name: 'Emerald Villas',
    location: 'Modipuram, Meerut',
    type: 'Residential',
    status: 'Rejected',
    bhkTypes: '3, 4 BHK Villas',
    totalUnits: '48',
    priceRange: 'Rs 78L - Rs 1.35Cr',
    possession: 'Jun 2027',
    openSpace: '62%',
    towers: '-',
    photos: '2 of 12',
    reraApproved: false,
    bannerColor: Color(0xFF365A3B),
    amenities: ['Garden', 'Kids play area', '24/7 security', 'EV charging'],
    description:
        'Low-density villa community with private parking, green pockets, and premium specifications for end users.',
  ),
];
