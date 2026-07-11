enum MapMode { toStore, toUser }

class DriverMapParams {
  final MapMode mode;
  final double? storeLat;
  final double? storeLng;
  final double? userLat;
  final double? userLng;
  final String storeName;
  final String storeAddress;
  final String? storePhone;
  final String userAddress;
  final String? userPhone;
  final String? userImage;
  final String? userName;
  final String? orderNumber;
  final double? totalPrice;
  final String? paymentType;

  const DriverMapParams({
    required this.mode,
    this.storeLat,
    this.storeLng,
    this.userLat,
    this.userLng,
    required this.storeName,
    this.storeAddress = '',
    this.storePhone,
    required this.userAddress,
    this.userPhone,
    this.userImage,
    this.userName,
    this.orderNumber,
    this.totalPrice,
    this.paymentType,
  });
}
