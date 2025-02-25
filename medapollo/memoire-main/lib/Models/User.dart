import 'package:medapollo/Models/Order.dart';

class User {
  String id;
  String name;
  String last_name;
  String email;
  String password;
  String phone;
  String age;
  String gender;
  List<Order>? orders;
  String adress;

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        last_name = json['last_name'],
        email = json['email'],
        orders =
            json['Order'] != null ? Order.parseOrders(json['Order']) : null,
        password = json['password'],
        phone = json['phone'],
        age = json['age'],
        gender = json['gender'],
        adress = json['adress'];
}
