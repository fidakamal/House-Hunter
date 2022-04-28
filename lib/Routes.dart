import 'package:flutter/material.dart';
import 'package:house_hunter/bottom_navigation.dart';
import 'package:house_hunter/search_bar.dart';
import 'package:house_hunter/map.dart';
import 'profile.dart';

class Routes extends StatelessWidget {
  const Routes({Key? key, required this.currentPage}) : super(key: key);
  final PageName currentPage;

  @override
  Widget build(BuildContext context) {
    switch (currentPage) {
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
        // TODO: Handle this case.
        break;
      case PageName.profile:
        return SafeArea(
          child: Profile(),
        );
    }
    return Container();
  }
}
