import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medapollo/Constant.dart';
import 'package:medapollo/Models/OrderItem.dart';
import 'package:medapollo/Models/Pharmacy.dart';
import 'package:medapollo/Screens/LoginPage.dart';
import 'package:medapollo/Services/API.dart';

class PharmacyPage extends StatefulWidget {
  const PharmacyPage({super.key, required this.user});
  final Pharmacy user;
  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.user.orders.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top,
        child: Column(
          children: [
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: FaIcon(
                        FontAwesomeIcons.rightFromBracket,
                        size: 25,
                        color: Colors.red[400],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Orders",
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    width: 60,
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: widget.user.orders.length > 0
                    ? ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.transparent,
                        ),
                        itemBuilder: (context, index) {
                          return widget.user.orders[index].state == "PENDING"
                              ? _listTile(index)
                              : Container();
                        },
                        itemCount: widget.user.orders.length,
                      )
                    : Center(
                        child: Text("No orders"),
                      ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  double calculateTotal(int index) {
    double totalPrice = 0;
    for (OrderItem item in widget.user.orders[index].orderItems) {
      totalPrice += double.parse(item.medicine!.price) * item.quantity;
    }

    return totalPrice;
  }

  _listTile(int orderIndex) {
    widget.user.orders[orderIndex].state;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
        color: Colors.grey[200],
      ),
      padding: EdgeInsets.all(8),
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${widget.user.orders[orderIndex].user!.name}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Container(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.transparent,
                ),
                itemBuilder: (context, index) {
                  return _medTile(index, orderIndex);
                },
                itemCount: widget.user.orders[orderIndex].orderItems.length,
              ),
            ),
          ),
          Container(
            height: 100,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _delete("Order Canceled", orderIndex, "CANCELLED");
                    },
                    child: Container(
                      width: 90,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                          color: Colors.grey[400]),
                      margin: EdgeInsets.only(left: 20),
                      child: Center(child: Text("Cancel")),
                    ),
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${calculateTotal(orderIndex)}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                    TextSpan(text: " Da", style: TextStyle(color: Colors.black))
                  ])),
                  GestureDetector(
                    onTap: () {
                      _showDialog(orderIndex);
                    },
                    child: Container(
                      width: 90,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                          color: Color.fromRGBO(102, 201, 89, 1)),
                      margin: EdgeInsets.only(right: 20),
                      child: Center(child: Text("Confirm")),
                    ),
                  )
                ]),
          )
        ],
      ),
    );
  }

  _delete(String msg, int orderIndex, String state) async {
    await API.updateOrder(widget.user.orders[orderIndex].id, state);
    await API.login(widget.user.email, widget.user.password, context);
    Fluttertoast.showToast(msg: msg);
  }

  _medTile(int index, int orderIndex) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          border: Border.all(color: Constant.Green, width: 2)),
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 20),
          Container(
            width: 100,
            child: Image.network(
                "${widget.user.orders[orderIndex].orderItems[index].medicine!.picture}"),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${widget.user.orders[orderIndex].orderItems[index].medicine!.name}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "${widget.user.orders[orderIndex].orderItems[index].medicine!.scientific_name}",
                  style: TextStyle(
                      fontSize: 15, color: Color.fromRGBO(0, 0, 0, 0.4)),
                ),
                SizedBox(height: 30),
                Text(
                  "${widget.user.orders[orderIndex].orderItems[index].quantity} x ${widget.user.orders[orderIndex].orderItems[index].medicine!.price} Da",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _showDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("name: ${widget.user.orders[index].user!.name}"),
                          SizedBox(height: 10),
                          Text(
                              "last name: ${widget.user.orders[index].user!.last_name}"),
                          SizedBox(height: 10),
                          Text(
                              "adress: ${widget.user.orders[index].user!.last_name}"),
                          SizedBox(height: 10),
                          Text(
                              "phone: ${widget.user.orders[index].user!.phone}"),
                          SizedBox(height: 40),
                          Text("price: ${calculateTotal(index)} Da"),
                          SizedBox(height: 40),
                          GestureDetector(
                            onTap: () {
                              _delete("Order Confirmed", index, "CONFIRMED");
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 90,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                  color: Color.fromRGBO(102, 201, 89, 1)),
                              margin: EdgeInsets.only(right: 20),
                              child: Center(child: Text("Confirm")),
                            ),
                          )
                        ],
                      ))));
        });
  }
}
