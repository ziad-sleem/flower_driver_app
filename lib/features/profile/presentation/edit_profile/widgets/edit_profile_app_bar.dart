import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization_constants/profile_constants.dart';
import 'package:tracking_app/core/widgets/custom_appbar.dart';

class EditProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditProfileAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(title: ProfileConstants.editProfile,);
  }
}
