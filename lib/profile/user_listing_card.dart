import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserListingCard extends StatefulWidget {
  UserListingCard({required this.doc});
  DocumentSnapshot doc;
  final String imageUrl = "https://images.unsplash.com/photo-1572120360610-d971b9d7767c?w=1170&fbclid=IwAR0olI3qR-ezelZl1zj4jV17Ud1me6DgBIw1jKBotiQmKOMgxg6nqpxTD6E";

  @override
  State<StatefulWidget> createState() => _UserListingCard();
}

class _UserListingCard extends State<UserListingCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.imageUrl == "")  Image.asset("assets/images/default.png")
            else  Image.network(widget.imageUrl),
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