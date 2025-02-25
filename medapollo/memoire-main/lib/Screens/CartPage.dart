import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medapollo/Models/Med.dart';
import 'package:medapollo/Models/Order.dart';
import 'package:medapollo/Models/OrderItem.dart';
import 'package:medapollo/Models/Pharmacy.dart';
import 'package:medapollo/Models/User.dart';
import 'package:medapollo/Services/API.dart';

class CartPage extends StatefulWidget {
  const CartPage(
      {super.key,
      required this.cart,
      required this.updateCart,
      required this.user});
  final List<Med>? cart;
  final Function(List<Med>?) updateCart;
  final User user;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double? total;
  String pharmacyId = "";
  List<Pharmacy>? pharmacies;
  List<OrderItem>? items;

  void updatePharmacyState(List<Pharmacy> loadedPharmacies) {
    setState(() {
      pharmacies = loadedPharmacies;
    });
  }

  void deleteItem(index) {
    List<Med>? meds = [...widget.cart!];
    meds.removeAt(index);
    widget.updateCart(meds);
    Fluttertoast.showToast(msg: "item removed");
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    createItems();
  }

  _createOrder() async {
    Order order = Order("", items!, widget.user.id, pharmacyId, "PENDING");

    String msg = await API.addOrder(order);
    widget.updateCart([]);
    Fluttertoast.showToast(msg: msg);
    await API.loginReset(widget.user.email, widget.user.password, context);
  }

  _addQuantity(int index) {
    List<OrderItem> list = [...items!];
    list[index].quantity += 1;
    setState(() {
      items = list;
    });
    calculateTotal();
  }

  _reduceQuantity(int index) {
    List<OrderItem> list = [...items!];
    if (list[index].quantity > 1) {
      list[index].quantity -= 1;
      setState(() {
        items = list;
      });
    }
    calculateTotal();
  }

  createItems() {
    List<OrderItem> list = [];
    if (widget.cart != null) {
      for (var med in widget.cart!) {
        var item = OrderItem("", 1, med);
        list.add(item);
      }
      setState(() {
        items = list;
      });
    }
    calculateTotal();
  }

  calculateTotal() {
    if (widget.cart == null) {
      setState(() {
        total = 0;
      });
    } else {
      double totalPrice = 0;

      for (OrderItem item in items!) {
        totalPrice += double.parse(item.medicine!.price) * item.quantity;
      }

      setState(() {
        total = totalPrice;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showDialog();
          },
          child: Text("buy"),
        ),
        body: Container(
          child: Column(children: [
            Container(
              height: 50,
              child: Center(
                  child: Text(
                widget.cart != null && widget.cart!.isNotEmpty
                    ? total.toString() + " Da"
                    : "cart",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )),
            ),
            SizedBox(height: 20),
            widget.cart != null && widget.cart!.length > 0
                ? Expanded(
                    child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return _listTile(index);
                        },
                        separatorBuilder: (context, index) => const Divider(
                              color: Colors.transparent,
                            ),
                        itemCount: widget.cart!.length),
                  ))
                : Expanded(
                    child: Center(
                      child: Text("No items in the cart yet"),
                    ),
                  ),
          ]),
        ));
  }

  _listTile(int index) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
          color: Colors.green[300],
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
              onTap: () {
                deleteItem(index);
              },
              child: FaIcon(FontAwesomeIcons.x)),
          Container(
            width: 60,
            child: Image.network(widget.cart![index].picture),
          ),
          SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.cart![index].name}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "${widget.cart![index].scientific_name}",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black26),
                ),
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${widget.cart![index].price} Da",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 50,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _addQuantity(index);
                    },
                    child: FaIcon(FontAwesomeIcons.plus),
                  ),
                  SizedBox(height: 10),
                  Text("${items![index].quantity}"),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      _reduceQuantity(index);
                    },
                    child: FaIcon(FontAwesomeIcons.minus),
                  ),
                ]),
          )
        ],
      ),
    );
  }

  _showDialog() {
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
                          Text("Pick a pharmacy",
                              style: TextStyle(fontSize: 20)),
                          SizedBox(height: 20),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: FutureBuilder(
                                future: API.getAll(updatePharmacyState),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    return ListView.separated(
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                pharmacyId =
                                                    pharmacies![index].id;
                                              });
                                              _createOrder();
                                            },
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black54)),
                                              child: Center(
                                                  child: Text(
                                                      "${pharmacies![index].name}")),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(
                                              color: Colors.transparent,
                                            ),
                                        itemCount: pharmacies!.length);
                                  } else {
                                    return Center(
                                      child: Text(
                                        "No pharmacies available",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ))));
        });
  }
}
