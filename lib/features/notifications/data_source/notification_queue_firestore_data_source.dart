abstract interface class NotificationQueueFirestoreDataSource {
  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    required String orderId,
    required String type,
  });
}
