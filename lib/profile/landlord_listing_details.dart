import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ImageCarousel.dart';
import '../Navigation.dart';
import '../edit_listing/edit_listing.dart';

class LandlordListingDetails extends StatefulWidget {
  const LandlordListingDetails({Key? key}) : super(key: key);

  @override
  State<LandlordListingDetails> createState() => _LandlordListingDetailsState();
}

class _LandlordListingDetailsState extends State<LandlordListingDetails> {
  List<String> images = [];
  bool loadingImages = false;
  DocumentSnapshot? document = null;

  void getImages() async {
    if (document == null) return;

    Future.delayed(Duration.zero, () async {
      setState(() {
        this.images = [];
        loadingImages = true;
      });
    });

    final storage = FirebaseStorage.instance.ref();
    List<String> imageUrls = [];
    ListResult images =
        await storage.child("/rentalImages/${document!.id}").listAll();

    for (var image in images.items) {
      String url = await image.getDownloadURL();
      imageUrls.add(url);
    }

    setState(() {
      this.images = imageUrls;
      loadingImages = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Navigation>(builder: (context, navigation, child) {
      if (navigation.selectedDocument != document) {
        document = navigation.selectedDocument;
        getImages();
      }

      if (loadingImages) {
        return Scaffold(
          body: const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(strokeWidth: 10),
            ),
          ),
        );
      }

      return Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.chevron_left,
                      color: Colors.cyan.shade400,
                      size: 30,
                    ),
                  ),
                  Text(
                    "Listing",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    children: [
                      ImageCarousel(images: images),
                      Container(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset("assets/icons/taka.svg",
                                    height: 26, width: 26),
                                //const SizedBox(width: 10),
                                Text(
                                  document!['rent'].toString(),
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontFamily: "SignikaNegative"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 25),
                                const SizedBox(width: 5),
                                Flexible(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (document!["name"] != "")
                                      Column(
                                        children: [
                                          Text(document!['name'],
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    Text(document!['address'],
                                        style: TextStyle(
                                            fontSize: document!["name"] == ""
                                                ? 18
                                                : 15,
                                            color: Colors.black87)),
                                  ],
                                ))
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.king_bed_outlined, size: 25),
                                const SizedBox(width: 10),
                                Text(
                                  document!['bedrooms'].toString() + " Beds",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black87),
                                ),
                                const SizedBox(width: 40),
                                const Icon(Icons.shower_outlined, size: 25),
                                const SizedBox(width: 10),
                                Text(
                                  document!['baths'].toString() + " Baths",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black87),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            if (document!["size"] != 0)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.straighten_rounded,
                                          size: 25),
                                      const SizedBox(width: 10),
                                      Flexible(
                                          child: Text(
                                              document!['size'].toString() +
                                                  " sq. ft.",
                                              style: const TextStyle(
                                                  fontSize: 17)))
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            Row(
                              children: [
                                const Icon(Icons.local_phone_outlined,
                                    size: 25),
                                const SizedBox(width: 10),
                                Text(document!['phone'],
                                    style: TextStyle(fontSize: 17)),
                              ],
                            ),
                            const SizedBox(height: 30),
                            EditButton(
                              title: "Edit",
                              icon: Icons.edit_note,
                              iconSize: 22,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditListing(document!)),
                                );
                              },
                              color: Colors.cyan.shade400,
                            ),
                            EditButton(
                              title: "Delete",
                              icon: Icons.delete_forever,
                              iconSize: 18,
                              onPressed: () {},
                              color: Colors.red.shade400,
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class EditButton extends StatelessWidget {
  const EditButton(
      {required this.title,
      required this.icon,
      required this.iconSize,
      required this.onPressed,
      required this.color});

  final String title;
  final IconData icon;
  final void Function() onPressed;
  final Color color;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.0),
        child: SizedBox(
          height: 50,
          width: 300,
          child: Material(
            elevation: 5.0,
            color: color,
            borderRadius: BorderRadius.circular(25.0),
            child: MaterialButton(
              onPressed: onPressed,
              minWidth: 200.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      )),
                  SizedBox(width: 5),
                  Icon(icon, size: iconSize, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
