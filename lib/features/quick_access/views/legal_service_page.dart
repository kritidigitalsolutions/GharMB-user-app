import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/quick_access/providers/service_provider.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';

class LegalServicesPage extends ConsumerWidget {
  const LegalServicesPage({super.key});

  static const _trustItems = [
    _TrustItem(icon: Icons.security_outlined, label: 'Secure\nProcess'),
    _TrustItem(icon: Icons.person_outline, label: 'Expert\nLawyers'),
    _TrustItem(icon: Icons.money_off_outlined, label: 'No Hidden\nCharges'),
    _TrustItem(icon: Icons.flash_on_outlined, label: 'Quick\nDelivery'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(legalServicesProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ────────────────────────────────
                  Row(
                    children: [
                      CustomBackButton(),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Legal services',
                            style: text18(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Safe · verified · expert lawyers',
                            style: text12(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── GharMB Verified Banner ────────────────
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified_rounded,
                            color: AppColors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GharMB Verified',
                                style: text13(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'All our legal partners are verified and experienced professionals',
                                style: text11(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Our Legal Services',
                    style: text15(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // ── Services List ──────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: services.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _LegalServiceCard(service: services[i]),
              ),
            ),

            // ── CTA + Trust Bar ────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: AppButton(title: 'Book free consultation', onTap: () {}),
            ),

            const SizedBox(height: 16),

            // ── Trust Bar ──────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.grey200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _trustItems.map((t) => _TrustChip(item: t)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegalServiceCard extends StatelessWidget {
  final LegalService service;
  const _LegalServiceCard({required this.service});

  IconData get _icon {
    switch (service.icon) {
      case 'search':
        return Icons.search_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'calculate':
        return Icons.calculate_outlined;
      case 'person':
        return Icons.person_outline;
      case 'verify':
        return Icons.fact_check_outlined;
      default:
        return Icons.description_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.title, style: text13(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  service.subtitle,
                  style: text11(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            service.price,
            style: text13(
              fontWeight: FontWeight.w700,
              color: service.isFree ? AppColors.success : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustItem {
  final IconData icon;
  final String label;
  const _TrustItem({required this.icon, required this.label});
}

class _TrustChip extends StatelessWidget {
  final _TrustItem item;
  const _TrustChip({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(item.icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 4),
        Text(
          item.label,
          style: text10(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
