import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/widgets/custom_snack_bar.dart';
import 'package:tracking_app/features/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:tracking_app/features/edit_profile/presentation/cubit/edit_profile_event.dart';
import 'package:tracking_app/features/edit_profile/presentation/cubit/edit_profile_state.dart';
import 'package:tracking_app/features/edit_profile/presentation/widgets/edit_profile_app_bar.dart';
import 'package:tracking_app/features/edit_profile/presentation/widgets/edit_profile_form_body.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditProfileCubit>().doEvent(const LoadProfileEvent());
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateControllers(EditProfileState state) {
    if (_controllersInitialized) return;
    _firstNameController.text = state.firstName;
    _lastNameController.text = state.lastName;
    _emailController.text = state.email;
    _phoneController.text = state.phone;
    _controllersInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EditProfileCubit, EditProfileState>(
          listenWhen: (prev, curr) =>
              curr.driver != null && !_controllersInitialized,
          listener: (_, state) => _populateControllers(state),
        ),
        BlocListener<EditProfileCubit, EditProfileState>(
          listenWhen: (prev, curr) =>
              prev.successMessage != curr.successMessage &&
              curr.successMessage != null,
          listener: (context, state) {
            CustomSnackBar.success(context, state.successMessage!);
            Navigator.of(context).pop(true);
          },
        ),
        BlocListener<EditProfileCubit, EditProfileState>(
          listenWhen: (prev, curr) =>
              prev.errorMessage != curr.errorMessage &&
              curr.errorMessage != null,
          listener: (context, state) =>
              CustomSnackBar.error(context, state.errorMessage!),
        ),
        BlocListener<EditProfileCubit, EditProfileState>(
          listenWhen: (prev, curr) =>
              prev.photoErrorMessage != curr.photoErrorMessage &&
              curr.photoErrorMessage != null,
          listener: (context, state) =>
              CustomSnackBar.error(context, state.photoErrorMessage!),
        ),
      ],
      child: Scaffold(
        appBar: const EditProfileAppBar(),
        body: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: EditProfileFormBody(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                emailController: _emailController,
                phoneController: _phoneController,
                formKey: _formKey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
