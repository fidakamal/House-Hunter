import 'package:flutter/material.dart';
import 'package:house_hunter/search.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart' hide Location;

class FloatingButton extends StatelessWidget {
  FloatingButton({Key? key}) : super(key: key);
  final Location location = Location();

  void getLocation(BuildContext context) async {
    Provider.of<Search>(context, listen: false).toggleLoading();
    bool locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationEnabled) {
      locationEnabled = await location.requestService();
      if (!locationEnabled) return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Provider.of<Search>(context, listen: false).currentLocationSearched = true;

    if (placemarks[0].street != null)
      Provider.of<Search>(context, listen: false).textController.text =
          placemarks[0].street!;

    Provider.of<Search>(context, listen: false)
        .seachRentals(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => getLocation(context),
      child: Icon(Icons.gps_fixed_rounded),
      backgroundColor: Colors.cyanAccent[700],
    );
  }
}
