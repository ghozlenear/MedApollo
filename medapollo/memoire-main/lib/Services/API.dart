import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medapollo/Models/Med.dart';
import 'package:medapollo/Models/Order.dart';
import 'package:medapollo/Models/OrderItem.dart';
import 'package:medapollo/Models/Pharmacy.dart';
import 'package:medapollo/Models/User.dart';
import 'package:medapollo/Screens/HomePage.dart';
import 'package:medapollo/Screens/PharmacyPage.dart';

class API {
  static String baseUrl = "http://10.0.2.2:5000/api/";
  static Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final url = Uri.parse('${baseUrl}auth/login');
      final body = jsonEncode({'email': email.trim(), 'password': password});

      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        if (body['entity'] == "user") {
          var user = User.fromJson(body['user']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: ((context) => HomePage(
                    user: user,
                    index: 0,
                  )),
            ),
          );
        } else if (body['entity'] == "pharmacien") {
          var user = Pharmacy.fromJson(body['pharmacien']);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: ((context) => PharmacyPage(
                    user: user,
                  )),
            ),
          );
        }
      } else {
        throw Exception("Wrong Crediantials");
      }
    } catch (error) {
      //   // Handle any exceptions that occurred during the request
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(error.toString()),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  static Future<void> loginReset(
      String email, String password, BuildContext context) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final url = Uri.parse('${baseUrl}auth/login');
      final body = jsonEncode({'email': email.trim(), 'password': password});

      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        var user = User.fromJson(body['user']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) => HomePage(
                  user: user,
                  index: 2,
                )),
          ),
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> registerPharmacy(String email, String password,
      String name, String adress, BuildContext context) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final url = Uri.parse('${baseUrl}auth/signupPharmacy');
      final body = jsonEncode({
        "email": email,
        "password": password,
        "adress": adress,
        "name": name,
      });
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        var user = Pharmacy.fromJson(body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) => PharmacyPage(
                  user: user,
                )),
          ),
        );
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  static Future<void> register(
      String name,
      String lastname,
      String email,
      String phone,
      String password,
      String gender,
      String address,
      String age,
      BuildContext context) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final url = Uri.parse('${baseUrl}auth/signupUser');
      final body = jsonEncode({
        "email": email,
        "age": age,
        "password": password,
        "gender": gender,
        "address": address,
        "last_name": lastname,
        "name": name,
        "phone": phone,
        "adress": address
      });
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var user = User.fromJson(jsonDecode(response.body));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) => HomePage(
                  user: user,
                  index: 0,
                )),
          ),
        );
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  static Future<List<Med>?> getMeds(Function(List<Med>) updateState) async {
    try {
      var url = Uri.parse('${baseUrl}meds/getAll');
      var response = await http.get(url);
      var data = jsonDecode(response.body);

      List<Med> loadedMeds = Med.parseMeds(data);

      updateState(loadedMeds);
      return loadedMeds;
      // return null;
    } catch (err) {
      throw Exception("$err");
    }
  }

  static Future<List<Med>?> getTyped(
      Function(List<Med>) updateState, String type) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final url = Uri.parse('${baseUrl}meds/getType');
      final body = jsonEncode({
        "type": type,
      });
      final response = await http.post(url, headers: headers, body: body);

      final result = jsonDecode(response.body);
      updateState(Med.parseMeds(result));
      if (response.statusCode == 200) {
        return Med.parseMeds(result);
      } else {
        throw Exception("smthn wrong happened");
      }
    } catch (err) {
      throw Exception("$err");
    }
  }

  static Future<List<Pharmacy>> getAll(
      Function(List<Pharmacy>) updateState) async {
    try {
      var url = Uri.parse('${baseUrl}pharmacy/getAll');
      var response = await http.get(url);
      var data = jsonDecode(response.body);

      List<Pharmacy> loadedPharmacies = Pharmacy.parsePharmacy(data);

      updateState(loadedPharmacies);
      return loadedPharmacies;
    } catch (err) {
      throw Exception("$err");
    }
  }

  static Future<String> addOrder(Order order) async {
    try {
      List<Map<String, dynamic>> list = [];

      for (OrderItem item in order.orderItems) {
        list.add({"quantity": item.quantity, "medicineId": item.medicine!.id});
      }

      String meds = jsonEncode(list);
      final headers = {'Content-Type': 'application/json'};
      final url = Uri.parse('${baseUrl}pharmacy/addOrder');
      final body = jsonEncode(
          {"meds": meds, "userId": order.userId, "id": order.pharmacyId});
      await http.post(url, headers: headers, body: body);

      return "Order placed";
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> updateOrder(String id, String state) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final url = Uri.parse('${baseUrl}pharmacy/updateOrder');
      final body = jsonEncode({"orderId": id, "state": state});
      await http.post(url, headers: headers, body: body);

      return "Order Deleted";
    } catch (e) {
      throw Exception(e);
    }
  }
}
