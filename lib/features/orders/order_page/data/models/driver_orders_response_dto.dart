import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/oreder_details/data/models/pagination_dto.dart';
import 'package:tracking_app/features/orders/order_page/data/models/driver_order_dto.dart';
import 'package:tracking_app/features/orders/order_page/domain/entities/driver_orders_response_entity.dart'
    as entity;

part 'driver_orders_response_dto.g.dart';

@JsonSerializable()
class DriverOrdersResponseDto {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "metadata")
  PaginationDto? metadata;
  @JsonKey(name: "orders")
  List<DriverOrderDto>? orders;

  DriverOrdersResponseDto({this.message, this.metadata, this.orders});

  factory DriverOrdersResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DriverOrdersResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DriverOrdersResponseDtoToJson(this);

  entity.DriverOrdersResponseEntity toEntity() =>
      entity.DriverOrdersResponseEntity(
        message: message,
        metadata: metadata?.toEntity(),
        orders: orders?.map((e) => e.toEntity()).toList(),
      );
}
