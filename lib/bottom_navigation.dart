import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomNavigation();
}

class _BottomNavigation extends State<BottomNavigation> {
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
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