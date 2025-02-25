import 'package:medapollo/Models/OrderItem.dart';
import 'package:medapollo/Models/User.dart';

class Order {
  String id;
  List<OrderItem> orderItems;
  User? user;
  String userId;
  String pharmacyId;
  String state;

  Order(this.id, this.orderItems, this.userId, this.pharmacyId, this.state);

  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user = json['user'] != null ? User.fromJson(json['user']) : null,
        pharmacyId = json['pharmacienId'],
        userId = json['userId'],
        state = json['state'],
        orderItems = OrderItem.parseOrderItem(json['orderItems']);

  static List<Order> parseOrders(List<dynamic> orders) {
    return orders.map((json) => Order.fromJson(json)).toList();
  }
}
