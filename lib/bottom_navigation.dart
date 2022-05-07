import 'package:flutter/material.dart';
import 'package:house_hunter/Navigation.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

enum PageName { map, list, result, profile }

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Navigation>(builder: (context, navigation, child) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: SalomonBottomBar(
          currentIndex: navigation.currentPage.index,
          onTap: (i) => navigation.updateCurrentPage(PageName.values[i]),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.map_rounded),
              title: const Text("Map"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.format_list_bulleted_rounded),
              title: const Text("List"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.house_rounded),
              title: const Text("Result"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person_rounded),
              title: const Text("Profile"),
            ),
          ],
        ),
      );
    });
  }
}
