import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:medapollo/Models/Med.dart';
import 'package:medapollo/Models/User.dart';
import 'package:medapollo/Screens/CartPage.dart';
import 'package:medapollo/Screens/InfoPage.dart';
import 'package:medapollo/Screens/MainPage.dart';
import 'package:medapollo/Screens/MapPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user, required this.index});
  final User user;
  final int index;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Med>? cart;
  List<Widget Function(List<Med>?, Function(List<Med>?), User user)> pages = [
    (cart, function, user) => MainPage(
          cart: cart,
          updateCart: function,
        ),
    (cart, function, user) => MapPage(),
    (cart, function, user) =>
        CartPage(cart: cart, updateCart: function, user: user),
    (cart, function, user) => InfoPage(user: user),
  ];

  void _updateChildWidget(List<Med>? value) {
    setState(() {
      cart = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _currentIndex = widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Expanded(
              child: Container(
                  child: _currentIndex == 0 || _currentIndex == 2
                      ? pages[_currentIndex](
                          cart, _updateChildWidget, widget.user)
                      : pages[_currentIndex](null, (p0) {}, widget.user)),
            ),
            _buildCustomIconDesign()
          ]),
        ),
      )),
    );
  }

  Widget _buildCustomIconDesign() {
    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: Color(0xff0c18fb),
      strokeColor: Color(0x300c18fb),
      unSelectedColor: Colors.grey[600],
      backgroundColor: Colors.white,
      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.home),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.location_pin),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.account_circle),
        )
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
