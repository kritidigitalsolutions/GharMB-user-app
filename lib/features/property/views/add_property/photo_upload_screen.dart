import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/property/providers/property_add_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_stepprogress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';

class PhotosVideoPage extends ConsumerStatefulWidget {
  const PhotosVideoPage({super.key});

  @override
  ConsumerState<PhotosVideoPage> createState() => _PhotosVideoPageState();
}

class _PhotosVideoPageState extends ConsumerState<PhotosVideoPage> {
  final _picker = ImagePicker();
  static const _maxPhotos = 12;

  Future<void> _pickImages() async {
    final photos = ref.read(listPropertyProvider).photos;
    final remaining = _maxPhotos - photos.length;
    if (remaining <= 0) return;

    final picked = await _picker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty) return;

    final files = picked.take(remaining).map((x) => File(x.path)).toList();
    ref.read(listPropertyProvider.notifier).addPhotos(files);
  }

  Future<void> _pickFromCamera() async {
    final photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (photo == null) return;
    ref.read(listPropertyProvider.notifier).addPhotos([File(photo.path)]);
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.primary,
                ),
              ),
              title: Text(
                'Choose from Gallery',
                style: text14(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                'Select multiple photos',
                style: text12(color: AppColors.textSecondary),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImages();
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.primary,
                ),
              ),
              title: Text(
                'Take Photo',
                style: text14(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                'Use camera to capture',
                style: text12(color: AppColors.textSecondary),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _removePhoto(int index) {
    ref.read(listPropertyProvider.notifier).removePhoto(index);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(listPropertyProvider);
    final photos = state.photos;
    final addedCount = photos.length;

    // Build grid slots: filled + empty + up to 6 empty (max 12 total)
    final totalSlots = (addedCount + 1).clamp(6, _maxPhotos);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 80,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Photos Upload", style: text16(fontWeight: FontWeight.bold)),
            SizedBox(height: 2),
            StepProgress(current: 3, total: 5),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Tip Banner ───────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8EC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text('💡', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Listings with 8+ photos get 3x more enquiries.\nAdd photos of every room',
                            style: text12(
                              color: AppColors.textSecondary,
                            ).copyWith(height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ── Photo Grid ───────────────────────────────────────
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: totalSlots,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemBuilder: (_, i) {
                      if (i < addedCount) {
                        // Filled photo slot
                        return _FilledPhotoSlot(
                          file: photos[i],
                          onRemove: () => _removePhoto(i),
                        );
                      } else {
                        // Empty add slot
                        final isFirstEmpty = i == addedCount;
                        return _EmptyPhotoSlot(
                          isDashed: !isFirstEmpty,
                          onTap: _showPickerOptions,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // ── Count label ──────────────────────────────────────
                  Text(
                    '$addedCount / $_maxPhotos photos added · tap + to add more',
                    style: text12(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 28),

                  // ── Next ─────────────────────────────────────────────
                  AppButton(
                    title: "Next",
                    onTap: () {
                      context.pushNamed(AppPage.pricingPreferencesName);
                    },
                  ),
                  const SizedBox(height: 12),

                  // ── Skip ─────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => context.pushNamed('pricingPreferences'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.grey300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Skip for now',
                        style: text14(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filled Photo Slot ────────────────────────────────────────────────────────

class _FilledPhotoSlot extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;

  const _FilledPhotoSlot({required this.file, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(file, fit: BoxFit.cover),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: AppColors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Empty Photo Slot ─────────────────────────────────────────────────────────

class _EmptyPhotoSlot extends StatelessWidget {
  final bool isDashed;
  final VoidCallback onTap;

  const _EmptyPhotoSlot({required this.isDashed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDashed ? AppColors.white : AppColors.grey50,
          borderRadius: BorderRadius.circular(10),
          border: isDashed
              ? Border.all(
                  color: AppColors.grey300,
                  width: 1.5,
                  // CustomPaint for dashed is complex; use regular border
                )
              : Border.all(color: AppColors.grey300, width: 1.5),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            size: 28,
            color: isDashed ? AppColors.grey400 : AppColors.grey500,
          ),
        ),
      ),
    );
  }
}
