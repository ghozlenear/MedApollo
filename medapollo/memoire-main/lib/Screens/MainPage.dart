import "package:flutter/material.dart";

import "package:medapollo/Constant.dart";
import "package:medapollo/Models/Med.dart";
import "package:medapollo/Screens/SearchPage.dart";
import "package:medapollo/Screens/TypesPage.dart";

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.cart, required this.updateCart});
  final List<Med>? cart;
  final Function(List<Med>?) updateCart;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top) *
              0.3,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 60,
                        height: 60,
                      ),
                      Text(
                        'Med',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Apollo',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: TextField(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => SearchPage(
                                cart: widget.cart,
                                updateCart: widget.updateCart,
                              )),
                        ),
                      );
                    },
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      hintText: "search",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constant.Green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constant.Green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Constant.Green,
                      ),
                    ),
                  ),
                ),
              ]),
        ),
        Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _card('Anti-inflammatory', "inflammation",
                            "anti-inflammatory"),
                        SizedBox(width: 20),
                        _card('anti-biotic', "immune", "anti-biotic"),
                        SizedBox(width: 20),
                        _card("Pain killers", "pain", "PainKiller")
                      ]),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _card(
                            "Osmotic laxative", "stomach", "osmotic laxative"),
                        SizedBox(width: 20),
                        _card("Anti-tussif", "antitussif", "anti-tussif"),
                        SizedBox(width: 20),
                        _card("Anti-diarrhetic", "diarrhea", "anti-diarrhetic")
                      ]),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _card("Anti-reflux", "neuro", "anti-reflux"),
                        SizedBox(width: 20),
                        _card("Pansment", "heartburn", "inhibitors"),
                        SizedBox(width: 20),
                        _card("Supplements", "other", "supplements")
                      ]),
                )
              ],
            ))
      ],
    );
  }

  _navigateToType(String type) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TypesPage(
          cart: widget.cart, updateCart: widget.updateCart, type: type),
    ));
  }

  _card(String label, String image, String type) {
    return GestureDetector(
      onTap: () {
        _navigateToType(type);
      },
      child: Container(
        width: 100,
        height: 130,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 80, child: Image.asset("assets/images/$image.png")),
              Text(
                "${label}",
                style: TextStyle(),
                textAlign: TextAlign.center,
              )
            ]),
      ),
    );
  }
}
