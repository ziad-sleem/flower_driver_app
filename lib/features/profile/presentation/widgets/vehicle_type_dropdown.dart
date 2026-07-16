import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization_constants/delivery_application_constants.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_entity.dart';

class VehicleTypeDropdown extends StatelessWidget {
  final List<VehicleEntity> vehicles;
  final VehicleEntity? selectedVehicle;
  final ValueChanged<VehicleEntity> onChanged;

  const VehicleTypeDropdown({
    super.key,
    required this.vehicles,
    required this.selectedVehicle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<VehicleEntity>(
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      initialValue: selectedVehicle,
      decoration: InputDecoration(
        labelText: DeliveryApplicationConstants.vehicleType,
      ),
      items: vehicles.map((vehicle) {
        return DropdownMenuItem(
          value: vehicle,
          child: Text(
            vehicle.type ?? '',
            style: getMediumStyle(
              context: context,
              color: AppColors.textPrimary,
              fontSize: 13,
            ),
          ),
        );
      }).toList(),
      onChanged: (vehicle) {
        if (vehicle != null) onChanged(vehicle);
      },
    );
  }
}
