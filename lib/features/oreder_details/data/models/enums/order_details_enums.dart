import 'package:json_annotation/json_annotation.dart';

enum PaymentType {
  @JsonValue('cash')
  cash,

  @JsonValue('visa')
  visa,

  @JsonValue('wallet')
  wallet,
}

enum OrderState {
  @JsonValue('pending')
  pending,

  @JsonValue('accepted')
  accepted,

  @JsonValue('delivered')
  delivered,

  @JsonValue('cancelled')
  cancelled,
}
