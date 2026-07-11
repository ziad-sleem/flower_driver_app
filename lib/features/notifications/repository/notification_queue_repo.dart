abstract interface class NotificationQueueRepo {
  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    required String orderId,
    required String type,
  });
}
