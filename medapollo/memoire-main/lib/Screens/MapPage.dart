import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:medapollo/Models/Maps.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Position? currentPosition;
  List<Marker> markers = [];
  bool loading = true;
  String apiKey = "ddc50141a4d143328eac7116ce50d501";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    bool permission = await _handleLocationPermission();
    if (permission) {
      _getCurrentLocation();
    }
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = position;
      loading = false;
    });
    _getMarkers();
  }

  String generateMarkerString() {
    String markerString = "";

    for (int i = 0; i < markers.length; i++) {
      Marker marker = markers[i];
      markerString +=
          "lonlat:${marker.lon},${marker.lat};type:material;color:%${i == 0 ? "23ff0000" : "231f63e6"}";

      if (i < markers.length - 1) {
        markerString += "|";
      }
    }

    if (markerString.isNotEmpty) {
      return "marker=$markerString&apiKey=${apiKey}";
    } else {
      return "apiKey=${apiKey}";
    }
  }

  void _getMarkers() async {
    var uri = Uri.parse(
        "https://api.geoapify.com/v2/places?categories=healthcare.pharmacy&filter=circle:${currentPosition!.longitude},${currentPosition!.latitude},5000&bias=proximity:${currentPosition!.longitude},${currentPosition!.latitude}&limit=20&apiKey=${apiKey}");

    var response = await http.get(uri);

    var data = jsonDecode(response.body);
    List<Marker> marker = [
      Marker(currentPosition!.latitude, currentPosition!.longitude)
    ];
    marker.addAll(Marker.parseMarkers(data['features']));

    setState(() {
      markers = marker;
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : Image.network(
            "https://maps.geoapify.com/v1/staticmap?style=osm-carto&width=600&height=800&center=lonlat:${currentPosition!.longitude},${currentPosition!.latitude}&zoom=13.2&${generateMarkerString()}");
  }
}
