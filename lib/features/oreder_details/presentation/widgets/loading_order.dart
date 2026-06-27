import 'package:flutter/material.dart';

class LoadingOrdersWidget extends StatelessWidget {
  const LoadingOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
