import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserListingCard extends StatefulWidget {
  UserListingCard({required this.doc});
  DocumentSnapshot doc;

  @override
  State<StatefulWidget> createState() => _UserListingCard();
}

class _UserListingCard extends State<UserListingCard> {
  String image = "";
  bool loadingImage = false;

  void getImage() async {
    Future.delayed(Duration.zero, () async {
      setState(() {
        image = "";
        loadingImage = true;
      });
    });

    final storage = FirebaseStorage.instance.ref();
    String url = "";
    ListResult images = await storage.child("/rentalImages/${widget.doc.id}").listAll();
    if (images.items.isNotEmpty) {
      url = await images.items[0].getDownloadURL();
    }

    setState(() {
      image = url;
      loadingImage = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (loadingImage) LoadingIndicator()
            else if (image == "")  Image.asset("assets/images/default.png")
            else  Container(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: Center(
                      child:Image.network(image)
                  )
              ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.attach_money_rounded, size: 18),
                        Text(
                            widget.doc["rent"].toString(),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 20),
                        Icon(Icons.bed_rounded, size: 15),
                        SizedBox(width: 3),
                        Text(widget.doc["bedrooms"].toString() + " Beds"),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.apartment_rounded, size: 15),
                      SizedBox(width: 2),
                      Text(
                        widget.doc["name"],
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 15),
                      SizedBox(width: 2),
                      Text(
                        widget.doc["address"],
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
          child: SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(strokeWidth: 5)
          )
      ),
    );
  }
}