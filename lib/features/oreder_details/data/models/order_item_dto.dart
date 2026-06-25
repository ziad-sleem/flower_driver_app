import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/oreder_details/data/models/product_dto.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_Item_entity.dart'
    as entity;

part 'order_item_dto.g.dart';

@JsonSerializable()
class OrderItemDto {
  @JsonKey(name: "product")
  dynamic product;
  @JsonKey(name: "price")
  double? price;
  @JsonKey(name: "quantity")
  int? quantity;
  @JsonKey(name: "_id")
  String? id;

  OrderItemDto({this.product, this.price, this.quantity, this.id});

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemDtoToJson(this);

  entity.OrderItemEntity toEntity() => entity.OrderItemEntity(
    product: product is ProductDto ? product.toEntity() : null,
    price: price,
    quantity: quantity,
    id: id,
  );
}
