import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/developer/providers/register_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class RegistrationStep2Page extends ConsumerWidget {
  final RegistrationType type;
  const RegistrationStep2Page({super.key, required this.type});

  bool get _isDeveloper => type == RegistrationType.developer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step2State = _isDeveloper
        ? ref.watch(developerStep2Provider)
        : ref.watch(agentStep2Provider);
    final notifier = _isDeveloper
        ? ref.read(developerStep2Provider.notifier)
        : ref.read(agentStep2Provider.notifier);
    final pickedFiles = ref.watch(pickedFilesProvider);

    final canSubmit = step2State.documents
        .asMap()
        .entries
        .where((e) => e.value.isRequired)
        .every((e) => pickedFiles.containsKey(e.key));

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomBackButton(),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload documents',
                            style: text18(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Step 2 of 3 — Verification docs',
                            style: text12(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ProgressBar(step: 2, total: 3),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Content ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REQUIRED DOCUMENTS',
                      style: text11(
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey400,
                      ).copyWith(letterSpacing: 1.1),
                    ),
                    const SizedBox(height: 14),

                    // Document rows
                    ...List.generate(
                      step2State.documents.length,
                      (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _DocumentRow(
                          doc: step2State.documents[i],
                          fileInfo: pickedFiles[i],
                          onUpload: () async {
                            final file = await _pickFile(
                              context,
                              step2State.documents[i].name,
                            );
                            if (file != null) {
                              ref
                                  .read(pickedFilesProvider.notifier)
                                  .update((s) => {...s, i: file});
                              notifier.toggleUpload(i);
                            }
                          },
                          onRemove: () {
                            ref.read(pickedFilesProvider.notifier).update((s) {
                              final copy = Map<int, FileInfo>.from(s);
                              copy.remove(i);
                              return copy;
                            });
                            // set back to not uploaded
                            if (step2State.documents[i].isUploaded) {
                              notifier.toggleUpload(i);
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // // ── Drop zone ────────────────────────────
                    // GestureDetector(
                    //   onTap: () async {
                    //     final result = await FilePicker.pickFiles(
                    //       allowMultiple: true,
                    //       type: FileType.custom,
                    //       allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                    //     );
                    //     if (result != null && context.mounted) {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         SnackBar(
                    //           content: Text(
                    //             '${result.files.length} file(s) selected. Assign them to the fields above.',
                    //             style: text12(color: AppColors.white),
                    //           ),
                    //           backgroundColor: AppColors.primary,
                    //           behavior: SnackBarBehavior.floating,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(8),
                    //           ),
                    //         ),
                    //       );
                    //     }
                    //   },
                    //   child: Container(
                    //     width: double.infinity,
                    //     padding: const EdgeInsets.symmetric(vertical: 28),
                    //     decoration: BoxDecoration(
                    //       color: AppColors.card,
                    //       borderRadius: BorderRadius.circular(12),
                    //       border: Border.all(
                    //         color: AppColors.grey300,
                    //         style: BorderStyle.solid,
                    //       ),
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         const Icon(
                    //           Icons.attach_file_rounded,
                    //           color: AppColors.grey400,
                    //           size: 30,
                    //         ),
                    //         const SizedBox(height: 10),
                    //         Text(
                    //           'Tap to upload or drag & drop',
                    //           style: text13(color: AppColors.textSecondary),
                    //         ),
                    //         const SizedBox(height: 4),
                    //         Text(
                    //           'Browse files',
                    //           style: text13(
                    //             color: AppColors.primary,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //         ),
                    //         const SizedBox(height: 6),
                    //         Text(
                    //           'PDF, JPG, PNG · max 5 MB each',
                    //           style: text10(color: AppColors.grey400),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 16),

                    // ── Security note ────────────────────────
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBF0),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFFE082)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🔒', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your documents are encrypted and only reviewed by our admin team. We never share them with third parties.',
                              style: text12(color: const Color(0xFF8B6914)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // ── Submit Button ────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: AppButton(
                title: "Next",
                onTap: canSubmit
                    ? () => context.pushNamed(
                        AppPage.devRegisterStep3Name,
                        extra: type,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Pick file (camera / gallery / file) ──────────────────────
  Future<FileInfo?> _pickFile(BuildContext context, String docName) async {
    FileInfo? result;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PickerSheet(docName: docName),
    ).then((picked) {
      if (picked is FileInfo) result = picked;
    });

    return result;
  }
}

// ─── Bottom sheet for pick options ────────────────────────────
class _PickerSheet extends StatelessWidget {
  final String docName;
  const _PickerSheet({required this.docName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          Text('Upload $docName', style: text15(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            'Choose how you want to upload',
            style: text12(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          _SheetOption(
            icon: Icons.camera_alt_outlined,
            label: 'Take a photo',
            subtitle: 'Use your camera',
            onTap: () async {
              Navigator.pop(context, await _fromCamera());
            },
          ),
          const SizedBox(height: 10),
          _SheetOption(
            icon: Icons.photo_library_outlined,
            label: 'Choose from gallery',
            subtitle: 'JPG or PNG',
            onTap: () async {
              Navigator.pop(context, await _fromGallery());
            },
          ),
          const SizedBox(height: 10),
          _SheetOption(
            icon: Icons.picture_as_pdf_outlined,
            label: 'Upload PDF',
            subtitle: 'PDF document, max 5 MB',
            onTap: () async {
              Navigator.pop(context, await _fromFiles());
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: text14(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<FileInfo?> _fromCamera() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (img == null) return null;
    final file = File(img.path);
    return FileInfo(
      path: img.path,
      name: img.name,
      sizeBytes: await file.length(),
    );
  }

  Future<FileInfo?> _fromGallery() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (img == null) return null;
    final file = File(img.path);
    return FileInfo(
      path: img.path,
      name: img.name,
      sizeBytes: await file.length(),
    );
  }

  Future<FileInfo?> _fromFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result == null || result.files.isEmpty) return null;
    final f = result.files.first;
    return FileInfo(path: f.path ?? '', name: f.name, sizeBytes: f.size);
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  const _SheetOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: text14(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: text12(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.grey400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Document Row (updated) ────────────────────────────────────
class _DocumentRow extends StatelessWidget {
  final DocumentStatus doc;
  final FileInfo? fileInfo;
  final VoidCallback onUpload;
  final VoidCallback onRemove;

  const _DocumentRow({
    required this.doc,
    required this.fileInfo,
    required this.onUpload,
    required this.onRemove,
  });

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool get _isImage {
    if (fileInfo == null) return false;
    final ext = fileInfo!.name.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png'].contains(ext);
  }

  @override
  Widget build(BuildContext context) {
    final uploaded = fileInfo != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: uploaded
              ? AppColors.success.withOpacity(0.35)
              : AppColors.grey200,
          width: uploaded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Thumbnail or doc icon
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: uploaded && _isImage
                    ? Image.file(
                        File(fileInfo!.path),
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: uploaded
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          uploaded
                              ? Icons.insert_drive_file_rounded
                              : Icons.upload_file_outlined,
                          color: uploaded
                              ? AppColors.success
                              : AppColors.primary,
                          size: 22,
                        ),
                      ),
              ),
              const SizedBox(width: 12),

              // Name + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: doc.name,
                        style: text13(fontWeight: FontWeight.w600),
                        children: doc.isRequired
                            ? [
                                TextSpan(
                                  text: ' *',
                                  style: text13(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ]
                            : [],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      uploaded
                          ? '${fileInfo!.name}  ·  ${_formatSize(fileInfo!.sizeBytes)}'
                          : doc.subtitle,
                      style: text11(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Upload / Uploaded button
              uploaded
                  ? Row(
                      children: [
                        // Change
                        GestureDetector(
                          onTap: onUpload,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.grey300),
                            ),
                            child: Text(
                              'Change',
                              style: text11(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Remove
                        GestureDetector(
                          onTap: onRemove,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: AppColors.error,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: onUpload,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: doc.isRequired
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.grey100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: doc.isRequired
                                ? AppColors.primary.withOpacity(0.3)
                                : AppColors.grey300,
                          ),
                        ),
                        child: Text(
                          'Upload',
                          style: text12(
                            color: doc.isRequired
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
            ],
          ),

          // ── Uploaded green row ───────────────────────────
          if (uploaded) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.07),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Uploaded successfully',
                    style: text11(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Progress Bar ──────────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  final int step;
  final int total;
  const _ProgressBar({required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final filled = i < step;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
            height: 4,
            decoration: BoxDecoration(
              color: filled ? AppColors.primary : AppColors.grey200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
