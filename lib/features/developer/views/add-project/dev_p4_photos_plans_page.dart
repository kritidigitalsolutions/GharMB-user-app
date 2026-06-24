import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/developer/providers/project_add_provider.dart';
import 'package:gharmb_app/features/property/widget/listing_widget.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_stepprogress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class DevProjectPhotosPlansPage extends ConsumerWidget {
  const DevProjectPhotosPlansPage({super.key});

  Future<void> _pickPhotos(WidgetRef ref) async {
    final images = await ImagePicker().pickMultiImage(imageQuality: 80);
    if (images.isEmpty) return;
    ref
        .read(projectAddProvider.notifier)
        .addProjectPhotos(images.map((image) => File(image.path)).toList());
  }

  Future<File?> _pickSingleFile({
    FileType type = FileType.custom,
    List<String> allowedExtensions = const ['jpg', 'jpeg', 'png', 'pdf'],
  }) async {
    final result = await FilePicker.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
    );
    final path = result?.files.single.path;
    if (path == null) return null;
    return File(path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectAddProvider);
    final notifier = ref.read(projectAddProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _ProjectAppBar(title: 'Photos & plans', step: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoBanner(
              'Projects with 8+ photos get 3x more enquiries. Add photos of every room and the exterior.',
            ),
            const SizedBox(height: 18),
            _SectionTitle('Project photos *'),
            GridView.builder(
              itemCount: 6,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                if (index < state.projectPhotos.length) {
                  return _PhotoTile(
                    file: state.projectPhotos[index].file,
                    onRemove: () => notifier.removeProjectPhoto(index),
                  );
                }
                return _UploadTile(onTap: () => _pickPhotos(ref));
              },
            ),
            const SizedBox(height: 24),
            _SectionTitle('Master plan *'),
            _DocumentUploadTile(
              icon: Icons.map_outlined,
              emptyTitle: 'Upload master plan / site map',
              selectedFile: state.masterPlan,
              onTap: () async {
                final file = await _pickSingleFile();
                if (file != null) notifier.setMasterPlan(file);
              },
              onRemove: notifier.removeMasterPlan,
            ),
            const SizedBox(height: 20),
            _SectionTitle('Floor plan'),
            _DocumentUploadTile(
              icon: Icons.architecture_outlined,
              emptyTitle: 'Upload 2BHK / 3BHK floor plan',
              selectedFile: state.floorPlan,
              onTap: () async {
                final file = await _pickSingleFile();
                if (file != null) notifier.setFloorPlan(file);
              },
              onRemove: notifier.removeFloorPlan,
            ),
            const SizedBox(height: 20),
            _SectionTitle('Brochure (optional)'),
            _DocumentUploadTile(
              icon: Icons.picture_as_pdf_outlined,
              emptyTitle: 'PDF brochure - max 10 MB',
              selectedFile: state.brochure,
              onTap: () async {
                final file = await _pickSingleFile(
                  allowedExtensions: const ['pdf'],
                );
                if (file != null) notifier.setBrochure(file);
              },
              onRemove: notifier.removeBrochure,
            ),
            const SizedBox(height: 20),
            // const FieldLabel('Walkthrough video URL (optional)'),
            // ListingTextField(
            //   hint: 'YouTube / drive link',
            //   onChanged: notifier.setWalkthroughVideoUrl,
            // ),
            // const SizedBox(height: 12),
            Text(
              '${state.projectPhotos.length} / 12 photos added. Add 6+ for a featured badge.',
              style: text11(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        title: 'Next',
        onTap: () => context.pushNamed(AppPage.devProjectReviewName),
      ),
    );
  }

  static String fileName(File file) =>
      file.path.split(Platform.pathSeparator).last;
}

class _InfoBanner extends StatelessWidget {
  final String text;

  const _InfoBanner(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEE5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: text12(color: AppColors.textSecondary).copyWith(height: 1.4),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;

  const _PhotoTile({required this.file, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(file, fit: BoxFit.cover),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: onRemove,
              child: const CircleAvatar(
                radius: 10,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.close, color: AppColors.white, size: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  final VoidCallback onTap;

  const _UploadTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey300),
        ),
        child: const Center(
          child: Icon(Icons.add, color: AppColors.grey400, size: 24),
        ),
      ),
    );
  }
}

class _DocumentUploadTile extends StatelessWidget {
  final IconData icon;
  final String emptyTitle;
  final File? selectedFile;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _DocumentUploadTile({
    required this.icon,
    required this.emptyTitle,
    required this.selectedFile,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = selectedFile != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: hasFile ? const Color(0xFFEAF8F0) : AppColors.grey50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasFile ? AppColors.success : AppColors.grey300,
            width: hasFile ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: hasFile ? AppColors.success : AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: hasFile ? AppColors.success : AppColors.grey300,
                ),
              ),
              child: Icon(
                hasFile ? Icons.check : icon,
                color: hasFile ? AppColors.white : AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasFile
                        ? DevProjectPhotosPlansPage.fileName(selectedFile!)
                        : emptyTitle,
                    style: text12(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    hasFile ? 'Uploaded - tap to change' : 'Browse files',
                    style: text11(
                      color: hasFile ? AppColors.success : AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (hasFile)
              IconButton(
                onPressed: onRemove,
                icon: const Icon(
                  Icons.close,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProjectAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int step;

  const _ProjectAppBar({required this.title, required this.step});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      toolbarHeight: 80,
      leading: GestureDetector(
        onTap: context.pop,
        child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 18),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: text16(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          StepProgress(current: step, total: 5),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: text12(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w800,
        ).copyWith(letterSpacing: 1.1),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _BottomBar({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: AppButton(title: title, onTap: onTap),
      ),
    );
  }
}
