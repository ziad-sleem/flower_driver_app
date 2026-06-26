abstract class OrderDetailsFireStoreDataSource {
  Future<void> saveCurrentOrder({
    required String driverId,
    required String orderId,
    required String state,
  });

  Future<void> deleteCurrentOrder({required String driverId});

  Stream<String?> watchOrderState({required String driverId});
}
