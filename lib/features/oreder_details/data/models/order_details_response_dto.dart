import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/oreder_details/data/models/order_dto.dart';
import 'package:tracking_app/features/oreder_details/data/models/pagination_dto.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart'
    as entity;

part 'order_details_response_dto.g.dart';

@JsonSerializable()
class OrdersResponseDto {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "metadata")
  PaginationDto? metadata;
  @JsonKey(name: "orders")
  List<OrderDto>? orders;

  OrdersResponseDto({this.message, this.metadata, this.orders});

  factory OrdersResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersResponseDtoToJson(this);

  entity.OrdersResponseEntity toEntity() => entity.OrdersResponseEntity(
    message: message,
    metadata: metadata?.toEntity(),
    orders: orders?.map((order) => order.toEntity()).toList(),
  );
}
