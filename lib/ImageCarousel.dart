import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({Key? key, required this.onlineImages}) : super(key: key);
  final List<String> onlineImages;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 300.0),
      items: onlineImages.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.network(image, fit: BoxFit.cover)
            );
          },
        );
      }).toList(),
    );
  }
}