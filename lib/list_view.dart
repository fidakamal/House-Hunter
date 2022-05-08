import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house_hunter/Navigation.dart';
import 'package:provider/provider.dart';
import 'bottom_navigation.dart';
import 'search.dart';

class ResultsListView extends StatefulWidget {
  @override
  State<ResultsListView> createState() => _ResultsListViewState();
}

class _ResultsListViewState extends State<ResultsListView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Search>(builder: (context, search, child) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: search.results.length,
            itemBuilder: (context, index) {
              DocumentSnapshot rental = search.results[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Provider.of<Navigation>(context, listen: false)
                        .updateSelectedDocument(rental);
                    Provider.of<Navigation>(context, listen: false)
                        .updateCurrentPage(PageName.result);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                          "https://images.unsplash.com/photo-1572120360610-d971b9d7767c?w=1170&fbclid=IwAR0olI3qR-ezelZl1zj4jV17Ud1me6DgBIw1jKBotiQmKOMgxg6nqpxTD6E"),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 4.0,
                                bottom: 4.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.attach_money_rounded, size: 18),
                                  Text(
                                    rental["rent"].toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(Icons.bed_rounded, size: 15),
                                  SizedBox(width: 3),
                                  Text(rental["bedrooms"].toString() + " Beds"),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.apartment_rounded, size: 15),
                                SizedBox(width: 2),
                                Text(
                                  rental["name"],
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 15),
                                SizedBox(width: 2),
                                Flexible(child: Text(rental["address"], style: TextStyle(fontSize: 15)))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
