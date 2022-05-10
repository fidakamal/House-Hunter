import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house_hunter/Navigation.dart';
import 'package:house_hunter/profile/user_listing_card.dart';
import 'package:provider/provider.dart';
import 'bottom_navigation.dart';
import 'search.dart';

class ResultsListView extends StatefulWidget {
  @override
  State<ResultsListView> createState() => _ResultsListViewState();
}

class _ResultsListViewState extends State<ResultsListView> {
  List<DocumentSnapshot> docs = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<Search>(builder: (context, search, child) {
      if (search.results != docs) docs = search.results;

      if (search.loading) {
        return Expanded(
          child: const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(strokeWidth: 10),
            ),
          ),
        );
      }

      if (search.lastSearch == "" && docs.isEmpty) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 100.0, right: 100.0, top: 180.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.manage_search_rounded, size: 70),
                  SizedBox(height: 10.0),
                  Text(
                    "Search an area to browse rentals in that area.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black54)),
                ],
              ),
            ),
          ),
        );
      } else if (search.lastSearch != "" && docs.isEmpty) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            "No rentals found in this area",
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
          ),
        );
      } else {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: docs.map((doc) => UserListingCard(
                    doc: doc,
                    onTap: () {
                      Provider.of<Navigation>(context, listen: false).updateSelectedDocument(doc);
                      Provider.of<Navigation>(context, listen: false).updateCurrentPage(PageName.result);
                      },
                  )).toList()),
            ),
          ),
        );
      }
    });
  }
}
