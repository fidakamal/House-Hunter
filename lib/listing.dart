import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'ImageCarousel.dart';

class Listing extends StatelessWidget {
  Listing({Key? key}) : super(key: key);
  var onlineImages = ["https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=1170",
  "https://images.unsplash.com/photo-1572120360610-d971b9d7767c?w=1170"];
  final String houseName = "House Name";
  final String address = "Flat - X, House - X, Road - X, Banani R/A, Dhaka 1213";
  final String phone = "0123456789";
  final int price = 20000;
  final int beds = 3;
  final int baths = 2;
  final int size = 2000;

  @override
  Widget build(BuildContext context) {
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
                  Text(houseName, style: const TextStyle(fontSize: 30)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.phone_rounded, size: 25),
                      const SizedBox(width: 10),
                      Flexible(child: Text(phone, style: const TextStyle(fontSize: 20)))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 25),
                      const SizedBox(width: 10),
                      Flexible(child: Text(address, style: const TextStyle(fontSize: 20)))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.attach_money_rounded, size: 25),
                      const SizedBox(width: 10),
                      Text(price.toString(), style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.bed_rounded, size: 25),
                      const SizedBox(width: 10),
                      Text(beds.toString() + " beds", style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 20),
                      const Icon(Icons.shower_outlined, size: 25),
                      const SizedBox(width: 10),
                      Text(baths.toString() + " baths", style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.architecture_rounded, size: 25),
                      const SizedBox(width: 10),
                      Flexible(child: Text(size.toString() + " sq. ft.", style: const TextStyle(fontSize: 20)))
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

