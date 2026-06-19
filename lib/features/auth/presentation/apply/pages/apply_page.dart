import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/localization_constants/general_constants.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/custom_appbar.dart';
import 'package:tracking_app/core/widgets/custom_snack_bar.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_cubit.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_event.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_state.dart';
import 'package:tracking_app/features/auth/presentation/apply/widgets/apply_form_controller.dart';
import 'package:tracking_app/features/auth/presentation/apply/widgets/apply_form_field.dart';
import 'package:tracking_app/features/auth/presentation/apply/widgets/apply_header.dart';

class ApplyNowPage extends StatefulWidget {
  const ApplyNowPage({super.key});

  @override
  State<ApplyNowPage> createState() => _ApplyNowPageState();
}

class _ApplyNowPageState extends State<ApplyNowPage> {
  late final ApplyFormController controller;

  @override
  void initState() {
    super.initState();
    controller = ApplyFormController();
    final cubit = context.read<ApplyCubit>();
    cubit.onEvent(const LoadCountriesEvent());
    cubit.onEvent(const GetVehiclesEvent());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApplyCubit, ApplyState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          CustomSnackBar.error(context, state.errorMessage!);
        }
        if (state.successMessage != null) {
          Navigator.pushReplacementNamed(context, Routes.succesApply);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: GeneralConstants.apply,
            buttonEnable: false,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ApplyHeader(),
                  const AppSizedBox(height: 24),
                  ApplyForm(controller: controller, state: state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
