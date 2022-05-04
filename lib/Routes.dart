import 'package:flutter/material.dart';
import 'package:house_hunter/bottom_navigation.dart';
import 'package:house_hunter/listing.dart';
import 'package:house_hunter/search_bar.dart';
import 'package:house_hunter/map.dart';

class Routes extends StatelessWidget {
  const Routes({Key? key, required this.currentPage}) : super(key: key);
  final PageName currentPage;

  @override
  Widget build(BuildContext context) {
    switch(currentPage) {
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
        return Stack(
          children: [
            SafeArea(
              child: SearchBar(),
            ),
          ],
        );
      case PageName.result:
        return SafeArea(child:Listing());
      case PageName.profile:
        // TODO: Handle this case.
        break;
    }
    return Container();
  }
  
}