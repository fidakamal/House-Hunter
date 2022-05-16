import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:house_hunter/Navigation.dart';
import 'package:house_hunter/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'ImageCarousel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:house_hunter/message.dart';

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
              SizedBox(height: 10.0),
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
            child: CircularProgressIndicator(strokeWidth: 10),
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
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/taka.svg",
                        height: 26, width: 26),
                    //const SizedBox(width: 10),
                    Text(
                      document!['rent'].toString(),
                      style: const TextStyle(
                          fontSize: 25, fontFamily: "SignikaNegative"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 25),
                    const SizedBox(width: 5),
                    Flexible(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (document!["name"] != "")
                          Column(
                            children: [
                              Text(document!['name'],
                                  style: const TextStyle(fontSize: 18)),
                              SizedBox(height: 5),
                            ],
                          ),
                        Text(document!['address'],
                            style: TextStyle(
                                fontSize: document!["name"] == "" ? 18 : 15,
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
                      style: TextStyle(fontSize: 17, color: Colors.black87),
                    ),
                    const SizedBox(width: 40),
                    const Icon(Icons.shower_outlined, size: 25),
                    const SizedBox(width: 10),
                    Text(
                      document!['baths'].toString() + " Baths",
                      style: TextStyle(fontSize: 17, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (document!["size"] != 0)
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.straighten_rounded, size: 25),
                          const SizedBox(width: 10),
                          Flexible(
                              child: Text(
                                  document!['size'].toString() + " sq. ft.",
                                  style: const TextStyle(fontSize: 17)))
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                Row(
                  children: [
                    const Icon(Icons.local_phone_outlined, size: 25),
                    const SizedBox(width: 10),
                    Text(document!['phone'], style: TextStyle(fontSize: 17)),
                  ],
                ),
                const SizedBox(height: 30),
                ContactButton(
                  title: "Call Now",
                  icon: Icons.phone_in_talk_rounded,
                  onPressed: () =>
                      launchUrl(Uri(scheme: "tel", path: document!['phone'])),
                  color: Colors.cyan.shade400,
                ),
                ContactButton(
                    title: "Send Message",
                    icon: Icons.message_outlined,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Message(receiver: document!["user"])
                          )
                      );
                    },
                    color: Colors.cyanAccent.shade700)
              ],
            ),
          ),
        ]),
      );
    });
  }
}

class ContactButton extends StatelessWidget {
  const ContactButton(
      {required this.title,
      required this.icon,
      required this.onPressed,
      required this.color});

  final String title;
  final IconData icon;
  final void Function() onPressed;
  final Color color;

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
                  Icon(icon, size: 17, color: Colors.white),
                  SizedBox(width: 5),
                  Text(title, style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
