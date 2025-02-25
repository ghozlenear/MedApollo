import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:medapollo/Models/Med.dart";

class DetailsPage extends StatefulWidget {
  const DetailsPage(
      {super.key,
      required this.med,
      required this.cart,
      required this.updateCart});
  final List<Med>? cart;
  final Function(List<Med>?) updateCart;
  final Med med;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  void addItem() {
    if (widget.cart != null) {
      List<Med>? meds = [...widget.cart!];
      meds.add(widget.med);
      widget.updateCart(meds);
    } else {
      List<Med> meds = [];
      meds.add(widget.med);
      widget.updateCart(meds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: (MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top) *
                  0.4,
              width: double.infinity,
              color: Colors.grey[200],
              child: Stack(children: [
                Center(
                  child: Image.network(widget.med.picture),
                ),
                Positioned(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(
                      FontAwesomeIcons.arrowLeft,
                      size: 40,
                    ),
                  ),
                ))
              ]),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.med.name}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "${widget.med.scientific_name}",
                    style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 50),
                  Expanded(
                    child: ListView.separated(
                      itemCount: widget.med.details.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.transparent,
                      ),
                      itemBuilder: (context, index) {
                        return Text(
                          "- ${widget.med.details[index]}",
                          style: TextStyle(fontSize: 20),
                        );
                      },
                    ),
                  )
                ],
              ),
            )),
            Container(
              height: 90,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 50,
                    child: Center(
                        child: Text(
                      "${widget.med.price} DA",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
                    decoration: BoxDecoration(
                        color: Colors.green[200],
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      addItem();
                      Fluttertoast.showToast(msg: "item added");
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      child: Center(
                        child: FaIcon(
                          Icons.add_shopping_cart_outlined,
                          size: 40,
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.green[300],
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
