import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Search {
  late String name;
  late GeoPoint location;
  late double latitude;
  late double longitude;

  void searchRentals(String searchLocation) {
    getCoordinates(searchLocation);
  }

  void getCoordinates(String searchLocation) async {
    List<Location> coordinates = await locationFromAddress(searchLocation);
    print(coordinates);
    latitude = coordinates[0].latitude;
    longitude = coordinates[0].longitude;

    //getNearbyRentals();
  }

  void getNearbyRentals() async {
    final geo = Geoflutterfire();
    final _firestore = FirebaseFirestore.instance;

    // GeoFirePoint myLocation =
    //     geo.point(latitude: 23.7516619, longitude: 90.3747271);
    // _firestore
    //     .collection('rentals')
    //     .add({'name': 'house', 'location': myLocation.data});

    GeoFirePoint center = geo.point(latitude: latitude, longitude: longitude);
    var collectionReference = _firestore.collection('rentals');

    var collection = FirebaseFirestore.instance.collection('rentals');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var name = data['name'];
      print(name);
    }

    double radius = 50;
    String field = 'location';

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field);

    stream.listen((List<DocumentSnapshot> documentList) {
      print(documentList[0].data());
    });
  }
}
