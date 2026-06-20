import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization_constants/delivery_application_constants.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';

class UploadImageField extends StatelessWidget {
  final String label;
  final String hint;
  final String? imagePath;
  final VoidCallback onTap;

  const UploadImageField({
    super.key,
    required this.label,
    required this.hint,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: imagePath == null
            ? Row(
                children: [
                  Expanded(
                    child: Text(
                      hint,
                      style: getLightStyle(
                        context: context,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                  const Icon(Icons.file_upload_outlined),
                ],
              )
            : Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(imagePath!),
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      DeliveryApplicationConstants.imageSelected,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.check_circle, color: AppColors.success),
                ],
              ),
      ),
    );
  }
}
