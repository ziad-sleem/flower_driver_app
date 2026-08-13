import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/notifications/repository/notification_queue_repo.dart';

@injectable
class CreateNotificationRequestUseCase {
  final NotificationQueueRepo repo;

  CreateNotificationRequestUseCase(this.repo);

  Future<void> call({
    required String userId,
    required String title,
    required String body,
    required String orderId,
    required String type,
  }) {
    return repo.createNotification(
      userId: userId,
      title: title,
      body: body,
      orderId: orderId,
      type: type,
    );
  }
}
