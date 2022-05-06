import 'package:flutter/material.dart';
import 'package:house_hunter/Navigation.dart';
import 'package:house_hunter/bottom_navigation.dart';
import 'package:house_hunter/listing.dart';
import 'package:house_hunter/search_bar.dart';
import 'package:house_hunter/map.dart';
import 'package:house_hunter/list_view.dart';
import 'package:provider/provider.dart';

class Routes extends StatelessWidget {
  const Routes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Navigation>(builder: (context, navigation, child) {
      switch (navigation.currentPage) {
        case PageName.map:
          return Stack(
            children: [
              Map(),
              SafeArea(
                child: SearchBar(),
              ),
            ],
          );
        case PageName.list:
          return SafeArea(
            child: Column(
              children: <Widget>[
                SearchBar(),
                ResultsListView(),
              ],
            ),
          );
        case PageName.result:
          return SafeArea(
              child: Listing(document: navigation.selectedDocument));
        case PageName.profile:
          // TODO: Handle this case.
          break;
      }
      return Container();
    });
  }
}
