import 'package:flutter/material.dart';

class ApplyFormController {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final idNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    vehicleNumberController.dispose();
    emailController.dispose();
    phoneController.dispose();
    idNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
