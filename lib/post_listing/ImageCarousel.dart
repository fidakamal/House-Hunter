import 'dart:io';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel(
      {Key? key,
      required this.images,
      required this.removeImage,
      required this.insertImage})
      : super(key: key);

  final List<File> images;
  final Function removeImage;
  final Function insertImage;

  @override
  Widget build(BuildContext context) {
    List<Widget> imageList = images.map((image) {
      return Container(
          constraints: BoxConstraints(maxWidth: 350, maxHeight: 250),
          decoration: BoxDecoration(),
          margin: EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 40),
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: -2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(File(image.path))),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () => removeImage(images.indexOf(image)),
                icon: Icon(Icons.cancel, color: Colors.red[300], size: 30),
              ),
            ),
          ]));
    }).toList();

    imageList.insert(
        0,
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 40),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.grey[200],
              padding: EdgeInsets.zero,
              fixedSize: Size(200, 250),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () => insertImage(),
            child: Icon(Icons.add, size: 50, color: Colors.blueGrey[200]),
          ),
        ));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: imageList),
    );
  }
}
