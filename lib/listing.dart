import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:house_hunter/Navigation.dart';
import 'package:house_hunter/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'ImageCarousel.dart';

class Listing extends StatefulWidget {
  const Listing({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Listing();
}

class _Listing extends State<Listing> {
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

      if (document == null) {
        return Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.home_work_rounded, size: 80),
              SizedBox(
                height: 10.0,
              ),
              Text("See anything you like?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black54)),
              SizedBox(height: 30),
              Text(
                  "When you tap on a listing, a detailed overview will show up here. Try it!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, height: 1.5, color: Colors.black38)),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.cyanAccent[700],
                        padding:
                            EdgeInsets.symmetric(vertical: 17, horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () => navigation.updateCurrentPage(PageName.map),
                    child: Text("Start Browsing")),
              )
            ],
          ),
        );
      }

      if (loadingImages) {
        return const Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              strokeWidth: 10,
            ),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.only(top: 20),
        child: ListView(children: [
          ImageCarousel(images: images),
          Container(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(document!['name'], style: const TextStyle(fontSize: 30)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.phone_rounded, size: 25),
                    const SizedBox(width: 10),
                    Flexible(
                        child: Text(document!['phone'],
                            style: const TextStyle(fontSize: 20)))
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 25),
                    const SizedBox(width: 10),
                    Flexible(
                        child: Text(document!['address'],
                            style: const TextStyle(fontSize: 20)))
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.attach_money_rounded, size: 25),
                    const SizedBox(width: 10),
                    Text(document!['rent'].toString(),
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.bed_rounded, size: 25),
                    const SizedBox(width: 10),
                    Text(document!['bedrooms'].toString() + " beds",
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 20),
                    const Icon(Icons.shower_outlined, size: 25),
                    const SizedBox(width: 10),
                    Text(document!['baths'].toString() + " baths",
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.architecture_rounded, size: 25),
                    const SizedBox(width: 10),
                    Flexible(
                        child: Text(document!['size'].toString() + " sq. ft.",
                            style: const TextStyle(fontSize: 20)))
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    });
  }
}
