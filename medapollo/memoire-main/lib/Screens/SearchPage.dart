import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medapollo/Constant.dart';
import 'package:medapollo/Models/Med.dart';
import 'package:medapollo/Screens/DetailsPage.dart';
import 'package:medapollo/Services/API.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.cart, required this.updateCart});
  final List<Med>? cart;
  final Function(List<Med>?) updateCart;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool search = false;
  TextEditingController queryController = TextEditingController();
  List<Med>? meds = [];
  List<Med>? untouchedMeds;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await API.getMeds(updateMedsState);
  }

  void updateMedsState(List<Med> loadedMeds) {
    setState(() {
      meds = loadedMeds;
      untouchedMeds = loadedMeds;
    });
  }

  _filter(String value) {
    if (value == '') {
      setState(() {
        meds = untouchedMeds;
      });
    } else {
      setState(() {
        meds = untouchedMeds!
            .where((med) =>
                med.name.toLowerCase().contains(value.toLowerCase()) ||
                med.scientific_name.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
                ),
                SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  width: MediaQuery.of(context).size.width * 0.84,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: TextField(
                    onChanged: (value) {
                      _filter(value);
                    },
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      hintText: "search",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top) *
                    0.9,
                padding: EdgeInsets.all(16),
                child: meds!.isNotEmpty
                    ? ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.transparent,
                        ),
                        itemBuilder: (context, index) {
                          return _listTile(index);
                        },
                        itemCount: meds!.length,
                      )
                    : Center(
                        child: Text("No result"),
                      ))
          ]),
        ),
      )),
    );
  }

  _listTile(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) => DetailsPage(
                  med: meds![index],
                  cart: widget.cart,
                  updateCart: widget.updateCart,
                )),
          ),
        );
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              child: Image.network(meds![index].picture),
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${meds![index].name}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "${meds![index].scientific_name}",
                  style: TextStyle(
                      fontSize: 15,
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
                        "${meds![index].price} Da",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
