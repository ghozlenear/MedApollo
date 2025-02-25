import 'package:medapollo/Models/Order.dart';

class Pharmacy {
  String id;
  String name;
  String adress;
  String email;
  String password;
  List<Order> orders;

  Pharmacy.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        password = json['password'],
        orders =
            json['orders'].length > 0 ? Order.parseOrders(json['orders']) : [],
        adress = json['adress'];

  static List<Pharmacy> parsePharmacy(List<dynamic> pharmacies) {
    return pharmacies.map((json) => Pharmacy.fromJson(json)).toList();
  }
}
