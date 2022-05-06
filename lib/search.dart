import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Search extends ChangeNotifier{
  double searchRadius = 5;
  final geo = Geoflutterfire();
  final _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> results = <DocumentSnapshot>[];
  List<int> rooms = [];
  int baths = 0;
  RangeValues priceRange = RangeValues(0, 10000);

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
    GeoFirePoint geopoint = await getCoordinates(searchLocation);
    getNearbyRentals(geopoint);
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
      results = documentList;
      notifyListeners();
    });
  }

  void addLocation() {
    GeoFirePoint myLocation = geo.point(latitude: 23.752608, longitude: 90.3762569);
    _firestore
        .collection('rentals')
        .add({'name': 'Hillside Place', 'location': myLocation.data});
  }
}
