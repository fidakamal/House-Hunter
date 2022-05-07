import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:house_hunter/Navigation.dart';
import 'package:house_hunter/bottom_navigation.dart';
import 'package:provider/provider.dart';

import 'ImageCarousel.dart';

class Listing extends StatelessWidget {
  Listing({Key? key, required this.document}) : super(key: key);
  final DocumentSnapshot? document;
  var onlineImages = ["https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=1170",
  "https://images.unsplash.com/photo-1572120360610-d971b9d7767c?w=1170"];

  @override
  Widget build(BuildContext context) {
    if (document == null) {
      return Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.search_rounded, size: 70),
            Text("See a house you like?", textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
            SizedBox(height: 20),
            Text("When you tap on a search result, it shows up here. Try it!",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 18, height: 1.5)),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(10, 60),
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  onPressed: () => Provider.of<Navigation>(context, listen: false).updateCurrentPage(PageName.map),
                  child: Text("Start Browsing")
              ),
            )
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(top: 20),
      child: ListView(
          children: [
            ImageCarousel(onlineImages: onlineImages),
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
                      Flexible(child: Text(document!['phone'], style: const TextStyle(fontSize: 20)))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 25),
                      const SizedBox(width: 10),
                      Flexible(child: Text(document!['address'], style: const TextStyle(fontSize: 20)))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.attach_money_rounded, size: 25),
                      const SizedBox(width: 10),
                      Text(document!['rent'].toString(), style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.bed_rounded, size: 25),
                      const SizedBox(width: 10),
                      Text(document!['bedrooms'].toString() + " beds", style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 20),
                      const Icon(Icons.shower_outlined, size: 25),
                      const SizedBox(width: 10),
                      Text(document!['baths'].toString() + " baths", style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.architecture_rounded, size: 25),
                      const SizedBox(width: 10),
                      Flexible(child: Text(document!['size'].toString() + " sq. ft.", style: const TextStyle(fontSize: 20)))
                    ],
                  ),
                ],
              ),
            ),
          ]
      ),
    );
  }
}

