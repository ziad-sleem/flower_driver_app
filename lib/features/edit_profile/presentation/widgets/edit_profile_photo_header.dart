import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/widgets/cached_network_image.dart';
import 'package:tracking_app/features/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:tracking_app/features/edit_profile/presentation/cubit/edit_profile_event.dart';

class EditProfilePhotoHeader extends StatelessWidget {
  const EditProfilePhotoHeader({
    super.key,
    required this.profilePhotoUrl,
    required this.photo,
    required this.isUploading,
  });

  final String? profilePhotoUrl;
  final File? photo;
  final bool isUploading;

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null && context.mounted) {
      context
          .read<EditProfileCubit>()
          .doEvent(EditProfilePhotoChanged(File(picked.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: ClipOval(
              child: photo != null
                  ? Image.file(photo!, fit: BoxFit.cover)
                  : (profilePhotoUrl != null && profilePhotoUrl!.isNotEmpty)
                      ? CachedNetworkImageWidget(
                          urlToImage: profilePhotoUrl!,
                          width: 100,
                          height: 100,
                        )
                      : _placeholder(),
            ),
          ),
          if (isUploading)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: isUploading ? null : () => _pickImage(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => const Icon(
        Icons.person,
        size: 48,
        color: AppColors.grey700,
      );
}
