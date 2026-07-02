enum MapMode { toStore, toUser }

class DriverMapParams {
  final MapMode mode;
  final double storeLat;
  final double storeLng;
  final double userLat;
  final double userLng;
  final String storeName;
  final String userAddress;

  const DriverMapParams({
    required this.mode,
    required this.storeLat,
    required this.storeLng,
    required this.userLat,
    required this.userLng,
    required this.storeName,
    required this.userAddress,
  });
}
