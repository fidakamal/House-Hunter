import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'search.dart';

class ResultsListView extends StatefulWidget {
  @override
  State<ResultsListView> createState() => _ResultsListViewState();
}

class _ResultsListViewState extends State<ResultsListView> {
  //Stream<List<DocumentSnapshot>> rentals = Search.searchResultsStream;

  @override
  Widget build(BuildContext context) {
    return Consumer<Search>(builder: (context, search, child) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: search.results.length,
        itemBuilder: (context, index) {
          DocumentSnapshot rental = search.results[index];
          return Card(
            child: InkWell(
              onTap: () {
                print("card tapped");
              },
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Text(rental["name"]),
              ),
            ),
          );
        },
      );
    });
  }
}
