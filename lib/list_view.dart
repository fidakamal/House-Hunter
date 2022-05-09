import 'package:firebase_storage/firebase_storage.dart';
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
  List<String> images = [];
  List<DocumentSnapshot> docs = [];
  bool loadingImages = false;

  void getImages() async {
    if (docs.isEmpty) return;

    Future.delayed(Duration.zero, () async {
      setState(() {
        images = [];
        loadingImages = true;
      });
    });

    final storage = FirebaseStorage.instance.ref();
    List<String> imageUrls = [];
    for (var doc in docs) {
      ListResult images =
          await storage.child("/rentalImages/${doc.id}").listAll();
      if (images.items.isEmpty) {
        imageUrls.add("");
      } else {
        String url = await images.items[0].getDownloadURL();
        imageUrls.add(url);
      }
    }

    setState(() {
      images = imageUrls;
      loadingImages = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Search>(builder: (context, search, child) {
      if (search.results != docs) {
        docs = search.results;
        getImages();
      }

      if (loadingImages) {
        return Expanded(
          child: const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                strokeWidth: 10,
              ),
            ),
          ),
        );
      }

      if (docs.isEmpty) {
        return Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 100.0, right: 100.0, top: 180.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.manage_search_rounded, size: 70),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Search an area to browse rentals in that area.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: images.length,
              itemBuilder: (context, index) {
                DocumentSnapshot rental = docs[index];
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
                        if (images[index] == "")
                          Image.asset("assets/images/default.png")
                        else
                          Image.network(images[index]),
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
                                    Text(rental["rent"].toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(width: 20),
                                    Icon(Icons.bed_rounded, size: 15),
                                    SizedBox(width: 3),
                                    Text(rental["bedrooms"].toString() +
                                        " Beds"),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.apartment_rounded, size: 15),
                                  SizedBox(width: 2),
                                  Text(
                                    rental["name"],
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 15),
                                  SizedBox(width: 2),
                                  Flexible(
                                      child: Text(rental["address"],
                                          style: TextStyle(fontSize: 15)))
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
      }
    });
  }
}
