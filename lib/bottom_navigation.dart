import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

enum PageName {map, list, result, profile}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key, required this.currentPage, required this.onPageChange}) : super(key: key);
  final PageName currentPage;
  final Function onPageChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SalomonBottomBar(
        currentIndex: currentPage.index,
        onTap: (i) => onPageChange(PageName.values[i]),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.map_rounded),
            title: const Text("Map"),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.list_rounded),
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
  }

}