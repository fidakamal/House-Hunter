import 'package:flutter/material.dart';
import 'package:house_hunter/Navigation.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

enum PageName { map, list, result, messages, profile }

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Navigation>(builder: (context, navigation, child) {
      return Container(
        padding: const EdgeInsets.all(1.0),
        color: Colors.white,
        child: SalomonBottomBar(
          itemPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          currentIndex: navigation.currentPage.index,
          onTap: (i) => navigation.updateCurrentPage(PageName.values[i]),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(
                Icons.map_rounded,
                size: 25.0,
              ),
              title: const Text("Map"),
              selectedColor: Colors.cyan[400],
            ),
            SalomonBottomBarItem(
              icon: const Icon(
                Icons.format_list_bulleted_rounded,
                size: 25.0,
              ),
              title: const Text("List"),
              selectedColor: Colors.cyan[400],
            ),
            SalomonBottomBarItem(
              icon: const Icon(
                Icons.apartment_rounded,
                size: 25.0,
              ),
              title: const Text("Result"),
              selectedColor: Colors.cyan[400],
            ),
            SalomonBottomBarItem(
              icon: const Icon(
                Icons.markunread,
                size: 25.0,
              ),
              title: const Text("Messages"),
              selectedColor: Colors.cyan[400],
            ),
            SalomonBottomBarItem(
              icon: const Icon(
                Icons.account_circle_rounded,
                size: 25.0,
              ),
              title: const Text("Profile"),
              selectedColor: Colors.cyan[400],
            ),
          ],
        ),
      );
    });
  }
}
