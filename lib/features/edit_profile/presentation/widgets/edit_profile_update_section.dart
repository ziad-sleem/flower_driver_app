import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization_constants/auth_constants.dart';
import 'package:tracking_app/core/localization_constants/general_constants.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/button_loading_widget.dart';
import 'package:tracking_app/core/widgets/custom_text_field.dart';
import 'package:tracking_app/core/widgets/primary_button.dart';

class EditProfileUpdateSection extends StatelessWidget {
  const EditProfileUpdateSection({
    super.key,
    required this.canSubmit,
    required this.loading,
    required this.showNoChangesHint,
    required this.onUpdate,
  });

  final bool canSubmit;
  final bool loading;
  final bool showNoChangesHint;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PasswordField(),
        AppSizedBox(height: 32),
        if (loading)
          const ButtonLoadingWidget()
        else ...[
          PrimaryButton(
            text: GeneralConstants.update,
            onTap: canSubmit ? onUpdate : null,
          ),
          if (showNoChangesHint) ...[
            AppSizedBox(height: 8),
            Center(
              child: Text(
                'No changes to save',
                style: getMediumStyle(
                  context: context,
                  color: AppColors.grey700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        CustomTextField(
          labelText: AuthConstants.password,
          controller: TextEditingController(text: '••••••'),
          readOnly: true,
          isPassword: false,
        ),
        Positioned(
          right: 12,
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/forget-password'),
            child: Text(
              GeneralConstants.change,
              style: getMediumStyle(
                context: context,
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
