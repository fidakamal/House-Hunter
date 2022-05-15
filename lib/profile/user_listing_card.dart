import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserListingCard extends StatefulWidget {
  UserListingCard({required this.doc, required this.onTap});
  DocumentSnapshot doc;
  Function onTap;

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
    ListResult images =
        await storage.child("/rentalImages/${widget.doc.id}").listAll();
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
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: InkWell(
        onTap: () => widget.onTap(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (loadingImage)
              LoadingIndicator()
            else if (image == "")
              ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                  child: Image.asset("assets/images/default.png"))
            else
              Container(
                  child: Center(
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(2)),
                          child: Image.network(image, fit: BoxFit.fitHeight)))),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/taka.svg",
                            height: 19, width: 19),
                        Text(widget.doc["rent"].toString(),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: "SignikaNegative")),
                        SizedBox(width: 20),
                        Icon(Icons.king_bed_outlined, size: 15),
                        SizedBox(width: 5),
                        Text(
                          widget.doc["bedrooms"].toString() + " Beds",
                          style: TextStyle(
                            fontFamily: "SignikaNegative",
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Icon(Icons.location_on_outlined, size: 18),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.doc["name"] != "")
                              Text(
                                widget.doc["name"],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "SignikaNegative",
                                ),
                              ),
                            Text(
                              widget.doc["address"],
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: "SignikaNegative",
                              ),
                            ),
                          ],
                        ),
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
              child: CircularProgressIndicator(strokeWidth: 5))),
    );
  }
}
