class OrderUserInfoModel {
  final String id;
  final String street;
  final String phone;
  final String city;
  final String lat;
  final String long;
  final String userName;
  final String userPhone;
  final String userImage;

  const OrderUserInfoModel({
    required this.id,
    required this.street,
    required this.phone,
    required this.city,
    required this.lat,
    required this.long,
    required this.userName,
    required this.userPhone,
    required this.userImage,
  });

  factory OrderUserInfoModel.fromMap(Map<String, dynamic> map, String docId) {
    String safe(dynamic v) => v?.toString() ?? '';
    return OrderUserInfoModel(
      id: docId,
      street: safe(map['street']),
      phone: safe(map['phone']),
      city: safe(map['city']),
      lat: safe(map['lat']),
      long: safe(map['long']),
      userName: safe(map['userName']),
      userPhone: safe(map['userPhone']),
      userImage: safe(map['userImage']),
    );
  }
}
