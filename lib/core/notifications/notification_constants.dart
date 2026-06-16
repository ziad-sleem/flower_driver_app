import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationConstants {
  NotificationConstants._();

  static const channelId = 'app_notifications';
  static const channelName = 'App Notifications';
  static const channelDescription = 'General app notifications';

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    channelId,
    channelName,
    description: channelDescription,
    importance: Importance.max,
  );
}
