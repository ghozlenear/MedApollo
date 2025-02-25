import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medapollo/Constant.dart';
import 'package:medapollo/Models/User.dart';
import 'package:medapollo/Screens/LoginPage.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key, required this.user});
  final User user;
  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(radius: 30, child: FaIcon(FontAwesomeIcons.user)),
        SizedBox(height: 20),
        Text("${widget.user.name} ${widget.user.last_name}"),
        SizedBox(height: 40),
        Container(
          height: 200,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              border: Border.all(color: Constant.Green, width: 2)),
          padding: EdgeInsets.all(16),
          child: widget.user.orders != null && widget.user.orders!.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    return _listTile(index);
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.transparent,
                    );
                  },
                  itemCount: widget.user.orders!.length)
              : Center(
                  child: Text("No orders Yet"),
                ),
        ),
        SizedBox(height: 40),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
          },
          child: Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
                border: Border.all(color: Constant.Green, width: 2)),
            child: Center(
              child: Text(
                "Log Out",
                style: TextStyle(
                    color: Constant.Green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }

  _listTile(int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(16))),
      height: 60,
      child: Center(
          child: Text(
        "${widget.user.orders![index].state} Order",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: widget.user.orders![index].state == "PENDING"
                ? Colors.orange
                : widget.user.orders![index].state == "CONFIRMED"
                    ? Colors.green
                    : Colors.red),
      )),
    );
  }
}
