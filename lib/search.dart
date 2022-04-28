import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Search {
  late double latitude;
  late double longitude;
  final geo = Geoflutterfire();
  final _firestore = FirebaseFirestore.instance;
  static late List<DocumentSnapshot> searchResults;

  void searchRentals(String searchLocation) async {
    await getCoordinates(searchLocation);
    getNearbyRentals();
  }

  Future<void> getCoordinates(String searchLocation) async {
    List<Location> coordinates = await locationFromAddress(searchLocation);
    print(coordinates);
    latitude = coordinates[0].latitude;
    longitude = coordinates[0].longitude;
  }

  void getNearbyRentals() async {
    GeoFirePoint center = geo.point(latitude: latitude, longitude: longitude);
    var collectionReference = _firestore.collection('rentals');

    double radius = 5;
    String locationField = 'location';

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: locationField);

    stream.listen((List<DocumentSnapshot> documentList) {
      searchResults = documentList;
      print(documentList[0].data());
    });
  }

  void addLocation() {
    GeoFirePoint myLocation =
        geo.point(latitude: 23.752608, longitude: 90.3762569);
    _firestore
        .collection('rentals')
        .add({'name': 'Hillside Place', 'location': myLocation.data});
  }
}
