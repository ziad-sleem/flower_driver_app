import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/notifications/data_source/notification_queue_firestore_data_source.dart';

@Injectable(as: NotificationQueueFirestoreDataSource)
class NotificationQueueFirestoreDataSourceImpl
    implements NotificationQueueFirestoreDataSource {
  final FirebaseFirestore firestore;

  NotificationQueueFirestoreDataSourceImpl(this.firestore);

  @override
  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    required String orderId,
    required String type,
  }) async {
    await firestore.collection("notification_queue").add({
      "userId": userId,
      "title": title,
      "body": body,
      "orderId": orderId,
      "type": type,
      "processed": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
