import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_Item_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/product_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/shipping_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/store_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';

class OrderFirestoreMapper {
  static Map<String, dynamic> toFirestore(OrderEntity order) {
    return {
      "id": order.id,
      "user": order.user,
      "totalPrice": order.totalPrice,
      "paymentType": order.paymentType?.name,
      "isPaid": order.isPaid,
      "isDelivered": order.isDelivered,
      "state": order.state?.name,
      "createdAt": order.createdAt?.toIso8601String(),
      "updatedAt": order.updatedAt?.toIso8601String(),
      "orderNumber": order.orderNumber,
      "paidAt": order.paidAt?.toIso8601String(),

      "store": order.store == null
          ? null
          : {
              "name": order.store!.name,
              "image": order.store!.image,
              "address": order.store!.address,
              "phoneNumber": order.store!.phoneNumber,
              "lat": order.store!.lat,
              "long": order.store!.long,
            },

      "shippingAddress": order.shippingAddress == null
          ? null
          : {
              "street": order.shippingAddress!.street,
              "city": order.shippingAddress!.city,
              "phone": order.shippingAddress!.phone,
              "lat": order.shippingAddress!.lat,
              "long": order.shippingAddress!.long,
            },

      "orderItems":
          order.orderItems
              ?.map(
                (e) => {
                  "id": e.id,
                  "price": e.price,
                  "quantity": e.quantity,
                  "product": {
                    "id": e.product?.id,
                    "title": e.product?.title,
                    "imgCover": e.product?.imgCover,
                    "price": e.product?.price,
                  },
                },
              )
              .toList() ??
          [],
    };
  }

  static OrderEntity fromFirestore(Map<String, dynamic> json) {
    return OrderEntity(
      id: json["id"],

      user: json["user"],

      totalPrice: (json["totalPrice"] as num?)?.toDouble(),

      paymentType: _paymentType(json["paymentType"]),

      state: _orderState(json["state"]),

      isPaid: json["isPaid"],

      isDelivered: json["isDelivered"],

      orderNumber: json["orderNumber"],

      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,

      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,

      paidAt: json["paidAt"] != null ? DateTime.parse(json["paidAt"]) : null,

      store: json["store"] == null
          ? null
          : StoreEntity(
              name: json["store"]["name"],
              image: json["store"]["image"],
              address: json["store"]["address"],
              phoneNumber: json["store"]["phoneNumber"],
              lat: json["store"]["lat"],
              long: json["store"]["long"],
            ),

      shippingAddress: json["shippingAddress"] == null
          ? null
          : ShippingAddressEntity(
              street: json["shippingAddress"]["street"],
              city: json["shippingAddress"]["city"],
              phone: json["shippingAddress"]["phone"],
              lat: json["shippingAddress"]["lat"],
              long: json["shippingAddress"]["long"],
            ),

      orderItems: (json["orderItems"] as List<dynamic>? ?? [])
          .map(
            (e) => OrderItemEntity(
              id: e["id"],
              price: (e["price"] as num?)?.toDouble(),
              quantity: e["quantity"],
              product: ProductEntity(
                id: e["product"]?["id"],
                title: e["product"]?["title"],
                imgCover: e["product"]?["imgCover"],
                price: e["product"]?["price"],
              ),
            ),
          )
          .toList(),
    );
  }

  static PaymentType? _paymentType(String? value) {
    switch (value) {
      case "cash":
        return PaymentType.cash;
      case "visa":
        return PaymentType.visa;
      case "wallet":
        return PaymentType.wallet;
      default:
        return null;
    }
  }

  static OrderState? _orderState(String? value) {
    switch (value) {
      case "pending":
        return OrderState.pending;
      case "inProgress":
        return OrderState.inProgress;
      case "completed":
        return OrderState.completed;
      case "canceled":
        return OrderState.canceled;
      default:
        return null;
    }
  }
}
