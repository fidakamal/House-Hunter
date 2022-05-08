import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:latlong2/latlong.dart';

class Search extends ChangeNotifier {
  double searchRadius = 1;
  final geo = Geoflutterfire();
  final _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> results = <DocumentSnapshot>[];
  List<int> rooms = [];
  int baths = 0;
  RangeValues priceRange = RangeValues(0, 10000);
  bool loading = false;
  LatLng center = LatLng(23.7937, 90.4066);
  String lastSearch = "";

  void toggleLoading() {
    loading = !loading;
    notifyListeners();
  }

  void updateFilters(List<int> rooms, int baths, RangeValues priceRange) {
    this.rooms = rooms;
    this.baths = baths;
    this.priceRange = priceRange;
  }

  void clearFilters() {
    rooms = [];
    baths = 0;
    priceRange = RangeValues(0, 10000);
  }

  void searchRentals(String searchLocation) async {
    if (searchLocation == "") return;
    toggleLoading();
    try {
      GeoFirePoint geopoint = await getCoordinates(searchLocation);
      lastSearch = searchLocation;
      getNearbyRentals(geopoint);
    } catch (e) {
      print(e);
    }
    toggleLoading();
  }

  Future<GeoFirePoint> getCoordinates(String searchLocation) async {
    List<Location> coordinates = await locationFromAddress(searchLocation);
    return GeoFirePoint(coordinates[0].latitude, coordinates[0].longitude);
  }

  void getNearbyRentals(GeoFirePoint geopoint) async {
    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: _firestore.collection('rentals'))
        .within(center: geopoint, radius: searchRadius, field: "location");

    stream.listen((List<DocumentSnapshot> documentList) {
      results = filterRentals(documentList);
      center = LatLng(geopoint.latitude, geopoint.longitude);
      notifyListeners();
    });
  }

  List<DocumentSnapshot> filterRentals(List<DocumentSnapshot> rentals) {
    if (rooms.isEmpty) {
      rentals.removeWhere((doc) =>
          doc["baths"] < baths + 1 ||
          doc["rent"] < priceRange.start ||
          doc["rent"] > priceRange.end);
    } else {
      rentals.removeWhere((doc) =>
          doc["baths"] < baths + 1 ||
          doc["rent"] < priceRange.start ||
          doc["rent"] > priceRange.end ||
          !rooms.contains(doc["bedrooms"] - 1));
    }
    return rentals;
  }

  void addLocation() {
    GeoFirePoint myLocation =
        geo.point(latitude: 23.752608, longitude: 90.3762569);
    _firestore
        .collection('rentals')
        .add({'name': 'Hillside Place', 'location': myLocation.data});
  }
}
