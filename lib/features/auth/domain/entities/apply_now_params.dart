class ApplyNowParams {
  final String country;
  final String firstName;
  final String lastName;
  final String vehicleType;
  final String vehicleNumber;
  final String nid;
  final String email;
  final String password;
  final String rePassword;
  final String gender;
  final String phone;
  final String vehicleLicensePath;
  final String nidImgPath;

  const ApplyNowParams({
    required this.country,
    required this.firstName,
    required this.lastName,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.nid,
    required this.email,
    required this.password,
    required this.rePassword,
    required this.gender,
    required this.phone,
    required this.vehicleLicensePath,
    required this.nidImgPath,
  });
}