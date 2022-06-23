import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

import '../ImageCarousel.dart';
import '../Navigation.dart';

class EditListing extends StatefulWidget {
  EditListing(this.document);

  DocumentSnapshot document;

  @override
  State<EditListing> createState() => _EditListingState();
}

class _EditListingState extends State<EditListing> {
  final _formKey = GlobalKey<FormState>();
  List<int> dropdownOptions = [1, 2, 3, 4, 5];
  late String buildingName, address, contactNo;
  late int rent, beds, baths, squareFeet;
  final _firestore = FirebaseFirestore.instance;
  final geo = Geoflutterfire();
  bool addressEdited = false;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late String documentId;
  List<File> images = [];
  ImagePicker picker = ImagePicker();
  final storage = FirebaseStorage.instance.ref();

  Future<GeoFirePoint> getGeopoint(address) async {
    List<Location> coordinates = await locationFromAddress(address);
    double latitude = coordinates[0].latitude;
    double longitude = coordinates[0].longitude;
    return geo.point(latitude: latitude, longitude: longitude);
  }

  Future<void> editListing() async {
    await widget.document.reference.update({
      "name": buildingName,
      "address": address,
      "rent": rent,
      "bedrooms": beds,
      "baths": baths,
      "size": squareFeet,
      "phone": contactNo,
    });

    if (addressEdited == true) {
      GeoFirePoint geopoint = await getGeopoint(address);
      await widget.document.reference.update({"location": geopoint.data});
    }

    DocumentSnapshot updatedDoc =
        await _firestore.collection("rentals").doc(documentId).get();
    Provider.of<Navigation>(context, listen: false)
        .updateSelectedDocument(updatedDoc);

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    buildingName = widget.document["name"];
    address = widget.document["address"];
    contactNo = widget.document["phone"];
    rent = widget.document["rent"];
    beds = widget.document["bedrooms"];
    baths = widget.document["baths"];
    squareFeet = widget.document["size"];

    documentId = widget.document.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 30.0, right: 30.0, top: 20.0, bottom: 10.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.launch_rounded, size: 28.0),
                      SizedBox(width: 8.0),
                      Text(
                        "Edit Listing",
                        style: TextStyle(
                            fontSize: 30.0, fontFamily: "SignikaNegative"),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  fieldLabel("Name of Apartment Building"),
                  TextFormField(
                    initialValue: widget.document["name"],
                    style: TextStyle(fontSize: 16.0),
                    onChanged: (value) => buildingName = value,
                  ),
                  SizedBox(height: 25.0),
                  fieldLabel("Address"),
                  TextFormField(
                    initialValue: widget.document["address"],
                    style: TextStyle(fontSize: 16.0),
                    onChanged: (value) {
                      address = value;
                      addressEdited = true;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Address is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 25.0),
                  fieldLabel("Rent"),
                  TextFormField(
                    initialValue: widget.document["rent"].toString(),
                    style: TextStyle(fontSize: 16.0),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => rent = int.parse(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Rent is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 25.0),
                  fieldLabel("Beds"),
                  DropdownButtonFormField(
                    hint: Text(widget.document["bedrooms"].toString()),
                    items: dropdownOptions.map((int val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(val.toString()),
                      );
                    }).toList(),
                    onChanged: (int? value) => beds = value!,
                    validator: (value) {
                      if (value == null) {
                        return "Number of beds is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 25.0),
                  fieldLabel("Baths"),
                  DropdownButtonFormField(
                    hint: Text(widget.document["baths"].toString()),
                    items: dropdownOptions.map((int val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(val.toString()),
                      );
                    }).toList(),
                    onChanged: (int? value) => baths = value!,
                    validator: (value) {
                      if (value == null) {
                        return "Number of baths is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 25.0),
                  fieldLabel("Size (sq. ft.)"),
                  TextFormField(
                    initialValue: widget.document["size"].toString(),
                    style: TextStyle(fontSize: 16.0),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => squareFeet = int.parse(value),
                  ),
                  SizedBox(height: 25.0),
                  fieldLabel("Contact No."),
                  TextFormField(
                    initialValue: widget.document["phone"],
                    style: TextStyle(fontSize: 16.0),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => contactNo = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Contact no. is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 30.0),
                  // if (images.isEmpty)
                  //   Container(
                  //     margin: EdgeInsets.only(bottom: 40),
                  //     child: Center(
                  //       child: SizedBox(
                  //         width: 200.0,
                  //         child: ElevatedButton(
                  //           onPressed: () => addImages(),
                  //           child: Text("Add Images",
                  //               style: TextStyle(
                  //                   color: Colors.white, fontSize: 15.0)),
                  //           style: kImageButtonStyle,
                  //         ),
                  //       ),
                  //     ),
                  //   )
                  // else
                  //   ImageCarousel(
                  //     images: images,
                  //     removeImage: (index) => removeImage(index),
                  //     insertImage: () => addImages(),
                  //   ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 120.0,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              editListing();
                            }
                          },
                          child: Text(
                            "Save Changes",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
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
      ),
    );
  }
}

Text fieldLabel(String text) {
  return Text(text,
      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w400));
}

var kButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.cyanAccent[700]),
  padding: MaterialStateProperty.all<EdgeInsets>(
    EdgeInsets.only(top: 16.0, bottom: 16.0),
  ),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
  ),
);

var kCancelButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.cyanAccent[700]),
  padding: MaterialStateProperty.all<EdgeInsets>(
    EdgeInsets.only(top: 16.0, bottom: 16.0),
  ),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
  ),
);
