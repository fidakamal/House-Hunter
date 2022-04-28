import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'search.dart';

class ResultsListView extends StatefulWidget {
  @override
  State<ResultsListView> createState() => _ResultsListViewState();
}

class _ResultsListViewState extends State<ResultsListView> {
  Stream<List<DocumentSnapshot>> rentals = Search.searchResultsStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: rentals,
      builder: buildRentalList,
    );
  }
}

Widget buildRentalList(
    BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
  if (snapshot.hasData) {
    return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          DocumentSnapshot rental = snapshot.data![index];

          return Text(rental["name"]);
        });
  } else {
    return Text("No data");
  }
}
