import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/oreder_details/data/models/order_dto.dart';
import 'package:tracking_app/features/oreder_details/data/models/store_dto.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_order_entity.dart'
    as entity;

part 'driver_order_dto.g.dart';

@JsonSerializable()
class DriverOrderDto {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "driver")
  String? driverId;
  @JsonKey(name: "order")
  OrderDto? order;
  @JsonKey(name: "store")
  StoreDto? store;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;

  DriverOrderDto({
    this.id,
    this.driverId,
    this.order,
    this.store,
    this.createdAt,
    this.updatedAt,
  });

  factory DriverOrderDto.fromJson(Map<String, dynamic> json) =>
      _$DriverOrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DriverOrderDtoToJson(this);

  entity.DriverOrderEntity toEntity() => entity.DriverOrderEntity(
    id: id,
    driverId: driverId,
    order: order?.toEntity(),
    store: store?.toEntity(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
