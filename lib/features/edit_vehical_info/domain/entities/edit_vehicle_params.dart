class EditVehicleParams {
  final String vehicleType;
  final String vehicleNumber;
  final String? vehicleLicensePath;

  const EditVehicleParams({
    required this.vehicleType,
    required this.vehicleNumber,
    this.vehicleLicensePath,
  });
}
