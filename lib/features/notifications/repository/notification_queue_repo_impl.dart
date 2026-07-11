import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/notifications/data_source/notification_queue_firestore_data_source.dart';
import 'package:tracking_app/features/notifications/repository/notification_queue_repo.dart';

@Injectable(as: NotificationQueueRepo)
class NotificationQueueRepoImpl implements NotificationQueueRepo {
  final NotificationQueueFirestoreDataSource firestore;

  NotificationQueueRepoImpl(this.firestore);

  @override
  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    required String orderId,
    required String type,
  }) {
    return firestore.createNotification(
      userId: userId,
      title: title,
      body: body,
      orderId: orderId,
      type: type,
    );
  }
}
