import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationConstants {
  NotificationConstants._();

  static const String channelId = "tracking_notifications";

  static const String channelName = "Tracking Notifications";

  static const String channelDescription =
      "Notifications related to orders and deliveries.";

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    channelId,
    channelName,
    description: channelDescription,
    importance: Importance.max,
  );
}
