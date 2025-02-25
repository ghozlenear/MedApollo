class Med {
  String id;
  String name;
  String scientific_name;
  List<String> details;
  String type;
  String price;
  String picture;
  Med.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        scientific_name = json['scientific_name'] ?? "",
        details = Med.handleDetails(json['details']),
        type = json['type'],
        picture = json['img'],
        price = json['price'].toString();

  static List<Med> parseMeds(List<dynamic> meds) {
    return meds.map((json) => Med.fromJson(json)).toList();
  }

  static List<String> handleDetails(List<dynamic> details) {
    var tempList = details[0].toString().split('-').toList();
    tempList.removeAt(0);
    return tempList;
  }
}
