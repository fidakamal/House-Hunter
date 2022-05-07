import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({Key? key, required this.images}) : super(key: key);
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 300.0),
      items: images.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  loadingBuilder: (context, widget, loadingProgress) {
                      if (loadingProgress == null)  return widget;
                      return LoadingIndicator();
                  },
                )
            );
          },
        );
      }).toList(),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SizedBox(
          width: 100,
            height: 100,
            child: CircularProgressIndicator(strokeWidth: 7),
        )
    );
  }
}