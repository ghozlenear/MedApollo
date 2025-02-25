class Marker {
  double lon;
  double lat;

  Marker(this.lat, this.lon);
  Marker.fromJson(Map<String, dynamic> json)
      : lon = json['lon'],
        lat = json['lat'];

  static List<Marker> parseMarkers(List<dynamic> markers) {
    return markers.map((json) => Marker.fromJson(json['properties'])).toList();
  }
}
