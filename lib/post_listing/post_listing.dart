import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:house_hunter/post_listing/ImageCarousel.dart';
import 'package:image_picker/image_picker.dart';

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
  List<File> images = [];
  ImagePicker picker = ImagePicker();

  Future<GeoFirePoint> getGeopoint(address) async {
    List<Location> coordinates = await locationFromAddress(address);
    double latitude = coordinates[0].latitude;
    double longitude = coordinates[0].longitude;
    return geo.point(latitude: latitude, longitude: longitude);
  }

  Future<void> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) loggedInUser = user;
    } catch (e) {
      print(e);
    }
  }

  void post() async {
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
  }

  void addImages() async {
    List<XFile>? images = await picker.pickMultiImage();
    if (images == null) return;
    List<File> imageFiles = images.map((file) => File(file.path)).toList();
    setState(() => this.images.insertAll(0, imageFiles));
  }

  void removeImage(int index) {
    print("Removing " + index.toString());
    setState(() => images.removeAt(index));
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
                Row(
                  children: [
                    Icon(
                      Icons.launch,
                      size: 28.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "Post a Listing",
                      style: TextStyle(
                          fontSize: 30.0, fontFamily: "SignikaNegative"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                fieldLabel("Name of Apartment Building"),
                TextField(
                  style: TextStyle(fontSize: 16.0),
                  onChanged: (value) => buildingName = value,
                ),
                SizedBox(height: 25.0),
                fieldLabel("Address"),
                TextField(
                  style: TextStyle(fontSize: 16.0),
                  onChanged: (value) => address = value,
                ),
                SizedBox(height: 25.0),
                fieldLabel("Rent"),
                TextField(
                  style: TextStyle(fontSize: 16.0),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => rent = int.parse(value),
                ),
                SizedBox(height: 25.0),
                fieldLabel("Beds"),
                DropdownButtonFormField(
                  items: dropdownOptions.map((int val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(val.toString()),
                    );
                  }).toList(),
                  onChanged: (int? value) => beds = value!,
                ),
                SizedBox(height: 25.0),
                fieldLabel("Baths"),
                DropdownButtonFormField(
                  items: dropdownOptions.map((int val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(val.toString()),
                    );
                  }).toList(),
                  onChanged: (int? value) => baths = value!,
                ),
                SizedBox(height: 25.0),
                fieldLabel("Size (sq. ft.)"),
                TextField(
                  style: TextStyle(fontSize: 16.0),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => squareFeet = int.parse(value),
                ),
                SizedBox(height: 25.0),
                fieldLabel("Contact No."),
                TextField(
                  style: TextStyle(fontSize: 16.0),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => contactNo = value,
                ),
                SizedBox(height: 30.0),
                if (images.isEmpty)
                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    child: Center(
                      child: SizedBox(
                        width: 250.0,
                        child: ElevatedButton(
                          onPressed: () => addImages(),
                          child: Text("Add Images",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0)),
                          style: kImageButtonStyle,
                        ),
                      ),
                    ),
                  )
                else
                  ImageCarousel(
                    images: images,
                    removeImage: (index) => removeImage(index),
                    insertImage: () => addImages(),
                  ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120.0,
                      child: ElevatedButton(
                        onPressed: () => post(),
                        child: Text(
                          "Post",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                        style: kButtonStyle,
                      ),
                    ),
                    SizedBox(width: 35.0),
                    SizedBox(
                      width: 120.0,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                        style: kCancelButtonStyle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Text fieldLabel(String text) {
  return Text(text,
      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w400));
}

var kButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.indigo[400]),
  padding: MaterialStateProperty.all<EdgeInsets>(
    EdgeInsets.only(top: 14.0, bottom: 14.0),
  ),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
  ),
);

var kCancelButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.indigo[300]),
  padding: MaterialStateProperty.all<EdgeInsets>(
    EdgeInsets.only(top: 14.0, bottom: 14.0),
  ),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
  ),
);

var kImageButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.cyanAccent[700]),
  padding: MaterialStateProperty.all<EdgeInsets>(
    EdgeInsets.only(top: 8.0, bottom: 8.0),
  ),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  ),
);
