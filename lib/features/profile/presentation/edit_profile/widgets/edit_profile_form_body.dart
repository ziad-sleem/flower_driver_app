import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/widgets/app_loading_widget.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/cubit/edit_profile_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/cubit/edit_profile_state.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/widgets/edit_profile_email_phone_fields.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/widgets/edit_profile_name_row.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/widgets/edit_profile_photo_header.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/widgets/edit_profile_update_section.dart';

class EditProfileFormBody extends StatelessWidget {
  const EditProfileFormBody({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.formKey,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        if (state.isLoadingProfile) {
          return const SizedBox(
            height: 400,
            child: Center(child: AppLoadingWidget()),
          );
        }

        final cubit = context.read<EditProfileCubit>();
        final loading = state.isSubmitting || state.isUploadingPhoto;
        final canSubmit = cubit.hasChanges && !loading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EditProfilePhotoHeader(
              profilePhotoUrl: state.profilePhotoUrl,
              photo: state.photo,
              isUploading: state.isUploadingPhoto,
            ),
            AppSizedBox(height: 24),
            EditProfileNameRow(
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              onFirstNameChanged: (v) =>
                  cubit.doEvent(EditProfileFirstNameChanged(v)),
              onLastNameChanged: (v) =>
                  cubit.doEvent(EditProfileLastNameChanged(v)),
            ),
            AppSizedBox(height: 16),
            EditProfileEmailPhoneFields(
              emailController: emailController,
              phoneController: phoneController,
              onEmailChanged: (v) => cubit.doEvent(EditProfileEmailChanged(v)),
              onPhoneChanged: (v) => cubit.doEvent(EditProfilePhoneChanged(v)),
            ),
            AppSizedBox(height: 16),
            EditProfileUpdateSection(
              canSubmit: canSubmit,
              loading: loading,
              showNoChangesHint: !cubit.hasChanges && !loading,
              onUpdate: () {
                if (formKey.currentState?.validate() ?? false) {
                  cubit.doEvent(const EditProfileSubmitted());
                }
              },
            ),
          ],
        );
      },
    );
  }
}
