import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostListing extends StatefulWidget {
  const PostListing({Key? key}) : super(key: key);

  @override
  State<PostListing> createState() => _PostListingState();
}

class _PostListingState extends State<PostListing> {
  List<int> dropdownOptions = [1, 2, 3, 4, 5];
  late String buildingName, address, contactNo;
  late int rent, beds, baths, squareFeet;
  final _firestore = FirebaseFirestore.instance;
  final geo = Geoflutterfire();
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  Future<GeoFirePoint> getGeopoint(address) async {
    List<Location> coordinates = await locationFromAddress(address);
    double latitude = coordinates[0].latitude;
    double longitude = coordinates[0].longitude;
    return geo.point(latitude: latitude, longitude: longitude);
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 30.0, right: 30.0, top: 20.0, bottom: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Post a Listing",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: "SignikaNegative",
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Name of Apartment Building",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  style: TextStyle(fontSize: 16.0),
                  onChanged: (value) {
                    buildingName = value;
                  },
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Address",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  style: TextStyle(fontSize: 16.0),
                  onChanged: (value) {
                    address = value;
                  },
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Rent",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  style: TextStyle(fontSize: 16.0),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    rent = int.parse(value);
                  },
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Beds",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DropdownButtonFormField(
                  items: dropdownOptions.map((int val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val.toString(),
                      ),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    beds = value!;
                  },
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Baths",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DropdownButtonFormField(
                  items: dropdownOptions.map((int val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val.toString(),
                      ),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    baths = value!;
                  },
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Square Feet",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  style: TextStyle(fontSize: 16.0),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    squareFeet = int.parse(value);
                  },
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Contact No.",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  style: TextStyle(fontSize: 16.0),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    contactNo = value;
                  },
                ),
                SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          getCurrentUser();
                          GeoFirePoint geopoint = await getGeopoint(address);
                          _firestore.collection("rentals").add({
                            "user": loggedInUser.email,
                            "name": buildingName,
                            "address": address,
                            "rent": rent,
                            "bedrooms": beds,
                            "baths": baths,
                            "size": squareFeet,
                            "phone": contactNo,
                            "location": geopoint.data,
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Post",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                        style: kButtonStyle,
                      ),
                    ),
                    SizedBox(
                      width: 35.0,
                    ),
                    SizedBox(
                      width: 120.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                        style: kButtonStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

var kButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.blue[400]),
  padding: MaterialStateProperty.all<EdgeInsets>(
    EdgeInsets.only(
      top: 14.0,
      bottom: 14.0,
    ),
  ),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
  ),
);
