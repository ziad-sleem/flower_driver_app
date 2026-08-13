import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/orders/data/models/product_dto.dart';
import 'package:tracking_app/features/orders/domain/entities/order_Item_entity.dart'
    as entity;
import 'package:tracking_app/features/orders/domain/entities/product_entity.dart';

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
    product: _parseProduct(),
    price: price,
    quantity: quantity,
    id: id,
  );

  ProductEntity? _parseProduct() {
    final value = product;
    if (value is Map<String, dynamic>) {
      try {
        return ProductDto.fromJson(value).toEntity();
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
