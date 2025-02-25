import 'package:medapollo/Models/Med.dart';

class OrderItem {
  String id;
  int quantity;
  Med? medicine;

  OrderItem(this.id, this.quantity, this.medicine);
  OrderItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        quantity = json['quantity'],
        medicine =
            json['medicine'] != null ? Med.fromJson(json['medicine']) : null;

  static List<OrderItem> parseOrderItem(List<dynamic> orders) {
    return orders.map((json) => OrderItem.fromJson(json)).toList();
  }
}
