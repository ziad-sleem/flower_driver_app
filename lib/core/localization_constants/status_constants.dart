import 'package:easy_localization/easy_localization.dart';

class StatusConstants {
  StatusConstants._();

  static String get pending => "status.pending".tr();
  static String get accepted => "status.accepted".tr();
  static String get picked => "status.picked".tr();
  static String get outForDelivery => "status.out_for_delivery".tr();
  static String get arrived => "status.arrived".tr();
  static String get delivered => "status.delivered".tr();
  static String get completed => "status.completed".tr();
  static String get cancelled => "status.cancelled".tr();
}
